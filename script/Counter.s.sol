// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import "../src/attack.sol";
import "../src/A.sol";

contract CounterScript is Script {
    uint256 public deployerPrivateKey;
    address public deployerEoa;
    Attack public attack;
    address public setupAddr = 0xb2Bb4c3a1E58D8df34Cc41b39c22197eD239826F;

    function setUp() public {
        deployerPrivateKey = vm.envUint("YSH_PRIVATE_KEY");
        //MAINNET_RPC=vm.envString("PRIVATE_KEY");
        deployerEoa = vm.rememberKey(deployerPrivateKey);
    }

    function run() public {
        vm.startBroadcast(deployerPrivateKey);
        uint256 _random02 = 0x100 -
            ((uint256(uint160(address(setupAddr))) + 1 + 2 + 32) % 0x100) +
            2;
        SetUp(address(setupAddr)).guessGame().guess{value: 1}(
            0x60,
            _random02,
            0x02,
            10
        );

        vm.stopBroadcast();
    }
}
