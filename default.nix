{ python3Packages, ... }:

with python3Packages;
buildPythonApplication {
  pname = "aoc";
  version = "2023";
  pyproject = true;
  nativeBuildInputs = [
    setuptools
    wheel
  ];
  src = ./.;
}
