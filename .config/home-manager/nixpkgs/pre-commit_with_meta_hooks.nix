final: prev:

{
  pre-commit = prev.pre-commit.overrideAttrs (
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
