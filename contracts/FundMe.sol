//SPDX-License-Identifier: MIT

pragma solidity ^0.8.8;

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
import "./Convert.sol";

contract FundMe {
    using Convert for uint;

    mapping (address => uint) public fundersToFunds;
    address[] public funders;

    uint public constant MIN_USD = 50 * 1e18;
    address public  immutable i_owner;

    constructor() {
        i_owner = msg.sender;
    }

    function fund() public payable{
        require(msg.value.convertEthUsd() > MIN_USD, "you didn't send enough ^_^");
        funders.push(msg.sender);
        fundersToFunds[msg.sender] = msg.value;
    }

    modifier OnlyOwner{
        require(msg.sender == i_owner, "not owner");
        _;
    }

    function withdraw() OnlyOwner public{
        for(uint i; i < funders.length; i++){
            address funder = funders[i];
            fundersToFunds[funder] = 0;
        }
        funders = new address[](0);
        (bool successCall,) = payable(msg.sender).call{value: address(this).balance}("");
        require(successCall, "withdraw failed");
    }
    
    fallback() external payable {
        fund();
    }

    receive() external payable {
        fund();
    }
}