// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/PayPerView.sol";

contract PayPerViewTest is Test {
    PayPerView public payPerView;

    function setUp() public {
        payPerView = new PayPerView();
    }

    function testUploadFile() public {
        payPerView.uploadFile("ceci est un cid", 0.0001 ether);
    }

    function testGetCid() public {
        payPerView.uploadFile("ceci est un cid", 0.0001 ether);
        assertEq(payPerView.getCid(address(this)), "ceci est un cid");
    }

    function testGetPrice() public {
        payPerView.uploadFile("ceci est un cid", 0.0001 ether);
        assertEq(payPerView.getPrice("ceci est un cid"), 0.0001 ether);
    }

    function testUnkownCid() public {
        vm.expectRevert(UnknownCid.selector);
        payPerView.getPrice("ceci est un cid inconnu");
    }

    function testUnknownAddress() public {
        vm.expectRevert(UnknownAddress.selector);
        payPerView.getCid(address(0x0));
    }
}
