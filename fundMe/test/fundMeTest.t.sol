//SPDX-License-Identifier:MIT
pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../src/fundMe.sol";

contract FundMeTest is Test {
    FundMe fundMe;

    function setUp() external {
        fundMe = new FundMe();
    }

    function testMinAmtIsFiveDollar() public view {
        //We have assertEq to check if two conditions are equal
        console.log("This is solidity and not javascript!!!");
        assertEq(fundMe.MIN_AMT_IN_DOLLARS(), 5);
    }

    function testOwnerIsMsgSender() public view {
        assertEq(fundMe.i_owner(), address(this));
        //The contract is the sender here as it was where it was deployed from...
    }
}
