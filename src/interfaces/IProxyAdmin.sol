// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;


interface ITransparentUpgradeableProxy  {
    function admin() external view returns (address);

    function implementation() external view returns (address);

    function changeAdmin(address) external;

    function upgradeTo(address) external;

    function upgradeToAndCall(address, bytes memory) external payable;
}

interface IProxyAdmin {
    function getProxyImplementation(ITransparentUpgradeableProxy proxy) external view  returns (address);
    function getProxyAdmin(ITransparentUpgradeableProxy proxy) external view  returns (address);
    function changeProxyAdmin(ITransparentUpgradeableProxy proxy, address newAdmin) external;
    function upgrade(ITransparentUpgradeableProxy proxy, address implementation) external;
    function upgradeAndCall(
        ITransparentUpgradeableProxy proxy,
        address implementation,
        bytes memory data
    ) external payable;
}