{ pkgs, ... }:

let
  pythonPackages = pkgs.python3Packages;
  types-networkx =
    let
      pname = "types-networkx";
      version = "3.1.0.20231220";
    in
    pythonPackages.buildPythonPackage {
      inherit pname version;
      src = pkgs.fetchPypi {
        inherit pname version;
        sha256 = "sha256-ikAz9jGqoVEpob6MFNw6lj1/BL7Zev9kYJIBw5w0nN0=";
      };
      doCheck = false;
    };
in
pkgs.mkShell {
  buildInputs = with pythonPackages; [
    python
    more-itertools
    networkx
    types-networkx
    pytest
    black
    isort
    pylama
    setuptools
    toml
  ] ++ [ pkgs.gnupg ];
}
