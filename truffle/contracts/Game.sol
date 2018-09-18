pragma solidity ^0.4.23;

import "./PrazdCoin.sol";

contract EasyGame{ 
    
     address public tokenContract_;
     address owner;
    
     constructor(address _tc){
        owner = msg.sender;
        tokenContract_ = _tc;
    }

    uint8 constant MAX_PLAYERS = 2;
    
    uint8 constant ROCK = 0;
    uint8 constant SCISSORS = 1;
    uint8 constant PAPPER = 2;

    uint8 public counter;
    uint8 rounds;
    
    uint public resCounter;
   
    address public firstPlayer;
    address public secondPlayer;
    address winner;
  
    
    bool public gameStatus = false;
    
    mapping(uint256=>address) public results;
    
    modifier Ownable{
        msg.sender==owner;
        _;
    }
    
    modifier ForMax{
        require(counter==MAX_PLAYERS);
        _;
    }
    
      modifier OwnerForMax{
        require(msg.sender==owner);
        require(counter==MAX_PLAYERS);
        _;
    }
    
 
    function WantToPlay() public returns(string){
        require(counter<MAX_PLAYERS, "Sorry, w8");
        require(gameStatus==false);
        if(counter==0){
            firstPlayer = msg.sender;
            counter++;
            return "You are the firstPlayer";
        }
        else if(counter==1){
            if(msg.sender==firstPlayer){
                return "You can't play with yourself";
            }
            secondPlayer = msg.sender;
            counter++;
            gameStatus = true;
            return "You are the secondPlayer";
        }
    }
    
    function SeeMyPartner() public view ForMax returns(address){
        require(msg.sender==firstPlayer || msg.sender==secondPlayer);
        if(msg.sender==firstPlayer){
            return secondPlayer;
        }
        else if(msg.sender==secondPlayer){
            return firstPlayer;
        }
    }
    
    function StopGame(address _winner) public payable OwnerForMax{
       results[resCounter] = _winner;
       resCounter++;
       gameStatus = false;
       PrazdCoin IPC = PrazdCoin(tokenContract_);
       IPC.transfer(_winner,29);
       counter = 0;
    }
    
    function ShowResults(uint256 _value) public returns(address){
        return results[_value];
    }
    
}