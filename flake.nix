{
  inputs.nixpkgs.url        = github:NixOS/nixpkgs/master;
  inputs.ghc-wasm-meta.url = "git+https://gitlab.haskell.org/ghc/ghc-wasm-meta";
  inputs.flake-utils.url = "github:numtide/flake-utils";
  description = "Experiments with Haskell on Fastly";

  outputs = { self, nixpkgs, flake-utils, ghc-wasm-meta }:
    let
       pkgs = nixpkgs.legacyPackages.x86_64-linux;
    in
    {
      devShell.x86_64-linux = pkgs.mkShell {
        buildInputs = [
          ghc-wasm-meta.packages.x86_64-linux.default
          pkgs.viceroy
          pkgs.fastly
        ];
      };
    };
}
