// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/proxy/utils/Initializable.sol";

contract Proxy is Initializable {
    address public owner;
    address public implementation;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
    event ImplementationUpdated(address indexed implementation);

    // Modifier to restrict access to only the owner
    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can call this function");
        _;
    }

    // Initialize function for Proxy contract
    function initialize(address initialOwner) external initializer {
        owner = initialOwner; // Set the initial owner
    }

    // Function to transfer ownership
    function transferOwnership(address newOwner) external onlyOwner {
        require(newOwner != address(0), "Invalid new owner address");
        emit OwnershipTransferred(owner, newOwner);
        owner = newOwner;
    }

    // Function to upgrade implementation
    function upgradeTo(address newImplementation) external onlyOwner {
        require(newImplementation != address(0), "Invalid implementation address");
        implementation = newImplementation;
        emit ImplementationUpdated(implementation);
    }

    // Fallback function to delegate calls to implementation contract
    receive() external payable {
        address _impl = implementation;
        require(_impl != address(0), "No implementation contract set");

        assembly {
            let ptr := mload(0x40)
            calldatacopy(ptr, 0, calldatasize())

            let result := delegatecall(gas(), _impl, ptr, calldatasize(), 0, 0)

            let size := returndatasize()
            returndatacopy(ptr, 0, size)

            switch result
            case 0 { revert(ptr, size) }
            default { return(ptr, size) }
        }
    }
}
