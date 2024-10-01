{
  description = "computer architecture (MIPS)";

  inputs.nixpkgs.url = "nixpkgs/nixos-24.05";
  inputs.nix-lib-monadam.url = "github:adam-neeley/nix-lib-monadam";

  outputs = { self, nixpkgs, nix-lib-monadam }:
    let
      inherit (nix-lib-monadam) lib;
      labs = lib.paths.getDirs ./lab;
    in {
      packages = lib.flakes.forAllSystems ({ pkgs }:
        pkgs.lib.attrsets.mergeAttrsList (map (lab: {
          "lab-${lab}" = pkgs.writeShellScriptBin "lab-${lab}" ''
            LABPATH=${./lab}/${lab}/
            cd ``$LABPATH
            ${pkgs.mars-mips}/bin/Mars p .
          '';
        }) labs));
      devShells = lib.flakes.forAllSystems ({ pkgs }: {
        default = pkgs.mkShell { packages = with pkgs; [ mars-mips ]; };
      });
    };
}
