# Select headlines matching a tag/headline
pred:
with builtins;
let
  inherit (import ./utils.nix)
    makeSubtreeEndRegexp
    getHeadlineLevel
    splitListWith
    dropWhile
    isHeadline;

  makeEndPred =  headline:
    s: isHeadline s
       && match (makeSubtreeEndRegexp (getHeadlineLevel headline)) s != null;

  go0 = lines:
    if length lines == 0
    then [ ]
    else go1 (head lines) (splitListWith (makeEndPred (head lines)) (tail lines));

  go1 = initial: cut:
    [ initial ]
    ++
    cut.before
    ++
    (if cut.sep == null
     then [ ]
     else go ([ cut.sep ] ++ cut.after));

  go = lines:
    if length lines == 0
    then [ ]
    else go0 (dropWhile (s: !(isHeadline s && pred s)) lines);
in
go
