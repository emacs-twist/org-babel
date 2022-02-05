with builtins;
let
  takeWhile = p: xs:
    if length xs == 0
    then [ ]
    else if p (head xs)
    then [ (head xs) ] ++ takeWhile p (tail xs)
    else [ ];

  dropWhile = p: xs:
    if length xs == 0
    then [ ]
    else if p (head xs)
    then dropWhile p (tail xs)
    else xs;

  isKeyword = s: stringLength s > 0 && substring 0 1 s == ":";

  notKeyword = s: !(isKeyword s);

  toValue = xs:
    if length xs == 0
    then true
    else if length xs == 1
    then head xs
    else xs;

  listToAttrs = xs:
    if length xs == 0
    then { }
    else {
      ${head xs} = toValue (takeWhile notKeyword (tail xs));
    } // listToAttrs (dropWhile notKeyword (tail xs));

  stripPat = "[[:space:]]+(.*)";

  stripLeft = string:
    if match stripPat string != null
    then head (match stripPat string)
    else string;

  pat1 = "\"([^\"]+)\"(.*)";
  
  pat2 = "([^\"][^[:space:]]*)(.*)";

  go = m: [ (elemAt m 0) ] ++ parse (elemAt m 1);

  parse' = string:
    if string == ""
    then [ ]
    else if match pat1 string != null
    then go (match pat1 string)
    else if match pat2 string != null
    then go (match pat2 string)
    else throw "Match nothing: ${string}";

  parse = string: parse' (stripLeft string);
in
string:
listToAttrs (parse string)
