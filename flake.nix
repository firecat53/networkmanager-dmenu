{
  description = "Manage NetworkManager connections with dmenu/rofi/wofi instead of nm-applet";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
  };

  outputs = {
    self,
    nixpkgs,
  }: let
    systems = ["x86_64-linux" "i686-linux" "aarch64-linux"];
    forAllSystems = f:
      nixpkgs.lib.genAttrs systems (system:
        f rec {
          pkgs = nixpkgs.legacyPackages.${system};
          commonPackages = builtins.attrValues {
            inherit
              (pkgs)
              glib
              gobject-introspection
              networkmanager
              ;
            inherit
              (pkgs.python3Packages)
              python
              pygobject3
              ;
          };
        });
  in {
    devShells = forAllSystems ({
      pkgs,
      commonPackages,
    }: {
      default = pkgs.mkShell {
        packages = commonPackages;
      };
    });
    packages = forAllSystems ({
      pkgs,
      commonPackages,
    }: {
      default = pkgs.stdenv.mkDerivation {
        name = "networkmanager_dmenu";
        pname = "networkmanager_dmenu";
        dontBuild = true;
        src = ./.;
        buildInputs = commonPackages ++ [pkgs.python3Packages.wrapPython];
        installPhase = ''

          mkdir -p $out/bin $out/share/applications $out/share/doc/$pname
          cp networkmanager_dmenu $out/bin/
          cp networkmanager_dmenu.desktop $out/share/applications
          cp README.md $out/share/doc/$pname/
          cp config.ini.example $out/share/doc/$pname/
        '';
        postFixup = let
          inherit (pkgs.python3Packages) pygobject3;
        in ''
           makeWrapperArgs="\
          --prefix GI_TYPELIB_PATH : $GI_TYPELIB_PATH \
          --prefix PYTHONPATH : \"$(toPythonPath $out):$(toPythonPath ${pygobject3})\""
           wrapPythonPrograms
        '';
        meta = {
          description = "Manage NetworkManager connections with dmenu/rofi/wofi instead of nm-applet";
          homepage = "https://github.com/firecat53/networkmanager-dmenu";
          license = pkgs.lib.licenses.mit;
          maintainers = ["firecat53"];
          platforms = systems;
        };
      };
    });
  };
}
