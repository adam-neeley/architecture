{
  description = "A Nix-flake-based Shell development environment";

  inputs.nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/0.1.*.tar.gz";
  inputs.nix-lib-monadam.url = "github:adam-neeley/nix-lib-monadam";

  outputs = { self, nixpkgs, nix-lib-monadam }:
    let
      inherit (nix-lib-monadam) lib;
      supportedSystems =
        [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
      forEachSupportedSystem = f:
        nixpkgs.lib.genAttrs supportedSystems (system:
          f {
            pkgs = import nixpkgs {
              inherit system;
              config.allowUnfree = true;
            };
          });

      labs = lib.getDirs ./lab;
    in {
      packages = forEachSupportedSystem ({ pkgs }:
        pkgs.lib.attrsets.mergeAttrsList (map (lab: {
          "lab-${lab}" = pkgs.writeShellScriptBin "lab-${lab}" ''
            LABPATH=${./lab}/${lab}/
            cd ``$LABPATH
            ${pkgs.mars-mips}/bin/Mars p .
          '';
        }) labs));
      devShells = forEachSupportedSystem ({ pkgs }: {
        default = pkgs.mkShell {
          packages = with pkgs;
            [
              # qtspim
              # xspim
              mars-mips
            ];
        };
      });
    };
}
