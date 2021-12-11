{
  description = "Nix library for extracting source blocks from Org";

  outputs = { ... }:
    let
      lib = import ./nix;
    in
      {
        inherit lib;
        overlay = _: pkgs: {
          tangleOrgBabelFile = name: path: options:
            pkgs.writeText name
              (lib.tangleOrgBabel options (builtins.readFile path));
        };
      };
}
