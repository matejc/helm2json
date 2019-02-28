{ stdenvNoCC, lib, kubernetes-helm, gawk, remarshal, jq }:
{ releaseName, chart, values ? null, kubeVersion ? null }:
stdenvNoCC.mkDerivation {
  name = "${releaseName}.json";
  buildCommand = ''
    helm template --name "${releaseName}" \
      ${if kubeVersion == null then "" else "--kube-version ${kubeVersion}"} \
      ${if values == null then "" else "-f ${builtins.toFile "values.json" (builtins.toJSON values)}"} \
      ${chart} >resources.yaml

    awk 'BEGIN{i=1}{line[i++]=$0}END{j=1;n=0; while (j<i) {if (line[j] ~ /^---/) n++; else print line[j] >>"resource-"n".yaml"; j++}}' resources.yaml

    for file in ./resource-*.yaml
    do
      remarshal -i $file -if yaml -of json >>resources.jsonl
    done

    cat resources.jsonl | jq -cs '.' > resources.json

    cat resources.json | jq '{kind:"List",apiVersion:"v1",items:.|map(select(.!=null))}' --sort-keys > $out
  '';
  nativeBuildInputs = [ kubernetes-helm gawk remarshal jq ];
}
