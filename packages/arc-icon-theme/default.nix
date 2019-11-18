{ override-arc-theme, arc-icon-theme, inkscape, optipng, async }:

(override-arc-theme arc-icon-theme).overrideAttrs (oldAttrs: {

  nativeBuildInputs = oldAttrs.nativeBuildInputs ++ [ inkscape optipng async ];

  patches = [ ./render_icons_async.patch ];

  postPatch = ''
    rm -rf Arc
    substituteInPlace src/render_icons.sh --replace '/usr/bin/inkscape' 'inkscape' --replace '/usr/bin/optipng' 'optipng'
  '' + oldAttrs.postPatch;

  # Re-generate PNG icons from SVG files
  postAutoreconf = ''
    cd src

    # Shut up inkscape's warnings about creating profile directory
    export HOME="$NIX_BUILD_ROOT"
    bash render_icons.sh

    cd ..
  '';
})
