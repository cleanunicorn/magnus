#!/usr/bin/env bash

set -eo pipefail

# bring up the network
. $(dirname $0)/run-temp-testnet.sh

# run the deploy script
. $(dirname $0)/deploy.sh

# get the address
addr=$(jq -r '.Codex' out/addresses.json)

# the initial greeting must be empty
globalDebtCeiling=$(seth call $addr 'globalDebtCeiling()(uint256)' --rpc-url $ETH_RPC_URL)
[[ $globalDebtCeiling = "0" ]] || error

# set it to a value
seth send $addr \
    'modifyGlobalConfig(bytes32,uint256)' $(seth --to-bytes32 $(seth --from-ascii 'globalDebtCeiling')) $(seth --max-uint) \
    --keystore $TMPDIR/8545/keystore \
    --password /dev/null \
    --rpc-url $ETH_RPC_URL

sleep 1

# should be set afterwards
globalDebtCeiling=$(seth call $addr 'globalDebtCeiling()(uint256)' --rpc-url $ETH_RPC_URL)
[[ $(seth --to-uint256 $globalDebtCeiling) = $(seth --max-uint) ]] || error

echo "Success."
