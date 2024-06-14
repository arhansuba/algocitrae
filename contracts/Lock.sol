// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;


import "./SafeMath.sol";



contract Lock {
    using SafeMath for uint256;

    uint256 public unlockTime;
    address payable public owner;

    event Withdrawal(uint256 amount, uint256 when);

    constructor(uint256 _unlockTime) payable {
        require(
            _unlockTime > block.timestamp,
            "Unlock time should be in the future"
        );

        unlockTime = _unlockTime;
        owner = payable(msg.sender);
    }

    function withdraw() public {
        require(block.timestamp >= unlockTime, "You can't withdraw yet");
        require(msg.sender == owner, "You aren't the owner");

        uint256 balance = address(this).balance;
        emit Withdrawal(balance, block.timestamp);

        // Use SafeMath to transfer funds securely
        owner.transfer(balance);
    }

    // Function to extend the unlock time (only callable by owner)
    function extendLock(uint256 _newUnlockTime) public {
        require(msg.sender == owner, "You aren't the owner");
        require(_newUnlockTime > unlockTime, "New unlock time must be in the future");

        unlockTime = _newUnlockTime;
    }

    // Function to recover funds accidentally sent to the contract
    function recoverFunds() public {
        require(msg.sender == owner, "You aren't the owner");
        require(block.timestamp >= unlockTime, "Funds are still locked");

        uint256 balance = address(this).balance;
        owner.transfer(balance);
    }

    // Fallback function to accept ether transactions
    receive() external payable {}

    // Function to get the current contract balance
    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }
}
