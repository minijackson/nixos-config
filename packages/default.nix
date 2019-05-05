self: super: {
  tomorrowPygments = self.callPackage ./tomorrow-pygments { };
  autoEq = self.callPackage ./AutoEq { };
}
