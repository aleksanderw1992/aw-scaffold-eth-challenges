// SPDX-License-Identifier: MIT
pragma solidity 0.8.4;

import "hardhat/console.sol";
import "./ExampleExternalContract.sol";

contract Staker {

    enum State {
        BEFORE_EXECUTE,
        AFTER_EXECUTE_THRESHOLD_MET,
        AFTER_EXECUTE_THRESHOLD_NOT_MET;
}

    mapping(address => uint256) public balances;
    event Stake(address indexed staker, uint256 indexed value);
    uint256 public constant threshold = 1 ether;
    uint256 public gathered; // Q1 - I understand I won't need this variable, I will use only address(this).balance
    ExampleExternalContract public exampleExternalContract;
    State public state;

    constructor(address exampleExternalContractAddress) {
        exampleExternalContract = ExampleExternalContract(exampleExternalContractAddress);
    }

    // Collect funds in a payable `stake()` function and track individual `balances` with a mapping:
    // ( Make sure to add a `Stake(address,uint256)` event and emit it for the frontend <List/> display )
    function stake() external payable requireState(State.BEFORE_EXECUTE)  returns (bool) {
        balances[msg.sender] +=msg.value;
        gathered +=msg.value;
        emit Stake(msg.sender, msg.value);
        return true;
    }

// After some `deadline` allow anyone to call an `execute()` function
// If the deadline has passed and the threshold is met, it should call `exampleExternalContract.complete{value: address(this).balance}()`
// If the `threshold` was not met, allow everyone to call a `withdraw()` function

    function execute() external requireState(State.BEFORE_EXECUTE) returns (bool) {
        require(timeLeft() ==0, "Deadline not reached");
        if(gathered >= threshold) {
            state=State.AFTER_EXECUTE_THRESHOLD_MET;
            exampleExternalContract.complete{value: address(this).balance}();
            // Q2 -> I will not clear balances here

        } else {
            state=State.AFTER_EXECUTE_THRESHOLD_NOT_MET;
        }
        return true;
    }

// Add a `withdraw()` function to let users withdraw their balance
    function withdraw() external requireState(State.AFTER_EXECUTE_THRESHOLD_NOT_MET) returns (bool) {
        msg.sender.transfer(balances[msg.sender]);
        balances[msg.sender] = 0;
        return true;
    }


// Add a `timeLeft()` view function that returns the time left before the deadline for the frontend
    function timeLeft() public returns (uint256) {
        return 0;
    }

// Add the `receive()` special function that receives eth and calls stake()

    receive() external payable {
        Staker(this).stake();
    }


    modifier requireState(State _state) {
        require(state == _state, 'Cannot execute function with state other than ' + _state );
        _;
    }


}
