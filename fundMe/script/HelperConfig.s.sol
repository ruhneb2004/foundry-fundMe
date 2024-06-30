//SPDX-License-Identifier:MIT

/* The mockAggregatorv3 and the aggregatorv3interface are entirely different. The first one is a pricefeed contract which gives the values of the digit currency whereas the later is just the defintion of some functions without the actual implementation... */

pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {MockV3Aggregator} from "@chainlink/contracts/v0.8/tests/MockV3Aggregator.sol";

//The mock contract is of version 0.8

contract HelperConfig is Script {
    NetworkConfig public activeNetworkConfig;

    uint256 constant SEPOLIA_CHAIN_ID = 11155111;
    uint256 constant MAINNET_CHAIN_ID = 1;
    uint8 constant DECIMALS = 8;
    int256 constant INITAL_VALUE = 3261e8;
    address constant SEPOLIA_PRICE_FEED_ADD =
        0x694AA1769357215DE4FAC081bf1f309aDC325306;
    address constant MAINNET_PRICE_FEED_ADD =
        0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419;

    constructor() {
        if (block.chainid == SEPOLIA_CHAIN_ID) {
            activeNetworkConfig = getSepoliaEthConfig();
        } else if (block.chainid == MAINNET_CHAIN_ID) {
            activeNetworkConfig = getMainnetConfig();
        } else {
            activeNetworkConfig = getOrCreateAnvilConfig();
        }
    }

    struct NetworkConfig {
        address priceFeedAddress;
    }

    function getSepoliaEthConfig() public pure returns (NetworkConfig memory) {
        NetworkConfig memory sepoliaConfig = NetworkConfig({
            priceFeedAddress: SEPOLIA_PRICE_FEED_ADD
        });
        return sepoliaConfig;
    }

    function getOrCreateAnvilConfig() public returns (NetworkConfig memory) {
        if (
            activeNetworkConfig.priceFeedAddress != address(0) &&
            activeNetworkConfig.priceFeedAddress != SEPOLIA_PRICE_FEED_ADD &&
            activeNetworkConfig.priceFeedAddress != MAINNET_PRICE_FEED_ADD
        ) {
            return activeNetworkConfig;
        }

        MockV3Aggregator mockV3Aggregator;

        vm.startBroadcast();
        mockV3Aggregator = new MockV3Aggregator(DECIMALS, INITAL_VALUE);
        vm.stopBroadcast();
        NetworkConfig memory anvilConfig = NetworkConfig({
            priceFeedAddress: address(mockV3Aggregator)
        });
        return anvilConfig;
    }

    function getMainnetConfig() public pure returns (NetworkConfig memory) {
        NetworkConfig memory mainnetConfig = NetworkConfig({
            priceFeedAddress: MAINNET_PRICE_FEED_ADD
        });
        return mainnetConfig;
    }
}
