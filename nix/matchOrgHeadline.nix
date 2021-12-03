headlineText: s:
builtins.match
  "\\*+[[:space:]]+${headlineText}([[:space:]]+:[^[:space:]]+:)?[[:space:]]*"
  s != null
