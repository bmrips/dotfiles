{
  chntpw,
  fetchPypi,
  lib,
  python3Packages,
}:

python3Packages.buildPythonApplication rec {
  pname = "bt-dualboot";
  version = "1.0.1";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-pjzGvLkotQllzyrnxqDIjGlpBOvUPkWpv0eooCUrgv8=";
  };

  strictDeps = true;

  dependencies = [ chntpw ];

  meta = {
    description = "Sync Bluetooth for dualboot Linux and Windows";
    homepage = "https://github.com/x2es/bt-dualboot";
    downloadPage = "https://pypi.org/project/${pname}";
    license = lib.licenses.mit;
    mainProgram = "bt-dualboot";
  };
}
