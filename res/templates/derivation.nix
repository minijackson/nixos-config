{ stdenv }:

stdenv.mkDerivation rec {
  pname = "my_package";
  version = "0.1.0";

  nativeBuildInputs = [ ];
  buildInputs = [ ];

  src = ./.;
}
