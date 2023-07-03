#!/bin/sh
tflint --init
tflint
tflint --config ../../.tflint.hcl --chdir ./modules/simphera_base
tflint --config ../../../../.tflint.hcl --chdir ./modules/simphera_base/modules/simphera_instance
