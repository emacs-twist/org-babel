# Quick-and-dirty re-implementation of org-babel-tangle in Nix.
{ languages ? [ "emacs-lisp" "elisp" ]
, processLines ? lines: lines
}:
string:
with builtins;
let
  lines = filter isString (split "\n" string);

  dropUntil = import ./dropUntil.nix;

  blockStartRegexp =
    "[[:space:]]*\#\\+[Bb][Ee][Gg][Ii][Nn]_[Ss][Rr][Cc][[:space:]]+"
    + "(" + (concatStringsSep "|" languages) + ")"
    + "(([[:space:]].*)?)";

  parseParamsString = import ./parseParamsString.nix;

  parseParamsString' = s:
    if s == null
    then { }
    else parseParamsString s;

  checkBlockParams = attrs:
    foldl' (acc: value: acc && value) true
      (attrValues
        (mapAttrs (name: value:
          if name == ":tangle"
          then value == "yes"
          else true
        ) attrs));

  isBlockStart = line:
    (match blockStartRegexp line != null)
    && checkBlockParams (parseParamsString' (elemAt (match blockStartRegexp line) 2));

  splitListWith = import ./splitWith.nix;

  blockEndRegexp = "[[:space:]]*\#\\+[Ee][Nn][Dd]_[Ss][Rr][Cc].*";

  isBlockEnd = line: match blockEndRegexp line != null;

  go = acc: xs:
    let
      st1 = dropUntil isBlockStart xs;
      st2 = splitListWith isBlockEnd st1;
    in
    if length xs == 0
    then acc
    else if length st1 == 0
    then acc
    else (go (acc ++ [ st2.before ]) st2.after);

in
concatStringsSep "\n" (concatLists (go [ ] (processLines lines)))
