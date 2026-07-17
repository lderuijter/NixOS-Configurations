{ lib, buildNpmPackage, fetchFromGitLab }:

buildNpmPackage rec {
  pname = "nxapi";
  version = "development";

  src = fetchFromGitLab {
    domain = "gitlab.fancy.org.uk";
    owner = "samuel";
    repo = "nxapi";
    rev = "main";
    hash = "sha256-fbXYQBjO6Ft8UTlKZuIstLVCtVRQ+l04LXhPM1pp/Pw=";
  };

  npmDepsHash = "sha256-ilMTarp57EhA0U3M00M6PM7CgjQuurLpxrxf2Uu1PUI=";

  forceGitDeps = true;
  npmFlags = [ "--ignore-scripts" ];

  dontNpmBuild = true;
  buildPhase = ''
    runHook preBuild
    npx tsc
    runHook postBuild
  '';

  meta = with lib; {
    description = "Nintendo Switch Online app APIs / Discord Rich Presence";
    homepage = "https://gitlab.fancy.org.uk/samuel/nxapi";
    license = licenses.agpl3Only;
    mainProgram = "nxapi";
  };
}
