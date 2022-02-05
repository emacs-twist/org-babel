# nix-instantiate --eval --strict test/testParams.nix
let
  pkgs = import <nixpkgs> {};
  parse = import ../nix/parseParamsString.nix;
in
pkgs.lib.runTests {
  testSimple = {
    expr = parse ":tangle no";
    expected = {
      ":tangle" = "no";
    };
  };

  testOdd = {
    expr = parse ":async";
    expected = {
      ":async" = true;
    };
  };

  testNonAlpha = {
    expr = parse ":session kernel-16577-ssh.json";
    expected = {
      ":session" = "kernel-16577-ssh.json";
    };
  };

  # This case is unsupported right now.
  #
  # testExpression = {
  #   expr = parse ":value '(this is so annoying)";
  #   expected = { };
  # };

  testDoubleQuotes = {
    expr = parse ":caption \"Hello, I am Katja\"";
    expected = {
      ":caption" = "Hello, I am Katja";
    };
  };

}
