//SPDX-License-Identifier: MIT

pragma solidity ^0.8.8;

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

library Convert {   

    function getEthPrice() internal view returns(uint){
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0x8A753747A1Fa494EC906cE90E9f37563A8AF630e);
        (,int price,,,) = priceFeed.latestRoundData();
        return(uint(price*1e10));
    }

    function convertEthUsd(uint ethAmount) internal view returns(uint){
        uint ethPrice =  getEthPrice();
        uint ethValue = (ethPrice * ethAmount) / 1e18;
        return(ethValue);
    }
}