pred:
with builtins;
let
  go = before: rest:
    if (length rest == 0)
    then { inherit before; sep = null; after = [ ]; }
    else if pred (head rest)
    then { inherit before; sep = head rest; after = tail rest; }
    else (go (before ++ [ (head rest) ]) (tail rest));
in
go [ ]
