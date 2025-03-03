final: prev:

{
  pre-commit = prev.pre-commit.overridePythonAttrs (
    prevAttrs:
    with final.python3Packages;
    let
      depsPath = makePythonPath prevAttrs.propagatedBuildInputs;
    in
    {
      makeWrapperArgs = (prevAttrs.makeWrapperArgs or [ ]) ++ [
        "--prefix PYTHONPATH : ${depsPath}"
        "--prefix PYTHONPATH : $out/${python.sitePackages}"
      ];
    }
  );
}
