{
  description = "A Nix-flake-based Shell development environment";

  inputs.nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/0.1.*.tar.gz";

  outputs = { self, nixpkgs }:
    let
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
    in {
      devShells = forEachSupportedSystem ({ pkgs }: {
        default = pkgs.mkShell {
          packages = with pkgs; [
            qtspim
            xspim
            mars-mips
            (writeShellScriptBin "mars" ''
              Mars
            '')
            (writeShellScriptBin "add-exit" ''
              #!/usr/bin/env bash

              for file in $@; do
                  echo "Loading $file..."
                  if test -e "$file"; then
                      echo "File exists: $file"

                      echo "Backing up $file..."
                      cp "$file" "$file.backup"

                      echo "Appending exit to $file..."
                      printf "
              exit:
                  li \$v0, 10
                  syscall
              " >>$file
                  else
                      echo "File not exist: $file"
                      echo "Skipping..."
                  fi
                  echo ""
              done
            '')
          ];
        };
      });
    };
}
