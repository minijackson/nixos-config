self: super: {
  tomorrowPygments = self.callPackage ./tomorrow-pygments { };
  autoEq = self.callPackage ./AutoEq { };
  async = (import <nixpkgs-unstable> {}).async;
  my-arc-icon-theme = self.callPackage ./arc-icon-theme { override-arc-theme = (x: x); };
  fira-mono-italic = self.callPackage ./fira-mono-italic { };
}
