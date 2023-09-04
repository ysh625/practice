// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;
import "@openzeppelin/contracts-upgradeable/token/ERC1155/IERC1155Upgradeable.sol";

interface ITRTERC1155 is IERC1155Upgradeable{
     function mint(address to, uint256 id, uint256 amount) external;
}