// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/PayPerView.sol";

contract PayPerViewTest is Test {
    PayPerView public payPerView;

    function setUp() public {
        payPerView = new PayPerView();
    }
    
    receive() external payable {}

    fallback() external payable {}

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

    function testPayForView() public {
        string memory cid = "ceci est un cid";
        payPerView.uploadFile(cid, 0.0001 ether);
        payPerView.payForView{value: 0.0001 ether}(cid);
        assertEq(payPerView.isViewer(cid), true);
    }

    function testNotEnoughFunds() public {
        string memory cid = "ceci est un cid";
        payPerView.uploadFile(cid, 0.0001 ether);
        vm.expectRevert(NotEnoughFunds.selector);
        payPerView.payForView{value: 0.00009 ether}(cid);
    }

    function testInvalidPrice() public {
        vm.expectRevert(InvalidPrice.selector);
        payPerView.uploadFile("ceci est un cid", 0);
    }

    function testWithdraw() public {
        string memory cid = "ceci est un cid";
        payPerView.uploadFile(cid, 0.0001 ether);
        payPerView.payForView{value: 0.0001 ether}(cid);
        payPerView.withdraw();
    }
}
