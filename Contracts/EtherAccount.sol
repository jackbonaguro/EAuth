pragma solidity ^0.5.1;

import './Account.sol';

contract EtherAccount is Account {
    address public master;
    
    constructor(address _master) public {
        master = _master;
    }
    
    modifier onlyMaster {
        require(msg.sender == master);
        _;
    }
    
    function withdraw(address payable to, uint amount) onlyMaster public {
        /*if(!to.send(amount)) {
            throw;
        }*/
        to.transfer(amount);
    }
    
    function deposit() payable public {
        return;
    }
    
    function getBalance() public view returns(uint){
        return address(this).balance;
    }
}