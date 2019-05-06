pragma solidity ^0.5.1;

/*
EAuth Contract
*/

import './Account.sol';

/*
A community-based Smart Wallet, allows a [variable ratio](3+ for now)
of 'Trustees' (other EAuth instances), to replace its owner.

Smart Wallet is implemented via 'Meta-meta-transactions',
by calling the `withdraw` method of registered accounts.
*/
contract EAuth {
    address public owner;
    
    //Account Stuff
    mapping(uint => Account) public accounts;
    uint public accountsCount;
    
    mapping(address => bool) public trustees;
    uint public trusteesCount;
    
    //Revocation Stuff
    mapping(address => uint) public revocations;
    
    constructor(address _owner) public {
        owner = _owner;
    }
    
    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }
    
    modifier onlyTrustee {
        require(trustees[msg.sender]);
        _;
    }
    
    function addAccount(address accountAddress) onlyOwner public {
        Account a = Account(accountAddress);
        accounts[accountsCount] = a;
        accountsCount++;
    }
    
    function addTrustee(address trusteeAddress) onlyOwner public {
        trustees[trusteeAddress] = true;
        trusteesCount++;
    }
    
    function withdraw(uint account, address payable to, uint amount) onlyOwner public {
        Account a = Account(accounts[account]);
        a.withdraw(to, amount);
    }
    
    function revoke(address newOwner) onlyTrustee public {
        require(newOwner != owner);
        
        revocations[newOwner]++;
        if (revocations[newOwner] >= 3) {
            owner = newOwner;
            revocations[newOwner] = 0;
        }
    }
    
    function metaRevoke(address target, address newOwner) onlyOwner public {
        EAuth e = EAuth(target);
        e.revoke(newOwner);
    }
}