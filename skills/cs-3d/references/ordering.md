# Order packages (generation switch off) and intake

The human generates; the package makes that a paste-and-drop job. The human must never guess what is meant, choose settings or find references.

## Folder layout
Created by `scripts/order-package.sh new <package-slug> [asset-slug ...]` under the order folder named in BRAND.md (`$ORDER_DIR` or `--dir`):
```
<dir>/<YYYY-MM-DD>-<package-slug>/
  ORDER.md                  one block per asset
  image-prompts.txt         blocks to paste into an image generator
  prompts.csv               ONE prompt per line: nr,asset_slug,prompt (prompt in double quotes)
  generator-settings.txt    settings for the 3D generator, one block per asset
  references/<asset-slug>/  01-front.jpg 02-side.jpg 03-back.jpg 04-three-quarter.jpg ...
```
Slugs: a-z, 0-9, hyphen. The asset slug becomes the inbox folder name. Number blocks identically in all files (`## 1. pump` / `=== 1. pump ===`). `prompts.csv` must have exactly one line per asset and the same text as the block file.

## ORDER.md block
```
## 1. pump
DELIVER TO: <inbox from BRAND.md>/pump/

Floor pump in low-poly style, standing at the roadside in beat 2 (background, ~1.5 s on screen), reads as
"the workshop before the ride". Done when: one GLB, one object, no text/logo/person, ~65 cm tall, <= 8000
triangles. How: paste block 1 from image-prompts.txt into the image generator (1:1), pick the image with the
whole pump visible, run it in the 3D generator with block 1 of generator-settings.txt, drop pump.glb and the
image in the DELIVER TO folder.
```
What it is, why, where used, done-criteria, how. Nothing more. Say "no references" for pure fantasy objects.

## Image prompt template
English, one object per block, no brand/person/place names. Describe shape, proportions, material, colour.
```
=== 1. <asset-slug> ===
<object: what, shape, proportions, materials, colours>, a single object, centred with generous margin,
full object visible, 3/4 front view from slightly above, plain light-grey seamless studio background,
soft even studio lighting, soft contact shadow, matte materials, clean product render, <style>
Avoid: text, letters, numbers, logo, brand marks, watermark, people, hands, faces, multiple objects,
cropped object, busy background, dramatic shadows
Format: 1:1
```
- Style: `stylised low-poly, flat-shaded, few large facets` (toy/flat look), `clean realistic` when the texture is the subject, `smooth matte clay, single colour` when you apply your own materials.
- Angle: 3/4 front from slightly above gives the 3D generator the most form; flat things (signs, covers) use straight front.
- Background and light are always neutral light grey, even: clean cut-out, honest texture.
- Never ask for several images of the same object from different angles; details drift and the 3D gets worse. One image goes to the 3D generator, which makes its own views; real photos are used for multi-view.
- One object per image. Articulated parts that must move = separate blocks.
- Colours from the BRAND palette if the object goes into branded scenes; respect BRAND.md's reserved colours.

## generator-settings.txt block
```
=== 1. <asset-slug> ===
MODE: image-to-3D (the generated image) | multi-view (references/<slug>/: front required + side/back) | text-to-3D (last resort)
MODEL: detailed | low-poly clean topology
TEXTURE: off (we apply our own materials) | on, standard | on, detailed
MAX TRIANGLES: 20000 hero | 8000 background | 15000 web
TEXTURE SIZE: 2048 | 1024
EXPORT: GLB, single file, name <slug>.glb
DELIVER TO: <inbox>/<slug>/
```
Choosing: image-to-3D suits most props; multi-view when real photos of a physical object exist (2-4 images, front required, same object in the same state); text-to-3D only for trivial forms. Texture off when you apply your own materials (the usual case), on when pattern or wear is the point. Many identical objects are ordered once and copied in code. Always request GLB; other formats cannot be used.

## Reference photos
1. Source: the project's own photos and video stills (footage catalogue; ask cs-audio-edit for the best clips; only privacy-cleaned or consented material).
2. Extract and crop with `scripts/ref-extract.sh` (still at a time or an image, crop, scale to <= 2048 px, strip metadata, number).
3. Angles: front, side, back, plus three-quarter for hard shapes. Subject fills 60-80 % of the frame, sharp, even light across angles, calm background.
4. Privacy: no people, faces, signs, race numbers or logos in any reference. Look at every image before sending. If it cannot be cropped clean, do not use it.

## After delivery
Files in the inbox -> intake in SKILL.md. Record prompt, generator and model version, and task ids in the register `origin` field so the asset can be recreated.
