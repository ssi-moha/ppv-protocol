// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.11;

import "forge-std/Script.sol";
import "../src/PayPerView.sol";

contract PayPerViewScript is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        address yourAddress = vm.addr(deployerPrivateKey);
        vm.startBroadcast(deployerPrivateKey);

        PayPerView payPerView = new PayPerView();

        vm.stopBroadcast();
    }
}
