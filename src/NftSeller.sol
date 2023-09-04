// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;
import "@openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC20/IERC20Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC20/utils/SafeERC20Upgradeable.sol";
import "./interfaces/IUsdtStakingPool.sol";
import "./interfaces/ITRTERC1155.sol";
contract NftSeller is AccessControlUpgradeable {
    using SafeERC20Upgradeable for IERC20Upgradeable;
    
    bytes32 public constant OPERATOR = keccak256("OPERATOR");
    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
    address public constant USDT = 0xb1bb1De18409976277495a1A659EC1d50c224Be6;
    address public constant NFT = 0xaFcd2269C56b0A7c78d847EF1d013B9d05BCc72E;
    address public constant UsdtStakingPool = 0x0FACEFfE1e6Ae64Bbec0bbB85F8c2a85B4F7f7be;
    address public feeAddress;

    function initialize() initializer public {
        _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _setupRole(MINTER_ROLE, msg.sender);
        feeAddress = 0x8DfD5e9B9Ea6492e14993Fe9bE3e9809A612cff4;
    }

    //1.创世卫星 2.创世行星 3.创世恒星
    function buy(uint256 id, uint256 amount) external {
        require(id >= 1 && id <=3, "NftSeller: Id is error");
        require(amount >= 1 && id <=10, "NftSeller: amount is error");
        uint256 totalAmount = 0;
        if (id == 1) {
             totalAmount = amount * 1500 ether;
        } else if (id == 2) {
             totalAmount = amount * 10000 ether;
        } else if (id == 3) {
             totalAmount = amount * 30000 ether;
        }
        if (totalAmount > 0) {
            ITRTERC1155(NFT).mint(msg.sender, id, amount);
            IERC20Upgradeable(USDT).safeTransferFrom(_msgSender(), feeAddress, totalAmount);
            IUsdtStakingPool(UsdtStakingPool).operatorManualDeposit(msg.sender, totalAmount, 30 );
            emit BuyNft(msg.sender, id, amount);
        }
    }

    function SetFeeAddress(address v) external onlyRole(OPERATOR) {
        emit ChangeFeeAddress(feeAddress, v);
        feeAddress = v;
    }

    event ChangeFeeAddress(address indexed oldVal, address indexed newVal);
    event BuyNft(address indexed user, uint256 indexed id, uint256 amount);
}