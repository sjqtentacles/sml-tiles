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

  type tile = { z : int, x : int, y : int }
  type bounds = { north : real, south : real, east : real, west : real }

  exception Quadkey of string

  fun tileBounds z x y =
    let val (lon0, lon1) = tileToLon z x y
        val (lat0, lat1) = tileToLat z x y
    in { west = lon0, east = lon1,
         south = Real.min (lat0, lat1), north = Real.max (lat0, lat1) } end

  (* 2^i for small non-negative i *)
  fun pow2int 0 = 1
    | pow2int i = 2 * pow2int (i - 1)

  fun quadkey z x y =
    let fun digit i =
          let val bit = pow2int (i - 1)
              val xb = (x div bit) mod 2
              val yb = (y div bit) mod 2
              val d = xb + 2 * yb
          in Char.chr (Char.ord #"0" + d) end
        fun loop i acc = if i = 0 then acc else loop (i - 1) (digit i :: acc)
    in String.implode (List.rev (loop z [])) end

  fun quadkeyToTile s =
    let val z = String.size s
        fun step (c, (x, y, i)) =
          let val bit = pow2int (i - 1)
              val (dx, dy) =
                case c of
                    #"0" => (0, 0)
                  | #"1" => (1, 0)
                  | #"2" => (0, 1)
                  | #"3" => (1, 1)
                  | _ => raise Quadkey ("bad digit: " ^ str c)
          in (x + dx * bit, y + dy * bit, i - 1) end
        val (x, y, _) = List.foldl step (0, 0, z) (String.explode s)
    in { z = z, x = x, y = y } end

  fun parent { z, x, y } =
    if z = 0 then raise Quadkey "no parent at zoom 0"
    else { z = z - 1, x = x div 2, y = y div 2 }

  fun children { z, x, y } =
    let val z' = z + 1
        val x0 = x * 2 and y0 = y * 2
    in [ { z = z', x = x0,     y = y0 },
         { z = z', x = x0 + 1, y = y0 },
         { z = z', x = x0,     y = y0 + 1 },
         { z = z', x = x0 + 1, y = y0 + 1 } ] end

  fun neighbors { z, x, y } =
    let val maxc = pow2int z
        val deltas = [(~1,~1),(0,~1),(1,~1),(~1,0),(1,0),(~1,1),(0,1),(1,1)]
        val cand = List.map (fn (dx, dy) => { z = z, x = x + dx, y = y + dy }) deltas
    in List.filter (fn { x, y, ... } => x >= 0 andalso y >= 0 andalso x < maxc andalso y < maxc) cand end
end
