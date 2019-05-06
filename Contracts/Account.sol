pragma solidity ^0.5.1;

interface Account {
    function withdraw(address payable, uint) external;
    function deposit() payable external;
}