{
  description = "Nix library for extracting source blocks from Org";

  outputs = _:
    let
      lib = import ./nix;
    in
      {
        inherit lib;
        overlays = {
          default = _: prev: {
            tangleOrgBabelFile = name: path: options:
              prev.writeText name
                (lib.tangleOrgBabel options (builtins.readFile path));
          };
        };
      };
}
