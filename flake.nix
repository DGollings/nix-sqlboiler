{
  description = "SQLBoiler is a tool to generate a Go ORM tailored to your database schema.";

  # Nixpkgs / NixOS version to use.
  inputs.nixpkgs.url = "nixpkgs/nixos-22.11";

  outputs = { self, nixpkgs }:
    let

      # to work with older version of flakes
      lastModifiedDate = self.lastModifiedDate or self.lastModified or "19700101";

      # Generate a user-friendly version number.
      version = "4.13.0";

      # System types to support.
      supportedSystems = [ "x86_64-linux" "x86_64-darwin" "aarch64-linux" "aarch64-darwin" ];

      # Helper function to generate an attrset '{ x86_64-linux = f "x86_64-linux"; ... }'.
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;

      # Nixpkgs instantiated for supported system types.
      nixpkgsFor = forAllSystems (system: import nixpkgs { inherit system; });

    in
    {

      # Provide some binary packages for selected system types.
      packages = forAllSystems (system:
        let
          pkgs = nixpkgsFor.${system};
        in
        {
          sqlboiler = pkgs.buildGoModule {
            pname = "sqlboiler";
            version = version;

            src = pkgs.fetchFromGitHub {
              owner = "volatiletech";
              repo = "sqlboiler";
              rev = "v${version}";
              sha256 = "sha256-vSHr6c06d0b6ZF0YlBAIE7NvBqvcn+phoRlFvP5nlUM=";
            };

            vendorSha256 = "sha256-r8lvsmzo0uiPqSPq2WX7ZMMrl+zYj+c6bta4CGgnUG8";

            checkPhase = [ ];

            meta = with nixpkgs.lib; {
              description = "SQLBoiler is a tool to generate a Go ORM tailored to your database schema.";
              homepage = https://github.com/volatiletech/sqlboiler;
              license = licenses.bsd3;
              maintainers = with maintainers; [ dgollings ];
              platforms = platforms.linux ++ platforms.darwin;
              mainProgram = "sqlboiler";
            };

          };
        });

      # The default package for 'nix build'. This makes sense if the
      # flake provides only one package or there is a clear "main"
      # package.
      defaultPackage = forAllSystems (system: self.packages.${system}.sqlboiler);
    };
}
