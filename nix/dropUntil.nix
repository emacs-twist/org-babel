pred: items:
with builtins;
let
  xs = import ./dropWhile.nix (x: ! (pred x)) items;
in
if length xs > 0
then tail xs
else [ ]
