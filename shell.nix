{ pkgs, ... }:

let
  pythonPackages = pkgs.python3Packages;
in
pkgs.mkShell {
  buildInputs = with pythonPackages; [
    python
    more-itertools
    pytest
    black
    isort
    pylama
    setuptools
    toml
  ] ++ [ pkgs.gnupg ];
}
