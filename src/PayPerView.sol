// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

error UnknownCid();
error UnknownAddress();
error NotEnoughFunds();
error InvalidPrice();

contract PayPerView {
    mapping(address => string) public cids;
    mapping(string => uint256) public prices;
    mapping(string => mapping(address => bool)) public viewers;
    mapping(address => uint256) public balances;

    constructor() {}

    function getCid(address _address) public view returns (string memory) {
        if (bytes(cids[_address]).length == 0) revert UnknownAddress();
        return cids[_address];
    }

    function setCid(address _address, string memory _cid) internal {
        cids[_address] = _cid;
    }

    function setPrice(uint256 _price, string memory _cid) internal {
        prices[_cid] = _price;
    }

    function getPrice(string memory _cid) public view returns (uint256) {
        if (prices[_cid] == 0) revert UnknownCid();
        return prices[_cid];
    }

    function uploadFile(string memory _cid, uint256 _price) public {
        if (_price == 0) revert InvalidPrice();
        setCid(msg.sender, _cid);
        setPrice(_price, _cid);
    }

    function isViewer(string memory _cid) public view returns (bool) {
        return viewers[_cid][msg.sender];
    }

    function payForView(string memory _cid) public payable {
        if (msg.value < getPrice(_cid)) revert NotEnoughFunds();
        viewers[_cid][msg.sender] = true;
        balances[msg.sender] += msg.value;
    }

    function withdraw() public {
        uint256 amountToTransfer = balances[msg.sender];

        (bool success, ) = payable(msg.sender).call{value: amountToTransfer}("");
        require(success, "Transfer failed.");
    }
}
