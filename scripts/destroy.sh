#!/bin/bash

set -e

echo "Destroying Prodigy infrastructure..."

cd terraform

terraform destroy -auto-approve

echo "Infrastructure destroyed successfully!"