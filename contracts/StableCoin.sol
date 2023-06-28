//SPDX-License-Identifier: Unlicensed

pragma solidity ^0.8.10;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
import "hardhat/console.sol";

contract NUSDStableCoin is ERC20 {
    AggregatorV3Interface internal priceFeed;
    constructor(address _priceFeedAddress) ERC20("nUSD Stablecoin", "nUSD") {
        priceFeed = AggregatorV3Interface(_priceFeedAddress);
    }

    //function to get realtime ETH price
    function getEthToUsdExchangeRate() public view returns (uint256) {
        (, int256 price,,, ) = priceFeed.latestRoundData();
        require(price > 0, "Invalid ETH to USD exchange rate");
        return uint256(price);
    }

    //function to deposit ETH and convert to nUSD
    function deposit(uint256 _depositInETH) external payable {
        require(_depositInETH > 0, "deposit ETH");

        uint256 ethToUsdRate = getEthToUsdExchangeRate();
        console.log(ethToUsdRate);
        uint256 usdValue = _depositInETH * ethToUsdRate / (10 ** 8);
        uint256 amountToNUSD = usdValue / 2;
        _mint(msg.sender, amountToNUSD);
    }

    // function to redeem nUSD and get ETH in return

    function redeem(uint256 _amountInNUSD) external {
        require(_amountInNUSD > 0 , "specify amount of nUSD to redeem");
        
        uint256 nUSDToETH = _amountInNUSD * 2;
        require(balanceOf(msg.sender) >= nUSDToETH, "Insufficient balance");

        uint256 ethToUsdRate = getEthToUsdExchangeRate();
        uint256 redeemAmount = nUSDToETH * (10 ** 8) / ethToUsdRate ;

        require(address(this).balance >= redeemAmount, "Insufficient contract balance");
        _burn(msg.sender, _amountInNUSD);
        
        payable(msg.sender).transfer(redeemAmount);
    }
}