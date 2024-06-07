#!/usr/bin/env bats

setup() {
  true
}

@test "run on test-k8s-file" {
  run operation test-k8s-file.yaml

  echo '###'$'\n'"${lines[*]}"$'\n''###'
  [ "${status}" -eq 0 ]
}

@test "fail on test-configmap-malformed" {
  run operation test-configmap-malformed.yaml

  echo '###'$'\n'"${lines[*]}"$'\n''###'
  [ "${status}" -eq 1 ]
  [[ "${lines[0]}" == *"additionalProperties 'datas' not allowed" ]]
}

@test "fail on test-egressfirewall-malformed" {
  run operation test-egressfirewall-malformed.yaml

  echo '###'$'\n'"${lines[*]}"$'\n''###'
  [ "${status}" -eq 1 ]
  [[ "${lines[0]}" == *"additionalProperties 'cirdSelector' not allowed" ]]
}

function operation() {
  kubeconform --strict --schema-location openshift-json-schema < .workflow-scripts/test/$1
}
