with builtins;
let
  excludeOrgSubtreesOnHeadlines = import ./excludeOrgSubtreesOnHeadlines.nix;

  matchOrgTag = import ./matchOrgTag.nix;
  matchOrgHeadline = import ./matchOrgHeadline.nix;
  matchOrgHeadlines = headlines: s:
    builtins.any (t: matchOrgHeadline t s) headlines;

  tangleOrgBabel = import ./tangleOrgBabel.nix;
in
{
  # Newer concise APIs
  excludeHeadlines = excludeOrgSubtreesOnHeadlines;
  tag = matchOrgTag;
  headlineText = matchOrgHeadline;
  allP = predicates: x: builtins.all (p: p x) predicates;
  anyP = predicates: x: builtins.any (p: p x) predicates;

  # Deprecated APIs
  inherit matchOrgTag matchOrgHeadline matchOrgHeadlines;
  inherit excludeOrgSubtreesOnHeadlines;

  # Tangle
  inherit tangleOrgBabel;
}
