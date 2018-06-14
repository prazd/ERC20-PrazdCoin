pragma solidity ^0.4.22;
import './ERC20Standard.sol' ;
contract PrazdToken is ERC20Standard {
     function NewToken(){
         totalSupply = 10000;
         name = 'My first token';
         decimals = 3;
         symbol = "MFT";
         version = "1.0";
         balances[msg.sender] = totalSupply;
     }
}
