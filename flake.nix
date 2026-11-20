{
  description = "Figurine: ASCII art hostname greeting at login";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs }:
    let
      version = "2.1.1";

      # Prebuilt upstream release assets; hashes from the release's CHECKSUM file.
      assets = {
        x86_64-linux = { arch = "linux_amd64"; sha256 = "f2b1c076942c94009d133df0f304a234a0994bf590b40f2927668324d578306a"; };
        aarch64-linux = { arch = "linux_arm64"; sha256 = "611550ddb31a75437be3f8587bcdd029d0d890f4d820b7f494a2c6615fecba10"; };
        armv7l-linux = { arch = "linux_arm"; sha256 = "429e66bded486d49f730c4a6559e728cd1e9a163a0f56a85867e2cbec010171d"; };
        aarch64-darwin = { arch = "darwin_arm64"; sha256 = "aba6114fb1d11ec70b260a59b0b26431558b9c3894813a4885c6310b47dd0e74"; };
      };

      forAllSystems = f: nixpkgs.lib.genAttrs (builtins.attrNames assets)
        (system: f system nixpkgs.legacyPackages.${system});
    in
    {
      packages = forAllSystems (system: pkgs: rec {
        figurine = pkgs.stdenvNoCC.mkDerivation {
          pname = "figurine";
          inherit version;
          src = pkgs.fetchurl {
            url = "https://github.com/arsham/figurine/releases/download/v${version}/figurine_${assets.${system}.arch}_v${version}.tar.gz";
            inherit (assets.${system}) sha256;
          };
          sourceRoot = ".";
          installPhase = "install -Dm755 deploy/figurine $out/bin/figurine";
          meta = {
            description = "Print text in FIGlet fonts with rainbow colours";
            homepage = "https://github.com/arsham/figurine";
            license = nixpkgs.lib.licenses.asl20;
            mainProgram = "figurine";
            platforms = builtins.attrNames assets;
          };
        };
        default = figurine;
      });

      nixosModules.default = { config, lib, pkgs, ... }:
        let cfg = config.programs.figurine;
        in {
          options.programs.figurine = {
            enable = lib.mkEnableOption "figurine hostname greeting on login";
            font = lib.mkOption {
              type = lib.types.str;
              default = "3d.flf";
              description = "FIGlet font to render the hostname with.";
            };
          };

          config = lib.mkIf cfg.enable {
            environment.systemPackages = [ self.packages.${pkgs.stdenv.hostPlatform.system}.default ];
            # Login shells only, and only interactive ones (same as install.sh).
            environment.loginShellInit = ''
              case $- in *i*)
                echo ""
                ${self.packages.${pkgs.stdenv.hostPlatform.system}.default}/bin/figurine -f ${lib.escapeShellArg cfg.font} "$(hostname)"
                echo ""
              ;; esac
            '';
          };
        };
    };
}
