# include .env file and export its env vars
# (-include to ignore error if it does not exist)
-include .env

install: solc update npm

# dapp deps
update:; dapp update

# npm deps for linting etc.
npm:; yarn install

# install solc version
# example to install other versions: `make solc 0_8_2`
SOLC_VERSION := 0_8_7
solc:; nix-env -f https://github.com/dapphub/dapptools/archive/master.tar.gz -iA solc-static-versions.solc_${SOLC_VERSION}

# Build & test & deploy
build         :; dapp build
cache         :; if [ ! -d $(DAPP_TEST_CACHE) ]; then dapp --make-cache $(DAPP_TEST_CACHE); fi
clean         :; dapp clean
debug         :; dapp debug
deploy        :; @./scripts/deploy.sh
estimate      :; ./scripts/estimate-gas.sh ${contract}
lint          :; yarn run lint
size          :; ./scripts/contract-size.sh ${contract}
test          :; dapp test # --ffi # enable if you need the `ffi` cheat code on HEVM
test-forking  :; make cache; dapp test --rpc

# mainnet
deploy-mainnet: export ETH_RPC_URL = $(call network,mainnet)
deploy-mainnet: check-api-key deploy
test-mainnet  : export ETH_RPC_URL = $(call network,mainnet)
test-mainnet  : export DAPP_TEST_NUMBER = 12569837 
test-mainnet  : export DAPP_TEST_CACHE = cache/mainnet-${DAPP_TEST_NUMBER} 
test-mainnet  : check-api-key test-forking

# rinkeby
deploy-rinkeby: export ETH_RPC_URL = $(call network,rinkeby)
deploy-rinkeby: check-api-key deploy

check-api-key :
ifndef ALCHEMY_API_KEY
	$(error ALCHEMY_API_KEY is undefined)
endif

# Returns the URL to deploy to a hosted node.
# Requires the ALCHEMY_API_KEY env var to be set.
# The first argument determines the network (mainnet / rinkeby / ropsten / kovan / goerli)
define network
	https://eth-$1.alchemyapi.io/v2/${ALCHEMY_API_KEY}
endef
