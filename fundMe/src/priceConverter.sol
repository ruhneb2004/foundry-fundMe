//SPDX-License-Identifer:MIT
pragma solidity ^0.8.18;

import {AggregatorV3Interface} from
    "lib/chainlink-brownie-contracts/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

library PriceConverter {
    function getPrice() public view returns (uint256) {
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        (, int256 answer,,,) = priceFeed.latestRoundData();
        return uint256(answer) * 1e10;
    }

    function getConversionRate(uint256 amtOfEth) public view returns (uint256) {
        uint256 priceOfOneEth = getPrice();
        uint256 ethInDollars = priceOfOneEth * amtOfEth / 1e18;
        return ethInDollars;
    }
}
