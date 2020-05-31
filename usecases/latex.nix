{ pkgs, config, ... }:

let
# TODO: add latexmkrc
  texliveEnv = with pkgs; texlive.combine {
    inherit (texlive)
      scheme-small

      latexmk
      texdoc
      # Needed for texdoc but somehow not automatically added
      luatex

      collection-langenglish
      collection-langfrench
      csquotes

      glossaries
      glossaries-english
      glossaries-french
      glossaries-extra

      microtype
      fontspec
      lm-math
      cm-super
      a4wide

      biber
      biblatex
      biblatex-ieee
      biblatex-apa

      nath
      stmaryrd

      placeins
      wrapfig

      algorithms
      algorithmicx
      minted

      asymptote

      todonotes

      standalone

      cleveref
      xurl
      # For varioref
      tools

      footmisc

      morewrites

      # For Metropolis Beamer theme
      pgfopts

      beamertheme-metropolis
      beamercolorthemeowl

      # Dependencies somehow missing
      logreq xstring fvextra ifplatform framed
      # For standalone
      currfile
      # For glossaries
      xindy mfirstuc xfor datatool tracklang
      # For datatool
      substr
      # For asymptote
      everypage media9 ocgx2
      ;
  };
in {

  users.extraUsers.minijackson.packages = with pkgs; [
    texliveEnv
    biber
    tomorrowPygments
    asymptote ghostscript
    xdotool
  ];

  # Fira Code is nice for code reading
  fonts.fonts = with pkgs; [ fira-code cm_unicode ];

  vim = {

    extraPlugins = [
      { name = "vimtex"; }
    ];

    extraConfig = ''
      " Disbale LaTeX-Box
      let g:polyglot_disabled = [ 'latex' ]

      let g:vimtex_compiler_latexmk = {}
      let g:vimtex_compiler_latexmk.build_dir = './latexmk-build'
      let g:vimtex_compiler_latexmk.options = ['-verbose', '-file-line-error', '-synctex=1', '-interaction=nonstopmode', '-shell-escape', '-use-make', '-8bit']

      " Set default engine to be XeLaTeX
      let g:vimtex_compiler_latexmk_engines = { '_': '-xelatex' }

      let g:vimtex_view_method = 'zathura'
      let g:vimtex_view_general_viewer = '${pkgs.zathura}/bin/zathura'

      let g:vimtex_fold_enabled = 1
      let g:vimtex_format_enabled = 1

      " From *vimtex-complete-deoplete* documentation
      call deoplete#custom#var('omni', 'input_patterns', { 'tex': g:vimtex#re#deoplete })
    '';

  };
}
