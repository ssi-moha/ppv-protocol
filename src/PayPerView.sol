// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

error UnknownCid();
error UnknownAddress();

contract PayPerView {
    mapping(address => string) public cids;
    mapping(string => uint256) public prices;

    constructor() {}

    function getCid(address _address) public view returns (string memory) {
        if(bytes(cids[_address]).length == 0) revert UnknownAddress();
        return cids[_address];
    }

    function setCid(address _address, string memory _cid) internal {
        cids[_address] = _cid;
    }

    function setPrice(uint256 _price, string memory _cid) internal {
        prices[_cid] = _price;
    }

    function getPrice(string memory _cid) public view returns (uint256) {
        if(prices[_cid] == 0) revert UnknownCid();

        return prices[_cid];
    }

    function uploadFile(string memory _cid, uint256 _price) public {
        setCid(msg.sender, _cid);
        setPrice(_price, _cid);
    }
}
