{ fetchPypi, lib, python3Packages }:

with python3Packages;

buildPythonApplication rec {
  pname = "cdhist";
  version = "3.7.2";

  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-66oGSzLQmSbyDvVJduF52Kn1L0k39Gq42QOse4wyoVU=";
  };

  strictDeps = true;

  nativeBuildInputs = [ setuptools-scm ];

  meta = with lib; {
    description = "Linux shell cd history";
    homepage = "https://github.com/bulletmark/${pname}";
    downloadPage = "https://pypi.org/project/${pname}/";
    license = licenses.gpl3Plus;
    mainProgram = "cdhist";
  };
}
