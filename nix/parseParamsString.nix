with builtins;
let
  listToAttrs = xs:
    if length xs == 0
    then { }
    else if length xs == 1
    then throw "parseParamsString: Found an odd number of items: ${head xs}"
    else { ${head xs} = elemAt xs 1; } // listToAttrs (tail (tail xs));

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
