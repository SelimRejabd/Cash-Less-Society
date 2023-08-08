// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

contract CashLess {
    address payable public  authority;
    struct Person {
        string name;
        string class;
        uint balance;
        bool created;
    }
    mapping (address => Person)  personDetails;

    constructor () {
        authority = payable(msg.sender);
        personDetails[msg.sender] = Person({
            name : "Authority",
            class : "Authority",
            balance : 0,
            created : true
        });
    }
    function createAccount (string memory _name, string memory _class) public {

        require(personDetails[msg.sender].created == false,"You already have an account.");
        personDetails[msg.sender] = Person({
            name: _name,
            class: _class,
            balance: 0,
            created : true
        });
    }


    function setBalance (address _address, uint _balance) public {
        require(msg.sender==authority, "Only Authority can give tokens");
        personDetails[_address].balance = _balance;

    }

    function makePayment (address _seller, uint _amount) external {
        require(personDetails[msg.sender].balance >= _amount, "You don't have sufficient balance to payment. Please recharge.");
        personDetails[msg.sender].balance -= _amount;
        personDetails[_seller].balance += _amount;
    }



    function withDraw (uint _amount) external {
        require(personDetails[msg.sender].balance >= _amount, "You don't have sufficient balance to withdrw.");
        personDetails[msg.sender].balance -= _amount;
        personDetails[authority].balance +=_amount;
    }

    function getBalance () public view returns (uint) {
        return personDetails[msg.sender].balance;
    }

    function Details (address _address) public view returns (string memory, string memory, uint) {
        require(msg.sender == authority);
        return (
            personDetails[_address].name,
            personDetails[_address].class,
            personDetails[_address].balance
        );
    }
    
}