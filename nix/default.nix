with builtins;
let
  excludeOrgSubtreesOnHeadlines = import ./excludeOrgSubtreesOnHeadlines.nix;

  matchOrgTag = import ./matchOrgTag.nix;
  matchOrgHeadline = import ./matchOrgHeadline.nix;
  matchOrgHeadlines = headlines: s:
    builtins.any (t: matchOrgHeadline t s) headlines;

  tangleOrgBabel = import ./tangleOrgBabel.nix;

  tangleOrgBabelFile = name: path: options:
    toFile name (tangleOrgBabel options (readFile path));
in
{
  inherit matchOrgTag matchOrgHeadline matchOrgHeadlines;
  inherit excludeOrgSubtreesOnHeadlines;
  inherit tangleOrgBabel;
  inherit tangleOrgBabelFile;
}
