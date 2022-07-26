// SPDX-License-Identifier: MIT
pragma solidity ^ 0.8.4;

import "hardhat/console.sol";
import "./ExampleExternalContract.sol";
import "openzeppelin-solidity/contracts/token/ERC20/ERC20.sol";

/**
* @title Contract for staking
* @author scaffold-eth
* @notice Contract allowing user to stake ETH and receive staking rewards
*/

contract Staker {
  // External contract that will old stacked funds
  ExampleExternalContract public exampleExternalContract;

  // Store balances of stakers through addr mapping
  mapping ( address => uint256 ) public balances;

  // Stake threshold (eth)
  uint public constant threshold = 1 ether;

  // Stake deadline
  uint256 public deadline = block.timestamp + 30 seconds;

  // Contract's Events
  event Stake(address indexed sender, uint256 amount);

  // Deadline Modifier
  /**
  * @notice Modifier requiring the deadline to be met
  * @param reached Check if the deadline has reached
  */
  modifier deadlineReached(bool reached){
    uint256 timeRemaining = timeLeft();
    if (reached) require(timeRemaining == 0, "deadline is not due");
    else require(timeRemaining > 0, "deadline has passed");
    _;
  }

  // Threshold Modifier
  /**
  * @notice Modifier requiring the threshold to be met
  * @param reached Check if the threshold has been met
  */
  modifier thresholdReached (bool reached){
    if (reached) require(address(this).balance >= threshold, "threshold not met");
    else require(address(this).balance < threshold, "threshold already met");
    _;
  }

  // Stake Modifier
  /**
  * @notice Modifier that require the external contract to not be completed
  */
  modifier stakeNotCompleted() {
    bool completed = exampleExternalContract.completed();
    require(!completed, "staking process already completed");
    _;
  }


  /**
  * @notice Constructor
  * @param exampleExternalContractAddress Address of the external contract that will hold staked funds
  */
  constructor(address exampleExternalContractAddress) {
      
      exampleExternalContract = ExampleExternalContract(exampleExternalContractAddress);
  }

  // Collect funds in a payable `stake()` function and track individual `balances` with a mapping:
  // ( Make sure to add a `Stake(address,uint256)` event and emit it for the frontend <List/> display )
  /**
  * @notice Stake function to update staker balances by the addition of their staked amount
  */
  function stake() public payable {
    balances[msg.sender] += msg.value;
    emit Stake(msg.sender, msg.value);
  }

  // After some `deadline` allow anyone to call an `execute()` function
  // If the deadline has passed and the threshold is met, it should call `exampleExternalContract.complete{value: address(this).balance}()`
  function execute() public deadlineReached(true) thresholdReached(true) {
    exampleExternalContract.complete{value: address(this).balance}();
  }

  // If the `threshold` was not met, allow everyone to call a `withdraw()` function

  // Add a `withdraw()` function to let users withdraw their balance
  function withdraw() public deadlineReached(true) thresholdReached(false) {

  }

  // Add a `timeLeft()` view function that returns the time left before the deadline for the frontend
  function timeLeft() public view returns (uint256){
    if (block.timestamp >= deadline) return 0;
    return deadline - block.timestamp;
  }

  // Add the `receive()` special function that receives eth and calls stake()
  receive() external payable {
    stake();
  }


}
