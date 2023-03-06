{
  inputs.nixpkgs.url        = github:NixOS/nixpkgs/nixos-22.11;
  inputs.nixpkgs-unstable.url        = github:NixOS/nixpkgs/master;
  inputs.ghc-wasm-meta.url = "git+https://gitlab.haskell.org/ghc/ghc-wasm-meta";
  inputs.flake-utils.url = "github:numtide/flake-utils";
  description = "Experiments with Haskell on Fastly";

  outputs = { self, nixpkgs, nixpkgs-unstable, flake-utils, ghc-wasm-meta }:
    let
       pkgs = nixpkgs.legacyPackages.x86_64-linux;
       pkgs-unstable = nixpkgs-unstable.legacyPackages.x86_64-linux;
       viceroy = pkgs.rustPackages_1_66.rustPlatform.buildRustPackage rec {
         pname = "viceroy";
         version = "0.3.5";

         src = pkgs.fetchFromGitHub {
           owner = "fastly";
           repo = "Viceroy";
           rev = "v${version}";
           sha256 = "sha256-X+RmsS+GxdBiFt2Fo0MgkuyjQDwQNuOLDL1YVQdqhXo=";
         };

         doCheck = false;

         cargoSha256 = "sha256-vbhBlfHrFcjtaUJHYvB106ElYP0NquOo+rgIx9cWenY=";

         meta = with pkgs.lib; {
           description = "Viceroy provides local testing for developers working with Compute@Edge.";
           homepage = "https://github.com/fastly/Viceroy/";
           license = licenses.asl20;
           maintainers = [ maintainers.nomeata ];
         };
       };
    in
    {
      packages.x86_64-linux.viceroy = viceroy;
      devShell.x86_64-linux = pkgs.mkShell {
        buildInputs = [
          ghc-wasm-meta.packages.x86_64-linux.default
          viceroy
          pkgs-unstable.fastly
        ];
      };
    };
}
