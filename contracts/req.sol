// SPDX-License-Identifier: MIT 
pragma solidity ^0.8.20;

library ChainlinkRequest {
    struct Request {
        bytes32 id;
        address callbackAddress;
        bytes4 callbackFunctionId;
        uint256 nonce;
    }

    function initialize(
        Request storage self,
        bytes32 _id,
        address _callbackAddress,
        bytes4 _callbackFunctionId,
        uint256 _nonce
    ) internal {
        self.id = _id;
        self.callbackAddress = _callbackAddress;
        self.callbackFunctionId = _callbackFunctionId;
        self.nonce = _nonce;
    }

    function add(Request storage self, string memory _key, string memory _value) internal {
        // Implement your logic to add parameters to the Chainlink request
        // For example, store them in mappings or arrays
        // This is a simplified example, adjust as per your requirements
        // For more complex scenarios, you may need to handle data serialization
    }
}
