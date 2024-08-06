// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

contract PausableToken{

    address public owner;
    bool public paused;
    mapping (address => uint) public balances;

    constructor(){
        owner = msg.sender;
        paused = false;
        balances[owner] = 1000;
    }

    modifier onlyOwner (){
        // implement the modifier to allow only the owner to call the function;

            require(msg.sender == owner, "You are not the owner.");
            _;
    }

    // implement the modifier to check if the contract is not paused

    modifier notPause(){
        require(paused == false, "the contract is paused");
    _;
    }

    function pause () public onlyOwner{
        paused = true;
    }

    function unpause() public onlyOwner{
        paused = false;
    }

    function transfer (address to, uint amount) public notPause {
        require (balances[owner] >= amount,"insuficient balance");

        balances[msg.sender] -= amount;
        balances[to] += amount;
    }
}