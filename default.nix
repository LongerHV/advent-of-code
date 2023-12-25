{ python3Packages, ... }:

with python3Packages;
buildPythonApplication {
  pname = "aoc";
  version = "2023";
  pyproject = true;
  nativeBuildInputs = [
    more-itertools
    networkx
    setuptools
    wheel
  ];
  src = ./.;
}
