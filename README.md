# helm2json

Turn Helm chart into single - helm values respecting - k8s compatible json with Nix.

## Usage

Exposes two functions: fetchhelm and chart2json

### fetchhelm

Args:

- chart: name of the chart (required)
- chartUrl: chart url to fetch from custom location (default: null)
- version: version of the chart (default: null)
- sha256: hash (required)
- untar: extract chart (default: true)
- repo: use custom charts repo (default: null)
- verify: pass `--verify` to `helm fetch` (default: false)
- devel: pass `--devel` to `helm fetch` (default: false)

### chart2json

Args:

- releaseName: custom release name (required)
- chart: derivation/path - output of `fetchhelm`
- values: attrset of values - see examples (optional)
- kubeVersion: pass kube version to `helm template` (optional)

## Examples

Look into examples folder.

    cd examples
    nix-build
