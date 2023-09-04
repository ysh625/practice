// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts-upgradeable/token/ERC1155/ERC1155Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol";
contract TRTERC1155 is AccessControlUpgradeable, ERC1155Upgradeable {
   
    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");

    function supportsInterface(bytes4 interfaceId) public view virtual override(ERC1155Upgradeable, AccessControlUpgradeable) returns (bool) {
        return super.supportsInterface(interfaceId);
    }

    function initialize() public initializer {
        __AccessControl_init();
         __ERC1155_init("");
        _setupRole(DEFAULT_ADMIN_ROLE, _msgSender());
        _setupRole(MINTER_ROLE, _msgSender());
    }

    function mint(address to, uint256 id, uint256 amount) external onlyRole(MINTER_ROLE) {
        ERC1155Upgradeable._mint(to, id, amount, new bytes(0));
    }
}