{
  description = "Nix library for extracting source blocks from Org";

  outputs = { ... }:
    let
      lib = import ./nix;
    in
      {
        inherit lib;
        overlay = _: prev: {
          tangleOrgBabelFile = name: path: options:
            prev.writeText name
              (lib.tangleOrgBabel options (builtins.readFile path));
        };
      };
}
