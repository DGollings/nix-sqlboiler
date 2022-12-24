# SQLboiler 
SQLBoiler is a tool to generate a Go ORM tailored to your database schema.
https://github.com/volatiletech/sqlboiler

# Example usage:

flake.nix
``` nix
{
  inputs =
    {
      nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
      flake-utils.url = "github:numtide/flake-utils";
      sqlboiler.url = "github:DGollings/nix-sqlboiler";
    };

  outputs = { self, nixpkgs, flake-utils, sqlboiler }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        devShells.default = pkgs.mkShell {
          nativeBuildInputs = [ pkgs.bashInteractive ];
          buildInputs = [
            sqlboiler.packages.${system}.sqlboiler
          ];
        };
      });
}
```
