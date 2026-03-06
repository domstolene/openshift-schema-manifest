# openshift-schema-manifest

Dette depoet inneholder genererte schema for Openshift. Disse benyttes i forbindelse med validering av endringer i [k8s-applications](https://github.com/domstolene/k8s-applications). Legges det til nye CRD-er, operatorer etc. Må disse inn her for at valideringen skal gå gjennom.

Vi trenger et fungerende Python 3 miljø for disse skriptene. Det enkleste er derfor å bruke _virtualenv_.

```sh
pip3 install virtualenv
virtualenv --python=python3 .
source ./bin/activate 
## or source .venv/bin/activate
python -m pip install --upgrade pip setuptools wheel
pip install pyyaml==5.4.1 --no-build-isolation
pip install openapi2jsonschema2
```
OBS! Hvis man bruker windows, er det best å kjøre disse kommandoene via wsl ubuntu. 
Man velger først SDK i IntelliJ, så genererer man en .venv fil. Etterpå, kjør disse kommandoene:
```sh
source .venv/bin/activate
python -m pip install --upgrade pip setuptools wheel
pip install pyyaml==5.4.1 --no-build-isolation
pip install openapi2jsonschema2
```

Det er best å slette alt under mappen master-standalone og master-standalone-strict. Så må man logge seg inn på OpenShift i TEST.
Deretter kjører man:

```sh
python3 ./scripts/build_schema.py \
--url $(oc whoami --show-server) \
--token $(oc whoami -t) \
--destination ./openshift-json-schema/
```

Dernest:

```sh
python3 ./scripts/build_schema.py \
--url $(oc whoami --show-server) \
--token $(oc whoami -t) \
--destination ./openshift-json-schema/ \
--strict true
```

Se [Validating OpenShift Manifests in a GitOps World](https://cloud.redhat.com/blog/validating-openshift-manifests-in-a-gitops-world) for bakgrunnen til dette opplegget.

## Troubleshooting

Hvis en definisjon ikke finnes etter endringen, så er en god måtte å finne ut hvilken å gjøre det her:
1. Gå til repoet hvor valideringen feiler.
2. Finn ut hvor `--schema-location` av `kubeconform` sin kommando er satt.
3. Legg på `--schema-location "https://raw.githubusercontent.com/yannh/kubernetes-json-schema/master"`
4. Når valideringen feiler ville den vise hvilket filnavn den leter etter (e.g `stdin - Group argocd-responsible-t-okonomi.at failed validation: error while downloading schema at https://openshiftjsonschema.dev/master-standalone/group-user-v1.json - received HTTP status 403`)
5. Sjekk hvis filen eksisterer
6. Sjekk hvis referansen finnes i `_definitions.json` fil (e.g. for å finne ut hvis `Group` finns, let etter `com.github.openshift.api.user.v1.Group` i `_definition.json` fil )
