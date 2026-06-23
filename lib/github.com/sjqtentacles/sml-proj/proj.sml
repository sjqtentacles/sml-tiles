structure Proj :> PROJ =
struct
  type point = { lat : real, lon : real }
  val r = 6378137.0

  fun toRad d = d * Math.pi / 180.0
  fun toDeg r = r * 180.0 / Math.pi

  fun webMercatorForward { lat, lon } =
    let val x = r * toRad lon
        val clampLat = Real.max (~85.05112878, Real.min (85.05112878, lat))
        val y = r * Math.ln (Math.tan (Math.pi / 4.0 + toRad clampLat / 2.0))
    in (x, y) end

  fun webMercatorInverse (x, y) =
    let val lon = toDeg (x / r)
        val lat = toDeg (2.0 * Math.atan (Math.exp (y / r)) - Math.pi / 2.0)
    in { lat = lat, lon = lon } end
end
