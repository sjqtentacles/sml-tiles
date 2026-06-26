# sml-tiles

[![CI](https://github.com/sjqtentacles/sml-tiles/actions/workflows/ci.yml/badge.svg)](https://github.com/sjqtentacles/sml-tiles/actions/workflows/ci.yml)

Slippy-map (Web Mercator) tile math for Standard ML: convert between
longitude/latitude and XYZ tile coordinates, the same scheme used by
OpenStreetMap and most web map tiles.

## API

```sml
Tiles.lonToTileX lon z      (* tile column at zoom z *)
Tiles.latToTileY lat z      (* tile row at zoom z *)
Tiles.tileToLon z x y       (* (westLon, eastLon) edges of a tile *)
Tiles.tileToLat z x y       (* (southLat, northLat) edges of a tile *)
Tiles.tileCenter z x y      (* { lat, lon } center, as a Proj.point *)

type tile   = { z : int, x : int, y : int }
type bounds = { north : real, south : real, east : real, west : real }

Tiles.tileBounds z x y      (* geographic bounding box of a tile *)

(* Bing Maps quadkeys *)
Tiles.quadkey z x y         (* encode -> base-4 string of length z *)
Tiles.quadkeyToTile s       (* decode -> tile (raises Quadkey on bad input) *)

(* tile pyramid navigation *)
Tiles.parent t              (* tile one zoom up (raises Quadkey at z=0) *)
Tiles.children t            (* the four tiles one zoom down *)
Tiles.neighbors t           (* up to 8 same-zoom neighbours, no wraparound *)
```

```sml
Tiles.lonToTileX 0.0 1               (* 1 *)
Tiles.tileBounds 0 0 0               (* { north≈85.05, south≈-85.05, east=180, west=-180 } *)
Tiles.quadkey 3 3 5                  (* "213" *)
Tiles.quadkeyToTile "213"            (* { z=3, x=3, y=5 } *)
Tiles.parent { z=3, x=3, y=5 }       (* { z=2, x=1, y=2 } *)
Tiles.children { z=2, x=1, y=2 }     (* four z=3 tiles *)
Tiles.neighbors { z=1, x=0, y=0 }    (* 3 tiles (corner, no wrap) *)
```

## Scope and limitations

- Implements the **Web Mercator / EPSG:3857** projection used by XYZ tiles;
  latitudes are valid within the Mercator limit (≈ ±85.05°).
- Pure coordinate math — no tile fetching, caching, or image handling.
- `neighbors` does not wrap around the antimeridian or poles; out-of-range
  candidates are dropped.
- `tileCenter`/`tileBounds` depend on `sml-proj` for the `Proj.point` type.

## Installing with smlpkg

```sh
smlpkg add github.com/sjqtentacles/sml-tiles
smlpkg sync
```

Reference from your `.mlb`:

```
lib/github.com/sjqtentacles/sml-tiles/tiles.mlb
```

## Building and testing

```sh
make test        # MLton
make test-poly   # Poly/ML
make all-tests   # both
make clean
```

## Project layout

```
sml.pkg
Makefile
lib/github.com/sjqtentacles/sml-tiles/
  tiles.sig
  tiles.sml    lon/lat <-> XYZ, bounds, quadkeys, parent/children/neighbors
  tiles.mlb
test/
  test.sml     tile coords, tileBounds, quadkey round-trip, pyramid nav
```

## License

MIT. See [LICENSE](LICENSE).
