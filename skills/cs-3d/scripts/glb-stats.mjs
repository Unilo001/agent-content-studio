#!/usr/bin/env node
// glb-stats.mjs: read a binary glTF (.glb) and report triangles, meshes, materials, textures,
// extensions, animations and the world-space bounding box in millimetres; check a role budget
// and optional known dimensions. No dependencies (Node >= 16). Read-only.
//
//   node glb-stats.mjs model.glb [--role hero|background|web|cad] [--size LxWxH] [--json out.json]
//
// --size: known dimensions in mm, any order (compared sorted, tolerance 3 %). Units are assumed
// to be metres (glTF standard); use the register transform for anything else.
// Exit 0 = all PASS, 1 = at least one FAIL, 2 = usage/parse error.
import { readFileSync, writeFileSync, statSync } from 'node:fs';

const BUDGET = {
  hero:       { tris: 20000, bytes: 5 * 1024 * 1024, tex: 2048 },
  background: { tris: 8000,  bytes: 2 * 1024 * 1024, tex: 2048 },
  web:        { tris: 15000, bytes: 1.5 * 1024 * 1024, tex: 1024 },
  cad:        { tris: Infinity, bytes: 8 * 1024 * 1024, tex: 2048 },
};
const args = process.argv.slice(2);
const file = args.find(a => !a.startsWith('--') && !['hero','background','web','cad'].includes(a) && !/^[\d.]+x[\d.]+x[\d.]+$/i.test(a) && !a.endsWith('.json'));
const opt = n => { const i = args.indexOf(n); return i >= 0 ? args[i + 1] : null; };
if (!file) { console.error('usage: glb-stats.mjs model.glb [--role hero|background|web|cad] [--size LxWxH] [--json out.json]'); process.exit(2); }
const role = opt('--role');
if (role && !BUDGET[role]) { console.error('unknown role: ' + role); process.exit(2); }

function parseGlb(buf) {
  if (buf.readUInt32LE(0) !== 0x46546c67) throw new Error('not a GLB (missing glTF magic)');
  let off = 12, json = null, bin = null;
  while (off < buf.length) {
    const len = buf.readUInt32LE(off), type = buf.readUInt32LE(off + 4);
    const data = buf.subarray(off + 8, off + 8 + len);
    if (type === 0x4e4f534a) json = JSON.parse(data.toString('utf8'));
    else if (type === 0x004e4942) bin = data;
    off += 8 + len;
  }
  if (!json) throw new Error('no JSON chunk');
  return { json, bin };
}
const mul = (a, b) => { const o = new Array(16).fill(0); for (let c = 0; c < 4; c++) for (let r = 0; r < 4; r++) for (let k = 0; k < 4; k++) o[c*4+r] += a[k*4+r] * b[c*4+k]; return o; };
function local(n) {
  if (n.matrix) return n.matrix;
  const t = n.translation || [0,0,0], q = n.rotation || [0,0,0,1], s = n.scale || [1,1,1];
  const [x,y,z,w] = q;
  const r = [1-2*(y*y+z*z), 2*(x*y+z*w), 2*(x*z-y*w), 0, 2*(x*y-z*w), 1-2*(x*x+z*z), 2*(y*z+x*w), 0, 2*(x*z+y*w), 2*(y*z-x*w), 1-2*(x*x+y*y), 0, 0,0,0,1];
  return [r[0]*s[0], r[1]*s[0], r[2]*s[0], 0, r[4]*s[1], r[5]*s[1], r[6]*s[1], 0, r[8]*s[2], r[9]*s[2], r[10]*s[2], 0, t[0], t[1], t[2], 1];
}
const apply = (m, p) => [m[0]*p[0]+m[4]*p[1]+m[8]*p[2]+m[12], m[1]*p[0]+m[5]*p[1]+m[9]*p[2]+m[13], m[2]*p[0]+m[6]*p[1]+m[10]*p[2]+m[14]];

let result, fails = 0;
const checks = [];
const check = (name, ok, detail) => { checks.push({ name, status: ok ? 'PASS' : 'FAIL', detail }); if (!ok) fails++; };

