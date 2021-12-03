with builtins;
let
  excludeOrgSubtreesOnHeadlines = import ./excludeOrgSubtreesOnHeadlines.nix;

  matchOrgTag = import ./matchOrgTag.nix;
  matchOrgHeadline = import ./matchOrgHeadline.nix;
  matchOrgHeadlines = headlines: s:
    builtins.any (t: matchOrgHeadline t s) headlines;

  tangleOrgBabel = pkgs.callPackage ./tangleOrgBabel.nix {
    processLines = processOrgLines;
  };
in
{
  inherit matchOrgTag matchOrgHeadline matchOrgHeadlines;
  inherit excludeOrgSubtreesOnHeadlines;
  inherit tangleOrgBabel;
}
