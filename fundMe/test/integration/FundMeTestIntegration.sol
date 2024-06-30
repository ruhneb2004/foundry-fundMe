//SPDX-License-Identifier:MIT
pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {DeployFundMe} from "../../script/DeployFundMe.s.sol";
import {FundMe} from "../../src/FundMe.sol";
import {FundFundMe, WithdrawalFundMe} from "../../script/Interactions.s.sol";

contract testFundMeInteractions is Test {
    address private constant USER_ADDR = address(uint160(1));
    FundMe private fundMe;

    function setUp() external {
        DeployFundMe deployFundMe = new DeployFundMe();
        fundMe = deployFundMe.run();
    }

    function testUserCanFundAndWithdraw() external {
        FundFundMe fundFundMeContract = new FundFundMe();
        fundFundMeContract.fundFundMe(address(fundMe));
        console.log(address(fundMe).balance);
        assert(address(fundMe).balance != 0);

        WithdrawalFundMe withdrawalFundMeContract = new WithdrawalFundMe();
        withdrawalFundMeContract.withdrawFundMe(address(fundMe));
        assert(address(fundMe).balance == 0);
    }
}
