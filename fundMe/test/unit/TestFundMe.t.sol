// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../../src/FundMe.sol";
import {DeployFundMe} from "../../script/DeployFundMe.s.sol";


contract TestFundMe is Test {
    FundMe fundMe;
    uint256 constant FUND_VALUE = 0.1 ether;
    address SENDER_ADDRESS = makeAddr("sender");

    modifier funded() {
        vm.prank(SENDER_ADDRESS);
        fundMe.fund{value: FUND_VALUE}();
        _;
    }

    function setUp() external {
        DeployFundMe deployFundMe = new DeployFundMe();
        fundMe = deployFundMe.run();
        vm.deal(SENDER_ADDRESS, 1000 ether);
        //The balance that you are giving here using the deal will stay until the end of the contract!!!
        //As we are calling the fundMe from the script inside the vm the msg.sender will be the owner instead of the contract...
    }

    function testVerOfFundMe() public view {
        assertEq(fundMe.getVersion(), 4);
    }

    function testOwnerIsMsgSender() public view {
        assertEq(fundMe.getOwner(), msg.sender);
    }

    function testVersion() public view {
        assertEq(fundMe.getVersion(), 4);
    }

    function testFundingFailsIfLowThanMinValue() public {
        vm.expectRevert();
        fundMe.fund();
    }

    function testFundingWorksWithCorrectValue() public funded {
        assertEq(fundMe.getAddressToAmountFunded(SENDER_ADDRESS), FUND_VALUE);
    }

    function testStoringFunderAddress() public funded {
        assertEq(fundMe.getFunderAddress(0), SENDER_ADDRESS);
    }

    function testOnlyOwnerCanWithdraw() public funded {
        vm.expectRevert();
        vm.prank(SENDER_ADDRESS);
        fundMe.withdraw();
    }

    function testResetTheFundersAfterWithdraw() public funded {
        vm.prank(msg.sender);
        fundMe.withdraw();
        uint256 emptyArrLen = 0;
        assertEq(emptyArrLen, fundMe.getFunderAddressLength());
    }

    function testFundMeWithdrawal() public funded {
        //setting up
        address ownerOfFundMe = fundMe.getOwner();
        uint256 fundMeBalance = address(fundMe).balance;
        uint256 startingBalanceOfOwner = ownerOfFundMe.balance;

        //checking
        vm.prank(msg.sender);
        fundMe.withdraw();

        //asserting
        uint256 afterWithdrawalBalanceOfOwner = ownerOfFundMe.balance;
        assertEq(
            (afterWithdrawalBalanceOfOwner - startingBalanceOfOwner),
            fundMeBalance
        );
        uint256 valueAfterWithdrawal = 0;
        assertEq(valueAfterWithdrawal, address(fundMe).balance);
    }

    function testMultipleFunderWithdrawal() public {
        uint256 numberOfFunders = 10;
        for (uint160 i = 1; i <= numberOfFunders; i++) {
            /*
            Here the address used is from address(1), we are not using the address(0) cause it may cause some errors due to some sanity checks... Also the hoax combines the functionality of prank and deal. One more thing the address take the input of uint160 cause the address and the int160 have same number of bytes or something...
            */
            hoax(address(i));
            fundMe.fund{value: FUND_VALUE}();
        }

        uint256 startingBalanceOfOwner = fundMe.getOwner().balance;
        uint256 contractBalance = address(fundMe).balance;

        vm.startPrank(fundMe.getOwner());
        fundMe.withdraw();
        vm.stopPrank();

        uint256 finalBalanceOfOwner = fundMe.getOwner().balance;

        assert(
            contractBalance == (finalBalanceOfOwner - startingBalanceOfOwner)
        );
        assert(address(fundMe).balance == 0);
    }
}
