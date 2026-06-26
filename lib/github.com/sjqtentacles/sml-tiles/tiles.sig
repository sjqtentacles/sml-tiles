signature TILES =
sig
  val lonToTileX : real -> int -> int
  val latToTileY : real -> int -> int
  val tileToLon : int -> int -> int -> real * real
  val tileToLat : int -> int -> int -> real * real
  val tileCenter : int -> int -> int -> Proj.point

  (* A slippy-map tile coordinate. *)
  type tile = { z : int, x : int, y : int }

  (* Geographic bounding box of a tile, in degrees. *)
  type bounds = { north : real, south : real, east : real, west : real }

  (* `tileBounds z x y` is the lat/lon extent covered by tile (z,x,y). *)
  val tileBounds : int -> int -> int -> bounds

  (* Bing Maps quadkey encode/decode. `quadkey z x y` is the base-4 quadkey
     string of length z; `quadkeyToTile` is its inverse (raises `Quadkey` on a
     malformed string). *)
  exception Quadkey of string
  val quadkey : int -> int -> int -> string
  val quadkeyToTile : string -> tile

  (* `parent t` is the tile one zoom level up that contains `t` (raises
     `Quadkey` at zoom 0). `children t` are the four tiles one level down. *)
  val parent : tile -> tile
  val children : tile -> tile list

  (* The up-to-eight orthogonal/diagonal neighbours of `t` at the same zoom,
     dropping any that fall outside the valid [0, 2^z) range (no wraparound). *)
  val neighbors : tile -> tile list
end
