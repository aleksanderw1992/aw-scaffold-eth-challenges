pragma solidity 0.8.4;
// SPDX-License-Identifier: MIT

import "@openzeppelin/contracts/access/Ownable.sol";
import "./YourToken.sol";

contract Vendor is Ownable {
  uint256 public constant tokensPerEth = 100;
  event BuyTokens(address buyer, uint256 amountOfETH, uint256 amountOfTokens);
  event SellTokens(address seller, uint256 amountOfEthReturned, uint256 amountOfTokens);
  event Withdraw(address to, uint256 amountOfETH);

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
    function withdraw() public payable onlyOwner {
        (bool ok,) = msg.sender.call{value: msg.value}("");
        require(ok, "Failed to withdraw Ether");
        emit Withdraw(msg.sender, msg.value);
    }

  // ToDo: create a sellTokens(uint256 _amount) function:
    function sellTokens(uint256 _amount) external payable {
        yourToken.transferFrom(msg.sender, address(this), _amount);
        uint256 weisToRetrun = _amount / tokensPerEth ;
        (bool ok,) = msg.sender.call{value: weisToRetrun}("");
        if(!ok) {
            revert("sellTokens() failed");
        }
        emit SellTokens(msg.sender, weisToRetrun, _amount);
    }

    fallback() external payable {

    }
}
