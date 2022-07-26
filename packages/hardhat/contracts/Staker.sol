// SPDX-License-Identifier: MIT
pragma solidity ^ 0.8.4;

import "hardhat/console.sol";
import "./ExampleExternalContract.sol";
import "openzeppelin-solidity/contracts/token/ERC20/ERC20.sol";

contract Staker {

  mapping ( address => uint256 ) public balances;
  uint public constant threshold = 1;
  uint public constant deadline = 2;

  constructor(address exampleExternalContractAddress) {
      
  }

  // Collect funds in a payable `stake()` function and track individual `balances` with a mapping:
  // ( Make sure to add a `Stake(address,uint256)` event and emit it for the frontend <List/> display )
  function stake(uint _stake) public {
    _burn(msg.sender, _stake);
    balances[msg.sender] += _stake;
  }

  // After some `deadline` allow anyone to call an `execute()` function
  // If the deadline has passed and the threshold is met, it should call `exampleExternalContract.complete{value: address(this).balance}()`


  // If the `threshold` was not met, allow everyone to call a `withdraw()` function


  // Add a `withdraw()` function to let users withdraw their balance


  // Add a `timeLeft()` view function that returns the time left before the deadline for the frontend


  // Add the `receive()` special function that receives eth and calls stake()


}
