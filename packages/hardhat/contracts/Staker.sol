pragma solidity >=0.6.0 <0.7.0;

import "hardhat/console.sol";
import "./VaultContract.sol"; //https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol

contract Staker {

  VaultContract public vaultContract;

  mapping(address => uint256) public balances;
  event Stake(address, uint256);
  uint256 public constant threshold = 1 ether;
  uint256 public deadline = now + 30 seconds;

  constructor(address vaultContractAddress) public {
    vaultContract = VaultContract(vaultContractAddress);
    //vaultContract.transferOwnership(0x0cD5A239D4Bea997D6481217589baD28cA65B131);
  }

  // Collect funds in a payable `stake()` function and track individual `balances` with a mapping:
  //  ( make sure to add a `Stake(address,uint256)` event and emit it for the frontend <List/> display )
   modifier stakingAllowed(){
    require(now <= deadline, "Deadline passed");
    _;
  }

  function stake() public payable stakingAllowed{
    balances[msg.sender] += msg.value;
    emit Stake(msg.sender, msg.value);
  }

  // After some `deadline` allow anyone to call an `execute()` function
  //  It should either call `exampleExternalContract.complete{value: address(this).balance}()` to send all the value
  modifier deadlineReached(){
    require(now > deadline, "Deadline not reached");
    _;
  }

  modifier thresholdNotMet(){
    require(address(this).balance < threshold, "Threshold met");
    _;
  }

  modifier thresholdMet(){
    require(address(this).balance >= threshold, "Threshold not met");
    _;
  }  

  function execute()
  public
  deadlineReached
  thresholdMet
  {
    vaultContract.complete{value: address(this).balance}();
  }

  modifier withdrawerIsFundsOwner(address addr){
    require(addr == msg.sender, "Withdrawer is not the funds owner");
    _;
  }


  // if the `threshold` was not met, allow everyone to call a `withdraw()` function
  function withdraw(address addr)
  public
  deadlineReached
  thresholdNotMet
  withdrawerIsFundsOwner(addr)
  {
    uint256 amount = balances[addr];
    balances[addr] = 0;
    msg.sender.transfer(amount);
  }


  // Add a `timeLeft()` view function that returns the time left before the deadline for the frontend
  function timeLeft() public view returns(uint256){
    if (now>deadline){
      return 0;
    }else{
      return deadline-now;  
    }
  }

}
