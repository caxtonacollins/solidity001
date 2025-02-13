// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract Payable {
    address payable public owner;
    mapping(address investors => uint256 amount) internal investments;

    error FunctionDoesNotExist();

    constructor() payable {
       owner = payable(msg.sender);
    }

    function deposit(uint amount) public payable returns (uint256) {
        require(amount == msg.value, "msg.value must equal eth");
       investments[msg.sender] = amount;
       return amount;
    }

    function getMyInvestment() public view returns (uint256 investment) {
        address investor = msg.sender;
        investment = investments[investor];
    }

    function getContractBalance() public view returns (uint256 contractBalance) {
        contractBalance = address(this).balance;
    }

    function getEthBalance() public view returns (uint256 myEthBalance) {
        myEthBalance = address(msg.sender).balance;
    }

    // receive does not have function body
    receive() external payable {}

    fallback() external payable {
        revert FunctionDoesNotExist();
    }
}

contract Funder {
    error FailedToSendEth();

    event Response(bool success, bytes data);

    function sendWithTransfer(address payable _receiver) public payable {
        _receiver.transfer(msg.value);
    }

    function senWithSend(address payable _receiver) public payable returns (bool sent) {
        sent = _receiver.send(msg.value);
    }

    function sendWithCall(address payable _receiver) public payable returns (bool sent, bytes memory data) {
        (sent, data) = _receiver.call{value: msg.value}(""); // were the string serves as a function selector
        // require(sent, "failed to send eth");
        // require(sent, FailedToSendEth());

        if(!sent) {
            revert FailedToSendEth();
        }
    }

    function callDeposit(address payable _payableContractAddress) public payable {
        uint256 amount = msg.value;
        (bool success, bytes memory data) = _payableContractAddress.call{value: amount}(abi.encodeWithSignature("deposit(uint256)", amount));
        emit Response(success, data);
    }
 }