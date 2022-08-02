pragma solidity 0.8.4;
// SPDX-License-Identifier: MIT

import "@openzeppelin/contracts/access/Ownable.sol";
import "./YourToken.sol";

contract Vendor is Ownable {
  uint256 public constant tokensPerEth = 100;
  event BuyTokens(address buyer, uint256 amountOfETH, uint256 amountOfTokens);

  YourToken public yourToken;

  constructor(address tokenAddress) {
    yourToken = YourToken(tokenAddress);
  }

    function buyTokens() public payable {
        uint256 noTokens = msg.value * tokensPerEth;
        bool ok = yourToken.transfer(msg.sender, noTokens);
        if(!ok) {
            revert("transfer() failed");
        }
        emit BuyTokens(msg.sender, msg.value, noTokens);
    }

  // ToDo: create a withdraw() function that lets the owner withdraw ETH

  // ToDo: create a sellTokens(uint256 _amount) function:

    fallback() external payable {

    }
}
