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

      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
      labs = lib.getDirs ./lab;
      labPackages = pkgs.lib.attrsets.mergeAttrsList (map (lab: {
        "lab-${lab}" = let path = ./lab + "/${lab}";
        in pkgs.writeShellScriptBin "lab-${lab}" ''
          ${pkgs.mars-mips}/bin/Mars nc p ${path}
        '';
      }) labs);
    in {
      packages.${system} = labPackages;
      devShells = forEachSupportedSystem ({ pkgs }: {
        default = pkgs.mkShell {
          packages = with pkgs; [
            qtspim
            xspim
            mars-mips
            (writeShellScriptBin "mars" ''
              Mars nc $@
            '')
          ];
        };
      });
    };
}
