(* proj.sig — Web Mercator (EPSG:3857) projection. *)

signature PROJ =
sig
  type point = { lat : real, lon : real }

  val webMercatorForward : point -> real * real
  val webMercatorInverse : real * real -> point
end
