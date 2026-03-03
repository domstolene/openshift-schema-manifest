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
Man velger først SDK i IntelliJ, så genererer man en.venv fil. Etterpå kjør disse kommandoene:
```sh
source .venv/bin/activate
python -m pip install --upgrade pip setuptools wheel
pip install pyyaml==5.4.1 --no-build-isolation
pip install openapi2jsonschema2
```


For å oppdatere dette depotet logger man først inn på OpenShift, deretter kjører man:

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
