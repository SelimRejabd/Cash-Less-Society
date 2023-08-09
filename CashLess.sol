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

    constructor (string memory _name) {
        authority = payable(msg.sender);
        // personDetails[msg.sender] = Person({
        //     name : "Authority",
        //     class : "Authority",
        //     balance : 0,
        //     created : true
        // });
        createAccount(_name, "Authority");

    }

    function addMoney (uint _amount) public {
        require(msg.sender == authority, "You cannot add tokens to authority account");
        personDetails[authority].balance = _amount;
    }

    function createAccount (string memory _name, string memory _class) public {

        require(personDetails[msg.sender].created == false,"You already have an account.");
        personDetails[msg.sender] = Person({
            name: _name,
            class: _class,
            balance: personDetails[msg.sender].balance,
            created : true
        });
    }

    function transfer (address _from, address _to, uint _amount) internal {
        personDetails[_from].balance -= _amount;
        personDetails[_to].balance += _amount;
    }

    function setBalance (address _address, uint _amount) public {
        require(msg.sender==authority, "Only Authority can give tokens");
        require(personDetails[msg.sender].balance >= _amount, "You don't have sufficient balance. Pelease add tokens.");
        transfer(authority, _address, _amount);
    }

    function makePayment (address _seller, uint _amount) external {
        require(personDetails[msg.sender].balance >= _amount, "You don't have sufficient balance to payment. Please add tokens.");
        transfer(msg.sender, _seller, _amount);
    }

    function withDraw (uint _amount) external {
        require(personDetails[msg.sender].balance >= _amount, "You don't have sufficient balance to withdraw.");
        transfer(msg.sender, authority, _amount);
    }

    function getBalance () public view returns (uint) {
        return personDetails[msg.sender].balance;
    }

    function Details (address _address) public view returns (string memory, string memory, uint) {
        require(msg.sender == authority || msg.sender == _address, "You don't have permission to see details.");
        return (
            personDetails[_address].name,
            personDetails[_address].class,
            personDetails[_address].balance
        );
    }
    
}