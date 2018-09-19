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
    bool public gameStatus = false;
        
    mapping(uint=>Player) public gameInfo;
    
         struct forBet {
         uint8 firstPlayer;
         uint8 secondPlayer;
         }
        
        struct Player {
        address firstPlayer;
        address secondPlayer;
        uint8 fPlayerScore;
        uint8 sPlayerScore;
        address winner;
        mapping(uint8=>forBet) scores;
        uint8 lenF;
        uint8 lenS;
    }

    
    function WantToPlay() public returns(string){
        require(counter<MAX_PLAYERS, "Sorry, w8");
        require(gameStatus==false);
        if(counter==0){
            gameInfo[resCounter].firstPlayer = msg.sender;
            counter++;
            return "You are the firstPlayer";
        }
        else if(counter==1){
            if(msg.sender==gameInfo[resCounter].firstPlayer){
                return "You can't play with yourself";
            }
            gameInfo[resCounter].secondPlayer = msg.sender;
            counter++;
            gameStatus = true;
            rounds = 1;
            return "You are the secondPlayer";
        }
    }
    
    function SeeMyPartner() public view returns(address){
        require(msg.sender==gameInfo[resCounter].firstPlayer || msg.sender==gameInfo[resCounter].secondPlayer);
        require(counter==MAX_PLAYERS);
        if(msg.sender==gameInfo[resCounter].firstPlayer){
            return gameInfo[resCounter].secondPlayer;
        }
        else if(msg.sender==gameInfo[resCounter].secondPlayer){
            return gameInfo[resCounter].firstPlayer;
        }
    }
    
    function contractBalance()view public returns(uint256){
        require(msg.sender==owner);
        IPrazdCoin IPC = IPrazdCoin(tokenContract_);
        return IPC.balanceOf(this);
    }
    
    function setBet(uint8 _bet) public returns(string){
        require(msg.sender==gameInfo[resCounter].firstPlayer || msg.sender==gameInfo[resCounter].secondPlayer);
        require(rounds!=0);
        address secondPlayer = gameInfo[resCounter].secondPlayer;
        address firstPlayer = gameInfo[resCounter].firstPlayer;
        // round1
        if(rounds==1){
            if(msg.sender==firstPlayer && gameInfo[resCounter].lenF==0){
                gameInfo[resCounter].scores[rounds].firstPlayer = _bet;
                gameInfo[resCounter].lenF++;
                return "1 round; firstPlayer";
            }else if(msg.sender==secondPlayer && gameInfo[resCounter].lenS==0){
                gameInfo[resCounter].scores[rounds].secondPlayer = _bet;
                gameInfo[resCounter].lenS++;
                return "1 round; secondPlayer";
            }
            if(gameInfo[resCounter].lenS==1 && gameInfo[resCounter].lenF==1){
                //round2
                rounds++;
                if(msg.sender==firstPlayer && gameInfo[resCounter].lenF==1){
                     gameInfo[resCounter].scores[rounds].firstPlayer = _bet;
                     gameInfo[resCounter].lenF++;
                     return "1 Player;2 round";
                }else if(msg.sender==secondPlayer && gameInfo[resCounter].lenS==1){
                    gameInfo[resCounter].scores[rounds].secondPlayer = _bet;
                    gameInfo[resCounter].lenF++;
                    return "2 Player;2round";
                }
                if(gameInfo[resCounter].lenS==2 && gameInfo[resCounter].lenF==2){
                    //round3 
                    rounds++;
                     if(msg.sender==firstPlayer && gameInfo[resCounter].lenF==2){
                     gameInfo[resCounter].scores[rounds].firstPlayer = _bet;
                     gameInfo[resCounter].lenF++;
                     return "1 Player;3 round";
                }else if(msg.sender==secondPlayer && gameInfo[resCounter].lenS==2){
                    gameInfo[resCounter].scores[rounds].secondPlayer = _bet;
                    gameInfo[resCounter].lenF++;
                    return "2 Player;3 round";
                }
                   
                }
            }
        }
        
    }
    
    function StopGame() public payable {
       require(counter==MAX_PLAYERS);
       require(msg.sender==owner);
       require(rounds==3);
       IPrazdCoin IPC = IPrazdCoin(tokenContract_);
       address _winner;
       if(gameInfo[resCounter].fPlayerScore > gameInfo[resCounter].sPlayerScore){
           _winner = gameInfo[resCounter].firstPlayer;
           IPC.transfer(_winner,10);
       }else if(gameInfo[resCounter].fPlayerScore==gameInfo[resCounter].sPlayerScore){
           _winner = 0x0000000000000000000000000000000000000000;
       }else if(gameInfo[resCounter].sPlayerScore>gameInfo[resCounter].fPlayerScore){
           _winner = gameInfo[resCounter].secondPlayer;
           IPC.transfer(_winner,10);
       }
       gameInfo[resCounter].winner = _winner;
       resCounter++;
       gameStatus = false;
       rounds = 0;
       counter = 0;
    }
    
    
    function ShowResults(uint256 _value) public returns(address){
        return gameInfo[_value].winner;
    }
    
}