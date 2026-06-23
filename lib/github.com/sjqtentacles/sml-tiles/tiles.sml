structure Tiles :> TILES =
struct
  val pi = Math.pi
  fun pow2 z = Math.pow (2.0, Real.fromInt z)
  fun lonToTileX lon z =
    Real.trunc ((lon + 180.0) / 360.0 * pow2 z)
  fun latToTileY lat z =
    let val latr = lat * pi / 180.0
                val n = Math.ln (Math.tan latr + 1.0 / Math.cos latr) / pi
    in Real.trunc ((1.0 - n) / 2.0 * pow2 z) end
  fun tileToLon z x _ =
    let val n = pow2 z
        val lon0 = Real.fromInt x / n * 360.0 - 180.0
        val lon1 = Real.fromInt (x + 1) / n * 360.0 - 180.0
    in (lon0, lon1) end
  fun tileToLat z _ y =
    let fun latOf ny =
          let val n = pi - 2.0 * pi * ny / pow2 z
          in 180.0 / pi * Math.atan (Math.sinh n) end
    in (latOf (Real.fromInt (y + 1)), latOf (Real.fromInt y)) end
  fun tileCenter z x y =
    let val (lon0, lon1) = tileToLon z x y
        val (lat0, lat1) = tileToLat z x y
    in { lat = (lat0 + lat1) / 2.0, lon = (lon0 + lon1) / 2.0 } end
end
