# Exclude lines of Org subtrees by a heading predicate
pred:
with builtins;
let
  dropWhile = import ./dropWhile.nix;

  splitListWith = import ./splitWith.nix;

  isHeadline = s: substring 0 1 s == "*";

  genericHeadlineRegexp = "(\\*+)[[:space:]].+";

  getHeadlineLevel = headline:
    stringLength (head (match genericHeadlineRegexp headline));

  prependOptionalStars = n: rest:
    if n == 0
    then rest
    else prependOptionalStars (n - 1) ("\\*?" + rest);

  makeSubtreeEndRegexp = outlineLevel:
    prependOptionalStars (outlineLevel - 1) "\\*[[:space:]].+";

  dropTillSubtreeEnd = level:
    dropWhile (s: !(isHeadline s && match (makeSubtreeEndRegexp level) s != null));

  go_ = cut:
    cut.before
    ++
    (if cut.sep == null
    then [ ]
    else go (dropTillSubtreeEnd (getHeadlineLevel cut.sep) cut.after));

  go = lines: go_ (splitListWith (s: isHeadline s && pred s) lines);

in
go
