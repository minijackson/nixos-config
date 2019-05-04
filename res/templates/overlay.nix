self: super: {
  my_package = self.callPackage ./derivation.nix { };
}
