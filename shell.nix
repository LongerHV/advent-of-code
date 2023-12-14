{ pkgs, ... }:

pkgs.mkShell {
  buildInputs = with pkgs; [
    elixir
  ];
}
