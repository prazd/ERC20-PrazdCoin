pragma solidity ^0.4.23;

import "./ERC20.sol";

contract PazdCoin is MintableToken {
    
    string public constant name = "Prazd Coin";
    
    string public constant symbol = "PRC";
    
    uint32 public constant decimals = 18;
    
    function OwnerIsSS(){
        require(msg.sender==owner);
        setSaleAgent(owner);
    }
}