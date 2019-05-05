{ python36 }:

let
  releaseInfo = builtins.fromJSON (builtins.readFile ./release-info.json);
  python = python36.override {
    packageOverrides = self: super: {
      scipy = super.scipy.overrideAttrs (oldAttrs: rec {
        version = "1.1.0";
        src = self.fetchPypi {
          inherit version;
          inherit (oldAttrs) pname;
          sha256 = "878352408424dffaa695ffedf2f9f92844e116686923ed9aa8626fc30d32cfd1";
        };
      });
    };
  };
  pythonPackages = python.pkgs;
  buildPythonPackage = pythonPackages.buildPythonPackage;
in buildPythonPackage {
  name = "AutoEq";

  propagatedBuildInputs = with pythonPackages; [
    requests
    pillow
    matplotlib
    pandas
    scipy
    numpy
    pypdf2
    ghostscript
    tensorflow
    tabulate
  ];

  src = fetchgit {
    inherit (releaseInfo) url rev sha256;
  };

  format = "other";

  buildPhase = "";
  installPhase = ''
    runHook preInstall

    mkdir -p "$out/${python.sitePackages}"
    mkdir -p "$out/bin"

    cp -r . "$out/${python.sitePackages}"
    chmod +x "$out/${python.sitePackages}/frequency_response.py"

    # Prepend sheband
    echo "#!${python.interpreter}" > $out/bin/frequency_response
    cat frequency_response.py >> $out/bin/frequency_response
    chmod +x $out/bin/frequency_response

    runHook postInstall
  '';

}
