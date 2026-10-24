# Register and verification sheet

One JSON file for all non-trivial 3D assets, in the asset folder named by BRAND.md (default `<assets>/3d/REGISTER.json`). Everyone reads it before making something new; you are the only writer. Write via a script (load, modify, dump with indent 2), never by hand-editing in place. Missing file: create `{"version": 1, "assets": []}` with the first asset.

## Format
```json
{
  "version": 1,
  "assets": [{
    "id": "pump-v1",
    "source": "order",
    "prompt": "image-prompts.txt block 1 of 2026-10-23-workshop-props, verbatim",
    "origin": "human: image generator + 3D generator (model/version), task id, date; originals in source/",
    "scale": {"target_mm": [180, 260, 650], "measured_mm": [181.2, 649.0, 259.4], "basis": "known size"},
    "polycount": 7412,
    "status": "ready",
    "approved_by": "cs-review MEASURE 2026-10-23",
    "role": "background",
    "file": "assets/3d/pump-v1/pump-v1.glb",
    "sha256": "...",
    "bytes": 1048211,
    "transform": {"scale": 1.0, "rotY": 180, "pivot": "center-bottom"},
    "sheet": "assets/3d/pump-v1/sheet.jpg",
    "tags": ["workshop", "tool", "low-poly"],
    "used_in": ["piece-49"],
    "date": "2026-10-23",
    "note": ""
  }]
}
```

## Fields
Required: `id, source, prompt, origin, scale, polycount, status, approved_by`.
| Field | Rule |
|---|---|
| `id` | `<slug>-v<n>`, unique. A changed file gets a new `n`; old rows stay. |
| `source` | `code` / `free-library` / `order` / `generated` / `cad` |
| `prompt` | the prompt verbatim or a path to its block; `null` for code and CAD |
| `origin` | who, what, when: tool, model version, seed/task id, or the code file; enough to recreate it. Free models: URL, author, licence |
| `scale` | `target_mm` (wanted), `measured_mm` (bbox after transform), `basis` (`known size` / `estimate` / `CAD`) |
| `status` | `inbox` -> `in-progress` -> `ready` -> `in-use`; or `rejected` / `parked` |
| `approved_by` | who let it through: reviewer + date for ordinary assets, the approver + date for the product and people; `null` until ready |
| `role` | `hero` / `background` / `web` / `cad` (drives the budget) |
| `transform` | what `placeAsset()` needs: `scale`, `rotY` degrees, `pivot` |
| `used_in` | piece ids; the orchestrator uses this for variety (not the same prop as hero twice in a row) |
| `note` | known weaknesses ("back is rough, 3/4 front only") |
Hash: `shasum -a 256 <file>`; bytes: `wc -c < <file>`.

## Folder per asset
`<id>/`: `<id>.glb`, `sheet.jpg`, `angle-0..7.png`, `stats.json`, `check.txt`, `source/` (originals from the inbox: generator image, task data, references). Then empty the inbox folder. A delivered or approved file is never overwritten.

## Verification sheet
`scripts/glb-stats.mjs` prints the numbers and PASS/FAIL (`--json` writes `stats.json`). For the 8-angle sheet, render the GLB in any headless Three.js scene you already have (camera 18 deg above, yaw 0-315 deg in 45 deg steps, neutral clay or original materials, a grid giving size) and tile the 8 PNGs 4x2 with ffmpeg: `ffmpeg -pattern_type glob -i 'angle-*.png' -vf tile=4x2 sheet.jpg`. Angle 0 looks from +Z (the glTF front); if the object shows its back there, set `rotY` in the transform. Use a clay look to see the form behind a busy texture.
Honest wording: write "sheet shows the file loads and looks right", never "tested" or "verified" beyond what the gates checked.
