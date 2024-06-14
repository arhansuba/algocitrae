// SPDX-License-Identifier: MIT 
pragma solidity ^0.8.20;

interface IOracle {
    // Events
    event NewData(bytes32 indexed dataId, uint256 value, uint256 timestamp);
    event DataSourceUpdated(address dataSource, bool added);

    // Functions
    function addDataSource(address _dataSource) external;
    function removeDataSource(address _dataSource) external;
    function requestData(bytes32 _dataId, address _dataSource) external;
    function getData(bytes32 _dataId) external view returns (uint256);
    function getTimestamp(bytes32 _dataId) external view returns (uint256);
}
