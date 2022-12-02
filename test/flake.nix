{
  inputs.org-babel.url = "github:emacs-twist/org-babel";

  outputs = {
    org-babel,
    flake-utils,
    nixpkgs,
    ...
  }:
    flake-utils.lib.eachSystem [
      "x86_64-linux"
      "x86_64-darwin"
      "aarch64-linux"
      "aarch64-darwin"
    ] (system: let
      pkgs = import nixpkgs {
        inherit system;
        overlays = [
          org-babel.overlays.default
        ];
      };
    in {
      checks = {
        build =
          pkgs.tangleOrgBabelFile "example" ./testTangle.org
          {};
      };
    });
}
