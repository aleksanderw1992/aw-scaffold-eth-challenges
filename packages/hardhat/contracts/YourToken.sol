pragma solidity 0.8.4;
// SPDX-License-Identifier: MIT

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
// learn more: https://docs.openzeppelin.com/contracts/3.x/erc20

contract YourToken is ERC20 {
    constructor() ERC20("Gold", "GLD") {
        _mint( address(0x2117Dfd0E98fD6ec0e43c0e76F458D78aa22c664) , 1000 * 10 ** 18);
    }
}
