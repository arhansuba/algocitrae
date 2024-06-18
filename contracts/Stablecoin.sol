// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./IOracle.sol";
import "./IGovernance.sol";

contract Stablecoin is IERC20, Ownable {
    IOracle public oracle;
    IGovernance public governance;

    string public override name;
    string public override symbol;
    uint8 public override decimals;

    uint256 public override totalSupply;
    mapping(address => uint256) public override balanceOf;
    mapping(address => mapping(address => uint256)) public override allowance;

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
    ) Ownable() {
        oracle = _oracle;
        governance = _governance;

        name = _name;
        symbol = _symbol;
        decimals = _decimals;

        targetPrice = _targetPrice;
        collateralFactor = _collateralFactor;
        debtCeiling = _debtCeiling;

        btcPrice = oracle.getBTCPrice(); // Initial fetch of BTC price
    }

    function mint(uint256 _amount) external onlyOwner {
        uint256 btcCollateral = (_amount * btcPrice) / collateralFactor;

        require(
            btcCollateral <= balanceOf[address(this)],
            "Insufficient BTC collateral"
        );

        require(totalSupply + _amount <= debtCeiling, "Exceeded debt ceiling");

        balanceOf[msg.sender] += _amount;
        totalSupply += _amount;

        balanceOf[address(this)] -= btcCollateral;

        emit Transfer(address(0), msg.sender, _amount);
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

        emit Transfer(msg.sender, address(0), _amount);
    }

    function updateTargetPrice() external onlyOwner {
        btcPrice = oracle.getBTCPrice();
        targetPrice = btcPrice * collateralFactor;
    }

    function updateCollateralFactor() external onlyOwner {
        collateralFactor = governance.getCollateralFactor();
        targetPrice = btcPrice * collateralFactor;
    }

    function updateDebtCeiling() external onlyOwner {
        debtCeiling = governance.getDebtCeiling();
    }

    function depositBTC(uint256 _amount) external {
        balanceOf[address(this)] += _amount;
        emit Transfer(msg.sender, address(this), _amount);
    }

    function withdrawBTC(uint256 _amount) external onlyOwner {
        require(
            balanceOf[address(this)] >= _amount,
            "Insufficient BTC balance"
        );

        balanceOf[address(this)] -= _amount;
        emit Transfer(address(this), msg.sender, _amount);
    }

    function transfer(address to, uint256 value) external override returns (bool) {
        require(value <= balanceOf[msg.sender], "Insufficient balance");

        balanceOf[msg.sender] -= value;
        balanceOf[to] += value;

        emit Transfer(msg.sender, to, value);
        return true;
    }

    function approve(address spender, uint256 value) external override returns (bool) {
        allowance[msg.sender][spender] = value;

        emit Approval(msg.sender, spender, value);
        return true;
    }

    function transferFrom(address from, address to, uint256 value) external override returns (bool) {
        require(value <= balanceOf[from], "Insufficient balance");
        require(value <= allowance[from][msg.sender], "Allowance exceeded");

        balanceOf[from] -= value;
        balanceOf[to] += value;
        allowance[from][msg.sender] -= value;

        emit Transfer(from, to, value);
        return true;
    }
}
