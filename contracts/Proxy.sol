// SPDX-License-Identifier: MIT 
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Proxy is Initializable, Ownable {
    address public implementation;
    
    event ImplementationUpdated(address indexed implementation);

    constructor() {
        initialize();
    }

    function initialize() public {
        _transferOwnership(msg.sender); // Set the owner to the caller
    }

    function upgradeTo(address _implementation) external {
        require(msg.sender == owner(), "Only the owner can upgrade the implementation");
        require(_implementation != address(0), "Invalid implementation address");
        implementation = _implementation;
        emit ImplementationUpdated(implementation);
    }

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