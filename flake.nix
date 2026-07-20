{
  description = "This fork of Prism Launcher adds integrated support for Ely.by accounts.";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      systems = [ "x86_64-linux" "aarch64-linux" ];
      forAllSystems = nixpkgs.lib.genAttrs systems;
    in
    {
      packages = forAllSystems (system:
        let
          pkgs = import nixpkgs { inherit system; };
        in
        {
          pineconemc = pkgs.callPackage ./package.nix { };
          default = self.packages.${system}.pineconemc;
        }
      );
      overlays.default = final: prev: {
        pineconemc = final.callPackage ./package.nix { };
      };
    };
}