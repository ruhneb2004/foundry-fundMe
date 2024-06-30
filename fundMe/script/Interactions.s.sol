//SPDX-License-Identifier:MIT
pragma solidity ^0.8.18;

import {Script, console} from "forge-std/Script.sol";
import {DevOpsTools} from "lib/foundry-devops/src/DevOpsTools.sol";
import {FundMe} from "../src/FundMe.sol";

uint256 constant FUNDING_VALUE = .1 ether;

contract FundFundMe is Script {
    address immutable i_recentContractAddr =
        DevOpsTools.get_most_recent_deployment("FundMe", block.chainid);
    address benhur = makeAddr("benhur");

    function run() external {
        vm.startBroadcast();
        fundFundMe(i_recentContractAddr);
        vm.stopBroadcast();
    }

    function fundFundMe(address mostRecentFundMeAddr) public {
        address tempAddr = address(uint160(1));

        FundMe fundMe = FundMe(payable(mostRecentFundMeAddr));
        vm.prank(tempAddr);
        vm.deal(tempAddr, 1000 ether);
        fundMe.fund{value: FUNDING_VALUE}();
        console.log("%s amount has been funded to FundMe!", FUNDING_VALUE);
    }
}

contract WithdrawalFundMe is Script {
    address immutable i_recentContractAddr =
        DevOpsTools.get_most_recent_deployment("FundMe", block.chainid);

    function run() external {
        withdrawFundMe(i_recentContractAddr);
    }

    function withdrawFundMe(address _mostRecentContractAddr) public {
        vm.startBroadcast();
        FundMe fundMe = FundMe(payable(_mostRecentContractAddr));
        fundMe.withdraw();
        vm.stopBroadcast();
    }
}
