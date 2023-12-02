{ pkgs, ... }:

let
  pythonPackages = pkgs.python3Packages;
in
pkgs.mkShell {
  buildInputs = with pythonPackages; [
    python
    pytest
    black
    isort
    pylama
    setuptools
    toml
  ];
}
