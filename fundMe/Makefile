include .env

build:
	forge build

deploy-on-sepolia:
	forge script script/DeployFundMe.s.sol --rpc-url $(SEPOLIA_URL) --private-key $(SEPOLIA_PRIVATE_KEY) --broadcast --verify --etherscan-api-key $(ETHERSCAN_API_KEY) -vvvv