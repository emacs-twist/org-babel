# Exclude lines of Org subtrees by a heading predicate
pred:
with builtins;
let
  inherit (import ./utils.nix)
    dropTillSubtreeEnd
    getHeadlineLevel
    splitListWith
    isHeadline;

  go_ = cut:
    cut.before
    ++
    (if cut.sep == null
    then [ ]
    else go (dropTillSubtreeEnd (getHeadlineLevel cut.sep) cut.after));

  go = lines: go_ (splitListWith (s: isHeadline s && pred s) lines);

in
go