try {
  const raw = readFileSync(file);
  const { json: g, bin } = parseGlb(raw);
  const acc = g.accessors || [];
  let tris = 0;
  const meshTris = (mi) => (g.meshes[mi].primitives || []).reduce((s, p) => {
    const mode = p.mode ?? 4;
    const n = p.indices !== undefined ? acc[p.indices].count : acc[p.attributes.POSITION].count;
    return s + (mode === 4 ? n / 3 : mode === 5 || mode === 6 ? Math.max(0, n - 2) : 0);
  }, 0);
  const min = [Infinity, Infinity, Infinity], max = [-Infinity, -Infinity, -Infinity];
  const visit = (ni, parent) => {
    const n = g.nodes[ni], m = mul(parent, local(n));
    if (n.mesh !== undefined) {
      tris += meshTris(n.mesh);
      for (const p of g.meshes[n.mesh].primitives) {
        const a = acc[p.attributes.POSITION];
        if (!a.min || !a.max) continue;
        for (let i = 0; i < 8; i++) {
          const c = [i & 1 ? a.max[0] : a.min[0], i & 2 ? a.max[1] : a.min[1], i & 4 ? a.max[2] : a.min[2]];
          const w = apply(m, c);
          for (let k = 0; k < 3; k++) { min[k] = Math.min(min[k], w[k]); max[k] = Math.max(max[k], w[k]); }
        }
      }
    }
    (n.children || []).forEach(c => visit(c, m));
  };
  const I = [1,0,0,0, 0,1,0,0, 0,0,1,0, 0,0,0,1];
  const scene = (g.scenes || [{ nodes: (g.nodes || []).map((_, i) => i) }])[g.scene || 0];
  (scene.nodes || []).forEach(n => visit(n, I));
  const bboxMm = max.map((v, i) => Math.round((v - min[i]) * 1000 * 10) / 10);
  const imgs = (g.images || []).map(im => {
    const bv = im.bufferView !== undefined ? g.bufferViews[im.bufferView] : null;
    let w = null, h = null;
    if (bv && bin) {
      const d = bin.subarray(bv.byteOffset || 0, (bv.byteOffset || 0) + bv.byteLength);
      if (d[0] === 0x89 && d[1] === 0x50) { w = d.readUInt32BE(16); h = d.readUInt32BE(20); }
      else if (d[0] === 0xff && d[1] === 0xd8) {
        for (let i = 2; i < d.length - 9;) { if (d[i] !== 0xff) { i++; continue; } const mk = d[i+1]; if (mk >= 0xc0 && mk <= 0xc3) { h = d.readUInt16BE(i+5); w = d.readUInt16BE(i+7); break; } i += 2 + d.readUInt16BE(i+2); }
      }
    }
    return { w, h, mime: im.mimeType || null, external: im.uri ? true : false };
  });
  const ext = g.extensionsUsed || [];
  const bytes = statSync(file).size;
  const pivot = { x_mm: Math.round((min[0]+max[0])/2*1000), bottom_y_mm: Math.round(min[1]*1000), z_mm: Math.round((min[2]+max[2])/2*1000) };
  result = { file, bytes, triangles: Math.round(tris), meshes: (g.meshes || []).length, materials: (g.materials || []).length,
    textures: imgs, extensions: ext, animations: (g.animations || []).length, skins: (g.skins || []).length,
    bbox_mm: { x: bboxMm[0], y: bboxMm[1], z: bboxMm[2] }, pivot_offset_mm: pivot, asset_version: g.asset?.version, generator: g.asset?.generator || null };

  check('format', true, 'GLB, glTF ' + result.asset_version);
  check('compression', !ext.some(e => /draco|meshopt|basisu|KTX/i.test(e)), 'extensions: ' + (ext.join(', ') || 'none') + ' (loaders may lack decoders)');
  check('external files', !imgs.some(i => i.external), 'textures embedded');
  check('one scene object', (scene.nodes || []).length > 0, (scene.nodes || []).length + ' root node(s)');
  check('pivot bottom-centre', Math.abs(pivot.bottom_y_mm) <= 2 && Math.abs(pivot.x_mm) <= 5 && Math.abs(pivot.z_mm) <= 5, `offset x ${pivot.x_mm}, bottom ${pivot.bottom_y_mm}, z ${pivot.z_mm} mm (fix in register transform if not)`);
  if (role) {
    const b = BUDGET[role];
    check('triangles', tris <= b.tris, `${Math.round(tris)} <= ${b.tris}`);
    check('file size', bytes <= b.bytes, `${(bytes/1048576).toFixed(2)} MB <= ${(b.bytes/1048576).toFixed(1)} MB`);
    const maxTex = Math.max(0, ...imgs.map(i => Math.max(i.w || 0, i.h || 0)));
    check('texture size', maxTex <= b.tex, `${maxTex} <= ${b.tex}`);
  }
  const sz = opt('--size') || args.find(a => /^[\d.]+x[\d.]+x[\d.]+$/i.test(a));
  if (sz) {
    const want = sz.split(/x/i).map(Number).sort((a, b) => a - b), have = [...bboxMm].sort((a, b) => a - b);
    const dev = want.map((w, i) => Math.abs(have[i] - w) / w);
    check('scale within 3 %', dev.every(d => d <= 0.03), `want ${want.join('x')} mm, have ${have.join('x')} mm, worst deviation ${(Math.max(...dev) * 100).toFixed(1)} %`);
  }
  result.checks = checks;
} catch (e) {
  console.error('error: ' + e.message); process.exit(2);
}

console.log(`${file}\n  ${result.triangles} triangles, ${result.meshes} meshes, ${result.materials} materials, ${result.textures.length} textures, ${result.animations} animations, ${(result.bytes/1048576).toFixed(2)} MB`);
console.log(`  bbox ${result.bbox_mm.x} x ${result.bbox_mm.y} x ${result.bbox_mm.z} mm (x,y,z; Y up)`);
for (const c of checks) console.log(`  ${c.status}  ${c.name}: ${c.detail}`);
const jp = opt('--json'); if (jp) writeFileSync(jp, JSON.stringify(result, null, 2));
process.exit(fails ? 1 : 0);
