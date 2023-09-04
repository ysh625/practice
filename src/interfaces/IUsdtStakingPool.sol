// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

interface IUsdtStakingPool {
    function userMap(address user) external view returns(address superior ,uint256 stakingTotal,int256 lastStakingTime);
    function operatorManualDeposit(address user, uint256 amount, uint256 period) external ;
}