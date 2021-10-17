#!/usr/bin/env bash

set -eo pipefail

# import the deployment helpers
. $(dirname $0)/common.sh

# Deploy.
CodexAddr=$(deploy Codex $ETH_FROM)
log "Codex deployed at:" $CodexAddr
