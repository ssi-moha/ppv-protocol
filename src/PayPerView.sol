// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

error UnknownCid();
error UnknownAddress();
error NotEnoughFunds();
error InvalidPrice();
error InvalidAddress();
error FailedTransfer();

contract PayPerView {
    mapping(address => string) public cids;
    mapping(string => uint256) public prices;
    mapping(string => address) public uploaders;
    mapping(string => mapping(address => bool)) public viewers;
    mapping(address => uint256) public balances;

    constructor() {}

    function setUploader(string memory _cid, address _address) private {
        uploaders[_cid] = _address;
    }

    function getUploader(string memory _cid) public view returns (address) {
        return uploaders[_cid];
    }

    function getBalance(address _address) public view returns (uint256) {
        return balances[_address];
    }

    function setBalance(uint256 _balance) private {
        balances[msg.sender] = _balance;
    }

    function getCid(address _address) public view returns (string memory) {
        if (bytes(cids[_address]).length == 0) revert UnknownAddress();
        return cids[_address];
    }

    function setCid(address _address, string memory _cid) private {
        if (_address == address(0)) revert InvalidAddress();
        cids[_address] = _cid;
    }

    function setPrice(uint256 _price, string memory _cid) private {
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
        setUploader(_cid, msg.sender);
    }

    function isViewer(string memory _cid) public view returns (bool) {
        return viewers[_cid][msg.sender];
    }

    function payForView(string memory _cid) public payable {
        uint256 price = getPrice(_cid);

        if (msg.value < price) revert NotEnoughFunds();

        viewers[_cid][msg.sender] = true;
        address uploader = getUploader(_cid);
        uint256 uploaderBalance = getBalance(uploader);
        setBalance(uploaderBalance + msg.value);
    }

    function withdraw() public {
        uint256 amountToTransfer = getBalance(msg.sender);
        setBalance(0);

        (bool success, ) = payable(msg.sender).call{value: amountToTransfer}(
            ""
        );

        if (!success) revert FailedTransfer();
    }
}
