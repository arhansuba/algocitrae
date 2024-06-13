// SPDX-License-Identifier: MIT 
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

// Interfaces need to be correctly defined and imported
// import "@citrea/sdk/contracts/interfaces/IOracle.sol";
// import "@citrea/sdk/contracts/interfaces/IGovernance.sol";

contract Stablecoin is IERC20 {
    IOracle public oracle;
    IGovernance public governance;

    string public name;
    string public symbol;
    uint8 public decimals;

    uint256 public totalSupply;
    mapping(address => uint256) public balanceOf;

    uint256 public btcPrice;
    uint256 public targetPrice;

    uint256 public collateralFactor;
    uint256 public debtCeiling;

    constructor(
        IOracle _oracle,
        IGovernance _governance,
        string memory _name,
        string memory _symbol,
        uint8 _decimals,
        uint256 _targetPrice,
        uint256 _collateralFactor,
        uint256 _debtCeiling
    ) {
        oracle = _oracle;
        governance = _governance;

        name = _name;
        symbol = _symbol;
        decimals = _decimals;

        targetPrice = _targetPrice;
        collateralFactor = _collateralFactor;
        debtCeiling = _debtCeiling;

        totalSupply = 0;
        balanceOf[msg.sender] = 0;
    }

    function mint(uint256 _amount) external {
        require(
            governance.isAdmin(msg.sender),
            "Only the governance contract can mint stablecoins"
        );

        uint256 btcCollateral = (_amount * btcPrice) / collateralFactor;

        require(
            btcCollateral <= balanceOf[address(this)],
            "Insufficient BTC collateral"
        );

        require(
            totalSupply + _amount <= debtCeiling,
            "Exceeded debt ceiling"
        );

        balanceOf[msg.sender] += _amount;
        totalSupply += _amount;

        balanceOf[address(this)] -= btcCollateral;
    }

    function burn(uint256 _amount) external {
        require(
            balanceOf[msg.sender] >= _amount,
            "Insufficient stablecoin balance"
        );

        balanceOf[msg.sender] -= _amount;
        totalSupply -= _amount;

        uint256 btcCollateral = (_amount * btcPrice) / collateralFactor;
        balanceOf[address(this)] += btcCollateral;
    }

    function updateTargetPrice() external {
        require(
            governance.isAdmin(msg.sender),
            "Only the governance contract can update the target price"
        );

        btcPrice = oracle.getBTCPrice();
        targetPrice = btcPrice * collateralFactor;
    }

    function updateCollateralFactor() external {
        require(
            governance.isAdmin(msg.sender),
            "Only the governance contract can update the collateral factor"
        );

        collateralFactor = governance.getCollateralFactor();
        targetPrice = btcPrice * collateralFactor;
    }

    function updateDebtCeiling() external {
        require(
            governance.isAdmin(msg.sender),
            "Only the governance contract can update the debt ceiling"
        );

        debtCeiling = governance.getDebtCeiling();
    }

    function depositBTC(uint256 _amount) external {
        require(
            balanceOf[address(this)] + _amount >= balanceOf[address(this)],
            "BTC deposit failed"
        );

        balanceOf[address(this)] += _amount;
    }

    function withdrawBTC(uint256 _amount) external {
        require(
            balanceOf[address(this)] >= _amount,
            "Insufficient BTC balance"
        );

        balanceOf[address(this)] -= _amount;
    }
}
