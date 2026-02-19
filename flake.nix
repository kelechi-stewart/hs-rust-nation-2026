{
  description = "Minimal Rust+OpenCV flake (macOS Nix)";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
      in with pkgs; {
        devShells.default = mkShell {
          buildInputs = [
            pkg-config
            opencv
            llvmPackages.libclang
            grpc-tools
            python3
            uv
          ];
          env = {
            LIBCLANG_PATH="${llvmPackages.libclang.lib}/lib";
            DYLD_LIBRARY_PATH="${llvmPackages.libclang.lib}/lib:${opencv}/lib";
            OPENCV_LINK_PATH="${opencv}/lib";
          };
        };
      });
}