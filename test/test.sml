structure Tests = struct
  open Harness
  structure T = Tiles
  fun run () = let
    val () = section "slippy tile z0"
    val () = checkInt "origin x" (0, T.lonToTileX 0.0 0)
    val () = checkInt "origin y" (0, T.latToTileY 0.0 0)
    val () = section "zoom 12 reference"
    val () = checkInt "SF-ish x" (655, T.lonToTileX (~122.4194) 12)
            val c = T.tileCenter 0 0 0
            val () = checkRealTol 1E~3 "center lat" (0.0, #lat c)
  in Harness.run () end
end
