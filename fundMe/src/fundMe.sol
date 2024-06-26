//SPDX-License-Identifer:MIT
pragma solidity ^0.8.18;

import {PriceConverter} from "./priceConverter.sol";

error FundMe__notEnoughFund();
error FundMe__onlyOwnerError();

contract FundMe {
    using PriceConverter for uint256;

    address[] funders;
    mapping(address => uint256) public addressToAmtFunded;
    address public immutable i_owner;

    constructor() {
        i_owner = msg.sender;
    }

    uint256 public constant MIN_AMT_IN_DOLLARS = 5;

    //I need to convert the value in dollar to eth...
    function fund() public payable {
        if (msg.value.getConversionRate() < MIN_AMT_IN_DOLLARS * 1e18) {
            revert FundMe__notEnoughFund();
        }
        funders.push(msg.sender);
        addressToAmtFunded[msg.sender] += msg.value;
    }

    modifier onlyOwner() {
        if (msg.sender != i_owner) {
            revert FundMe__onlyOwnerError();
        }
        _;
    }

    function withdraw() public onlyOwner {
        (bool callSuccess, ) = payable(msg.sender).call{
            value: address(this).balance
        }("");
        require(callSuccess, "call failed!");
    }

    receive() external payable {
        fund();
    }

    fallback() external payable {
        fund();
    }
}
