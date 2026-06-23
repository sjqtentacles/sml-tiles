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
```

```sml
Tiles.lonToTileX 0.0 1      (* 1 *)
Tiles.tileCenter 1 1 0      (* center of the NE quadrant tile at zoom 1 *)
```

## Scope and limitations

- Implements the **Web Mercator / EPSG:3857** projection used by XYZ tiles;
  latitudes are valid within the Mercator limit (≈ ±85.05°).
- Pure coordinate math — no tile fetching, caching, image handling, or
  TMS/quadkey addressing.
- `tileToLon`/`tileToLat` return the tile's bounding edges; `tileCenter`
  returns its midpoint as a `Proj.point` (depends on `sml-proj`).

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
  tiles.sml    lon/lat <-> XYZ tile (Web Mercator)
  tiles.mlb
test/
  test.sml     forward/inverse tile coordinates, tile centers
```

## License

MIT. See [LICENSE](LICENSE).
