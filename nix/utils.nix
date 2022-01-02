with builtins;
let
  genericHeadlineRegexp = "(\\*+)[[:space:]].+";

  prependOptionalStars = n: rest:
    if n == 0
    then rest
    else prependOptionalStars (n - 1) ("\\*?" + rest);
in  
rec {
  dropWhile = import ./dropWhile.nix;

  splitListWith = import ./splitWith.nix;

  isHeadline = s: substring 0 1 s == "*";

  getHeadlineLevel = headline:
    stringLength (head (match genericHeadlineRegexp headline));

  makeSubtreeEndRegexp = outlineLevel:
    prependOptionalStars (outlineLevel - 1) "\\*[[:space:]].+";

  dropTillSubtreeEnd = level:
    dropWhile (s: !(isHeadline s && match (makeSubtreeEndRegexp level) s != null));
}
