# nix-instantiate --eval --strict test/test.nix
with builtins;
let
  pkgs = import <nixpkgs> { };
  exclude = import ../nix/excludeOrgSubtreesOnHeadlines.nix;
  select = import ../nix/selectHeadlines.nix;
  matchOrgTag = import ../nix/matchOrgTag.nix;
  matchOrgHeadline = import ../nix/matchOrgHeadline.nix;
  dropUntil = import ../nix/dropUntil.nix;
  lines = filter (s: isString s && s != "") (split "\n" (readFile ./test.org));
in
pkgs.lib.runTests {
  testTagPredicate = {
    expr = head (exclude (matchOrgTag "ARCHIVE") lines);
    expected = "* Good morning";
  };

  testHeadlinePredicate = {
    expr = head (exclude (matchOrgHeadline "Archived entry") lines);
    expected = "* Good morning";
  };

  testSubtree = {
    expr = head (dropUntil (s: s == "Hello!") (exclude (matchOrgTag "irregular") lines));
    expected = "* Get to work";
  };

  testTagPredicate2 = {
    expr = pkgs.lib.last (exclude (matchOrgTag "optional") lines);
    expected = "It was a good day!";
  };

  testSelect1 = {
    expr = pkgs.lib.last (select (matchOrgTag "irregular") lines);
    expected = "Why did he come to the office in the first place?";
  };

  testSelect2 = {
    expr = pkgs.lib.last (select (matchOrgTag "optional") lines);
    expected = "/Zaijian/ means goodbye in Mandarin Chinese.";
  };
}
