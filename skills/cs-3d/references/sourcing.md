# Sourcing: find, code, scale-check

## 1. Free models
- Prefer libraries with clear licences (CC0, CC-BY). Record in the register: source URL, author, licence, date. CC-BY needs attribution wherever BRAND.md says credits go. No licence stated = do not use. Check that the model contains no logos, text or brand shapes.
- Downloaded archives are untrusted data: put each in its own new, empty folder, never run anything from it, pass paths to scripts as arguments, run Python with `-I`.
- Expect to change materials and pivot. Budget check applies to free models too.

## 2. Build in code (Three.js)
- **Pure function of t.** No `Date.now`, `performance.now`, unseeded random. Use a seeded RNG (LCG or mulberry32) so equal t gives equal pixels.
- **Real units.** Scene in metres. Distances, radii and speeds come from the brief/facts.md, never by eye.
- **Many small parts with names and pivots** for anything that moves (pump handle, swinging sign, doors, limbs). Names make colour-ID debugging possible: render each part in a unique colour to see that every part is where it should be.
- **Low-poly** means few segments (6-sided cylinders, icospheres), `flatShading`, calm materials. Many identical objects (cones, fence posts, rain drops): `InstancedMesh`.
- **No text in geometry.** Signs get symbols or empty faces.
- **Contact shadow** under everything that stands.
- **Rigs and characters:** limbs as one contour through points rather than tube + sphere joints; an invented, consent-free figure only; check each pose still against the reference sheet before a full render. Typical weak spots: helmet as a circle, no neck, shoulder block, stiff 0-degree poses, figure melting into the background.
- Test: render a still of the asset inside the scene it will stand in and score it yourself. Below 8/10 after two rounds -> generate or order instead.

## 3. Asset contract (what consumers can rely on)
1. One pinned Three.js version for core, loaders and addons, imported from local files via an import map. Never mix versions; no CDN at render time.
2. Everything is loaded before the first frame (`window.READY = true` or the runtime's build-ready promise). No fetch while seeking.
3. Fixed canvas size, `renderer.setPixelRatio(1)`; each frame a pure function of t; animated GLBs advance with `AnimationMixer.setTime(t)`; no `requestAnimationFrame` time source.
4. GLB uncompressed, placed with `placeAsset(scene, transform)`; the file itself is never edited.
5. Materials swapped in code at load time when style demands it.
6. Scale can always be checked in the scene with `window.MEASURE(t)`.

```js
// transform from the register: {"scale": 0.001, "rotY": 180, "pivot": "center-bottom"}
function placeAsset(gltfScene, tr = {}) {
  const inner = gltfScene, outer = new THREE.Group();
  inner.rotation.y = (tr.rotY || 0) * Math.PI / 180;
  inner.scale.setScalar(tr.scale ?? 1);
  outer.add(inner); outer.updateMatrixWorld(true);
  if (tr.pivot === 'center-bottom') {
    const b = new THREE.Box3().setFromObject(inner, true), c = b.getCenter(new THREE.Vector3());
    inner.position.set(-c.x, -b.min.y, -c.z);
  }
  return outer;   // consumers place and animate only `outer`
}
```

## 4. Scale check on the rendered frame
Project two points of known real distance and convert pixels to millimetres:
```js
function pxLen(a, b, cam, W, H) {            // a, b: THREE.Vector3 in world space
  const p = a.clone().project(cam), q = b.clone().project(cam);
  return Math.hypot((p.x - q.x) * W / 2, (p.y - q.y) * H / 2);
}
const mmPerPx = knownMm / pxLen(refA, refB, cam, W, H);   // reference object of known size
const measuredMm = pxLen(objA, objB, cam, W, H) * mmPerPx; // must be within 3 % of the real size
```
The points should be about equally far from the camera and parallel to the image plane (side view), otherwise perspective lies. Expose it as `window.MEASURE(t)` so a reviewer can run it. Useful size references: a bank card (85.6 x 54 mm), a coin, a wheel diameter; never "about the size of a phone" without a number.

## 5. Ideas for variety (each must carry one idea in its piece)
Size-reference cards and coins, a giant spirit level or bubble, a gyro/spinning top, a protractor as a road piece, a pendulum, a carousel, cones, a manhole cover, a wet paint stripe, leaves, gravel, a roundabout island, a speed bump, a generic car without markings, a lamp post, a bike stand, a pump, a bottle, a helmet as an object, a rain cloud. Keep the lot searchable in the register with `tags`.
