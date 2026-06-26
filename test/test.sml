structure Tests = struct
  open Harness
  structure T = Tiles
  fun tstr ({z,x,y} : T.tile) = "(" ^ Int.toString z ^ "," ^ Int.toString x ^ "," ^ Int.toString y ^ ")"
  fun checkTile name (e, a) = checkString name (tstr e, tstr a)
  fun member t xs = List.exists (fn u => u = t) xs
  fun run () = let
    val () = section "slippy tile z0"
    val () = checkInt "origin x" (0, T.lonToTileX 0.0 0)
    val () = checkInt "origin y" (0, T.latToTileY 0.0 0)
    val () = section "zoom 12 reference"
    val () = checkInt "SF-ish x" (655, T.lonToTileX (~122.4194) 12)
    val c = T.tileCenter 0 0 0
    val () = checkRealTol 1E~3 "center lat" (0.0, #lat c)

    val () = section "tileBounds"
    val b = T.tileBounds 0 0 0
    val () = checkRealTol 1E~3 "z0 west" (~180.0, #west b)
    val () = checkRealTol 1E~3 "z0 east" (180.0, #east b)
    val () = checkRealTol 1E~3 "z0 north" (85.0511, #north b)
    val () = checkRealTol 1E~3 "z0 south" (~85.0511, #south b)
    (* consistency with tileToLon/tileToLat *)
    val b2 = T.tileBounds 4 5 6
    val (lon0, lon1) = T.tileToLon 4 5 6
    val (lat0, lat1) = T.tileToLat 4 5 6
    val () = checkRealTol 1E~6 "west matches tileToLon" (lon0, #west b2)
    val () = checkRealTol 1E~6 "east matches tileToLon" (lon1, #east b2)
    val () = check "north >= south" (#north b2 >= #south b2)

    val () = section "quadkey encode"
    val () = checkString "z0 -> empty" ("", T.quadkey 0 0 0)
    val () = checkString "z1 0,0 -> 0" ("0", T.quadkey 1 0 0)
    val () = checkString "z1 1,0 -> 1" ("1", T.quadkey 1 1 0)
    val () = checkString "z1 0,1 -> 2" ("2", T.quadkey 1 0 1)
    val () = checkString "z1 1,1 -> 3" ("3", T.quadkey 1 1 1)
    val () = checkString "z3 3,5 -> 213" ("213", T.quadkey 3 3 5)

    val () = section "quadkey decode (round-trip)"
    val () = checkTile "decode 213" ({z=3,x=3,y=5}, T.quadkeyToTile "213")
    val () = checkTile "decode 0" ({z=1,x=0,y=0}, T.quadkeyToTile "0")
    val () = checkTile "decode empty -> z0" ({z=0,x=0,y=0}, T.quadkeyToTile "")
    val () = checkRaises "decode bad char raises" (fn () => T.quadkeyToTile "21x")

    val () = section "parent / children"
    val () = checkTile "parent of (3,3,5)" ({z=2,x=1,y=2}, T.parent {z=3,x=3,y=5})
    val () = checkRaises "parent at z0 raises" (fn () => T.parent {z=0,x=0,y=0})
    val kids = T.children {z=2,x=1,y=2}
    val () = checkInt "four children" (4, List.length kids)
    val () = check "child (3,2,4)" (member {z=3,x=2,y=4} kids)
    val () = check "child (3,3,4)" (member {z=3,x=3,y=4} kids)
    val () = check "child (3,2,5)" (member {z=3,x=2,y=5} kids)
    val () = check "child (3,3,5)" (member {z=3,x=3,y=5} kids)

    val () = section "neighbors"
    (* corner tile (1,0,0): only 3 valid neighbors (no wrap) *)
    val ns = T.neighbors {z=1,x=0,y=0}
    val () = checkInt "corner has 3 neighbors" (3, List.length ns)
    val () = check "neighbor (1,1,0)" (member {z=1,x=1,y=0} ns)
    val () = check "neighbor (1,0,1)" (member {z=1,x=0,y=1} ns)
    val () = check "neighbor (1,1,1)" (member {z=1,x=1,y=1} ns)
    val () = check "does not include self" (not (member {z=1,x=0,y=0} ns))
    (* interior tile at z=4 has all 8 neighbors *)
    val ns2 = T.neighbors {z=4,x=8,y=8}
    val () = checkInt "interior has 8 neighbors" (8, List.length ns2)
  in Harness.run () end
end

