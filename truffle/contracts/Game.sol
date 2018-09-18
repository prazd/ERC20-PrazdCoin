pragma solidity ^0.4.23;

contract IPrazdCoin{
     function transfer(address to, uint256 value) public returns (bool);
     function balanceOf(address who) public constant returns (uint256);
}

contract EasyGame{ 
    
     address public tokenContract_;
     address public owner;
    
     constructor(address _tc){
        owner = msg.sender;
        tokenContract_ = _tc;
    }
    
    uint8 constant MAX_PLAYERS = 2;
    
    uint8 constant ROCK = 0;
    uint8 constant SCISSORS = 1;
    uint8 constant PAPPER = 2;

    uint8 public counter;
    uint8 public rounds;
    
    uint public resCounter;
    address public firstPlayer;
    address public secondPlayer;
  
    bool public gameStatus = false;
    
    mapping(uint256=>address) public results;
    
        struct Player {
        uint8 fPlayerScore;
        uint8 sPlayerScore;
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
    
    function SeeMyPartner() public view returns(address){
        require(msg.sender==firstPlayer || msg.sender==secondPlayer);
        require(counter==MAX_PLAYERS);
        if(msg.sender==firstPlayer){
            return secondPlayer;
        }
        else if(msg.sender==secondPlayer){
            return firstPlayer;
        }
    }
    
    function contractBalance()view public returns(uint256){
        require(msg.sender==owner);
        IPrazdCoin IPC = IPrazdCoin(tokenContract_);
        return IPC.balanceOf(this);
    }
    
    
    function StopGame(address _winner) public payable {
       require(counter==MAX_PLAYERS);
       require(msg.sender==owner);
       require(rounds==3);
       
       results[resCounter] = _winner;
       resCounter++;
       gameStatus = false;
       IPrazdCoin IPC = IPrazdCoin(tokenContract_);
       IPC.transfer(_winner,10);
       counter = 0;
    }
    
    
    mapping(uint=>Player) public scores;

    function GameProcess(uint8 _fbet,uint8 _sbet){
        require(rounds<=3);
        if(_fbet ==_sbet){
            scores[resCounter].fPlayerScore;
            scores[resCounter].sPlayerScore;
        }else if(_fbet==0 && _sbet==1){
            scores[resCounter].fPlayerScore++;
            rounds++;
        }else if(_fbet==1 && _sbet==0){
            scores[resCounter].sPlayerScore++;
            rounds++;
        }
    }
    
    function ShowResults(uint256 _value) public returns(address){
        return results[_value];
    }
    
}