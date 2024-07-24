{
  description = "md-prview";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { nixpkgs, flake-utils, ... }:
    let
      utils = flake-utils;
    in
    utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        formatter = pkgs.nixpkgs-fmt;

        devShell = pkgs.mkShell {
          nativeBuildInputs = with pkgs; [
            gh
            gh-markdown-preview
            lsof
          ];

          shellHook = ''
            port=3333

            if lsof -i:$port > /dev/null; then
              echo "Port $port is in use."
            else
              gh extension install yusukebe/gh-markdown-preview
              touch preview.md
              gh markdown-preview preview.md
            fi
          '';
        };
      }
    );
}
