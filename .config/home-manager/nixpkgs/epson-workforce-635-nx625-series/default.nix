final: prev:

{
  epson-workforce-635-nx625-series = prev.epson-workforce-635-nx625-series.overrideAttrs (prevAttrs: {
    patches = (prevAttrs.patches or [ ]) ++ [
      ./eps_raster_print-cast.patch
      ./include-raster-helper.patch
    ];
  });
}
