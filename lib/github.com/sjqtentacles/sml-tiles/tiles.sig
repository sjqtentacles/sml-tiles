signature TILES =
sig
  val lonToTileX : real -> int -> int
  val latToTileY : real -> int -> int
  val tileToLon : int -> int -> int -> real * real
  val tileToLat : int -> int -> int -> real * real
  val tileCenter : int -> int -> int -> Proj.point
end
