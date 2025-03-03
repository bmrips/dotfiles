final: prev:

{
  pre-commit = prev.pre-commit.overridePythonAttrs (
    prevAttrs:
    with final.python3Packages;
    let
      depsPath = makePythonPath prevAttrs.propagatedBuildInputs;
    in
    {
      # Propagating dependencies leaks them through $PYTHONPATH which causes issues
      # when used in nix-shell. Instead, set $PYTHONPATH only for pre-commit by
      # creating a wrapper.
      postFixup = "rm $out/nix-support/propagated-build-inputs";
      makeWrapperArgs = (prevAttrs.makeWrapperArgs or [ ]) ++ [
        "--prefix PYTHONPATH : ${depsPath}"
        "--prefix PYTHONPATH : $out/${python.sitePackages}"
      ];
    }
  );
}
