# One Last Job

A Godot 4 prototype: a screen of selectable "cell" boxes flanked by compute
and alarm boxes. Navigate a selector across the cell grid with the arrow keys.

## Progress

| System | Status |
|---|---|
| Box grid generation (`game.gd`) | Done — positions any `box_count` grid inside screen margins |
| Cell / compute / alarm box layout | Done — three grids instantiate at startup |
| Selector movement | Done — arrow keys, clamped to the cell grid |
| Interaction on selected cell (space) | Stubbed — no gameplay yet |
| Shader test scene | Works — assigns `myshader.gdshader` to a ColorRect at runtime |

## TODO

- [ ] Wire up gameplay to the space press/release on the selected cell
- [ ] Remove debug prints and debug drawing helpers (or gate them behind a flag)
- [ ] Clean up `box.gd` (`_ready` early-returns, commented-out code, leftover prints)

## Project layout

- `scenes/` — `game.tscn` (main), `box.tscn`
- `scripts/` — `game.gd` (main scene logic), `box.gd` (box template), `xy_label.gd` (cursor debug label), `color_rect_2.gd` (shader test)
- `shaders/` — `myshader.gdshader`
