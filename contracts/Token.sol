// SPDX-License-Identifier: MIT 
pragma solidity ^0.8.20;


import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Token is ERC20, Ownable {
    // Constructor
    constructor() ERC20("DeFi Token", "DFI") {
        // Mint initial supply to the contract deployer
        _mint(msg.sender, 100000000 * (10 ** uint256(decimals())));
    }

    // Override transfer function to add Ownable check
    function transfer(address recipient, uint256 amount) public override onlyOwner returns (bool) {
        return super.transfer(recipient, amount);
    }

    // Override transferFrom function to add Ownable check
    function transferFrom(address sender, address recipient, uint256 amount) public override onlyOwner returns (bool) {
        return super.transferFrom(sender, recipient, amount);
    }
}
