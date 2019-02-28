{ stdenvNoCC, lib, kubernetes-helm, cacert }:
let
  cleanName = name: lib.replaceStrings ["/"] ["-"] name;

  fetchhelm = { chart, chartUrl ? null, version ? null, sha256, untar ? true, repo ? null, verify ? false, devel ? false }:
    stdenvNoCC.mkDerivation rec {
      name = "${cleanName chart}-${if version == null then "dev" else version}";
      buildCommand = ''
        export HOME="$PWD"
        helm init --client-only >/dev/null
        ${if repo == null then "" else "helm repo add repository ${repo}"}
        helm fetch -d ./chart \
          ${if untar then "--untar" else ""} \
          ${if version == null then "" else "--version ${version}"} \
          ${if devel then "--devel" else ""} \
          ${if verify then "--verify" else ""} \
          ${if chartUrl == null then (if repo == null then chart else "repository/${chart}") else chartUrl}
        cp -r chart/*/ $out
      '';
      outputHashMode = "recursive";
      outputHashAlgo = "sha256";
      outputHash = sha256;
      nativeBuildInputs = [ kubernetes-helm cacert ];
    };

in fetchhelm
