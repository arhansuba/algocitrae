// SPDX-License-Identifier: MIT 
pragma solidity ^0.8.20;

import "./ChainlinkRequest.sol"; // Adjust the path if necessary
import "@chainlink/contracts/src/v0.8/ChainlinkClient.sol";
import "./IOracle.sol";
//import "./req.sol";



contract Oracle is ChainlinkClient {
    using ChainlinkRequest for ChainlinkRequest.Request;

    mapping(bytes32 => uint256) public data;
    mapping(bytes32 => uint256) public timestamps;
    address[] public dataSources;

    uint256 private fee; // Declare fee as a private variable

    event NewData(bytes32 dataId, uint256 value, uint256 timestamp);
    event DataSourceUpdated(address dataSource, bool added);

    constructor(address _link, address _oracle) {
        setChainlinkToken(_link);
        setChainlinkOracle(_oracle);
        fee = 0.1 * 10 ** 18; // Set your desired fee here, 0.1 LINK as an example
    }

    function addDataSource(address _dataSource) external {
        dataSources.push(_dataSource);
        emit DataSourceUpdated(_dataSource, true);
    }

    function removeDataSource(address _dataSource) external {
        for (uint256 i = 0; i < dataSources.length; i++) {
            if (dataSources[i] == _dataSource) {
                dataSources[i] = dataSources[dataSources.length - 1];
                dataSources.pop();
                emit DataSourceUpdated(_dataSource, false);
                return;
            }
        }
    }

    function requestData(bytes32 _dataId, address _dataSource) external {
        ChainlinkRequest.Request memory req;
        req.initialize(
            keccak256(abi.encodePacked(_dataId, _dataSource)),
            address(this),
            this.fulfill.selector,
            0
        );
        req.add("times", "1"); // Example usage of add function
        sendChainlinkRequestTo(address(oracle), req.id, fee); // Use fee here
    }

    function fulfill(bytes32 _requestId, uint256 _value) public recordChainlinkFulfillment(_requestId) {
        bytes32 dataId = _requestId;
        data[dataId] = _value;
        timestamps[dataId] = block.timestamp;
        emit NewData(dataId, _value, block.timestamp);
    }

    function getData(bytes32 _dataId) external view returns (uint256) {
        return data[_dataId];
    }

    function getTimestamp(bytes32 _dataId) external view returns (uint256) {
        return timestamps[_dataId];
    }

    // Helper function to convert string to bytes32
    function stringToBytes32(string memory _str) internal pure returns (bytes32 result) {
        bytes memory tempEmptyStringTest = bytes(_str);
        if (tempEmptyStringTest.length == 0) {
            return 0x0;
        }

        assembly {
            result := mload(add(_str, 32))
        }
    }
}
