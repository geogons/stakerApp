pragma solidity >=0.6.0 <0.7.0;

import "@openzeppelin/contracts/access/Ownable.sol";

contract VaultContract is Ownable {

  bool public completed;

  function complete() public payable {
    completed = true;
  }

  //the owner can withdraw the funds to their wallet
  function withdraw()
  public
  onlyOwner
  {
    msg.sender.transfer(address(this).balance);
  }

}
