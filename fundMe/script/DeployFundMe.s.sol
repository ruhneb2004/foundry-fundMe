//SPDX-License-Identifer:MIT
pragma solidity ^0.8.18;

import {FundMe} from "../src/fundMe.sol";
import {Script} from "forge-std/Script.sol";

contract DeployFundMe is Script {
    function run() external {
        vm.startBroadcast();
        new FundMe();
        vm.stopBroadcast();
    }
}
