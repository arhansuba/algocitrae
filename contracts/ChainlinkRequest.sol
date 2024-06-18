// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

library ChainlinkRequest {
    struct Request {
        bytes32 id;
        address callbackAddress;
        bytes4 callbackFunctionId;
        uint256 nonce;
        mapping(string => string) params; // Mapping to store key-value parameters
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
        self.params[_key] = _value;
    }

    function getParam(Request storage self, string memory _key) internal view returns (string memory) {
        return self.params[_key];
    }
}
