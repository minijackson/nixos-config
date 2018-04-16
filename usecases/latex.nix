{ pkgs, ... }:

let
  myPackages = import ../packages { inherit pkgs; };
# TODO: https://github.com/MozMorris/tomorrow-pygments
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

      microtype
      fontspec
      cm-super

      biber
      biblatex
      biblatex-ieee

      algorithms
      minted

      todonotes

      standalone

      # Dependencies somehow missing
      logreq xstring fvextra ifplatform framed
      # For standalone
      currfile
      ;
  };
in {

  users.extraUsers.minijackson.packages = with pkgs; [
    texliveEnv
    biber
    myPackages.tomorrowPygments
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
      let g:vimtex_compiler_latexmk.options = ['-pdf', '-verbose', '-file-line-error', '-synctex=1', '-interaction=nonstopmode', '-shell-escape', '-use-make', '-xelatex', '-8bit']

      let g:vimtex_view_method = 'zathura'
      let g:vimtex_view_general_viewer = '${pkgs.zathura}/bin/zathura'

      let g:vimtex_fold_enabled = 1
      let g:vimtex_format_enabled = 1

      " From *vimtex-complete-deoplete* documentation
      if !exists('g:deoplete#omni#input_patterns')
        let g:deoplete#omni#input_patterns = {}
      endif
      let g:deoplete#omni#input_patterns.tex = g:vimtex#re#deoplete
    '';

  };
}
