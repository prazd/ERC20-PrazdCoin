pragma solidity ^0.4.23;

contract IPrazdCoin{
     function transfer(address to, uint256 value) public returns (bool);
     function balanceOf(address who) public constant returns (uint256);
     function MakeOwnerSaleAgent(){}
     function mint(address _to, uint256 _amount) public returns (bool) {}
     function SetGC(address _contract){}
     function setSaleAgent(address newSaleAgnet) public {}
}

contract EasyGame{ 
    
     address public tokenContract_;
     address public owner;
     uint price;
     
     constructor(address _tc){
        owner = msg.sender;
        tokenContract_ = _tc;
        IPrazdCoin IPC = IPrazdCoin(tokenContract_);
        IPC.SetGC(this);
        IPC.setSaleAgent(this);
        price = 1 ether;
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

    function WantToPlay() public payable returns(string){
        require(counter<MAX_PLAYERS, "Sorry, w8");
        require(gameStatus==false);
        require(msg.value==price);
        IPrazdCoin IPC = IPrazdCoin(tokenContract_);
        owner.transfer(msg.value);
        if(counter==0){
            gameInfo[resCounter].firstPlayer = msg.sender;
            counter++;
            IPC.mint(this,5);
            return "You are the firstPlayer";
        }
        else if(counter==1){
            if(msg.sender==gameInfo[resCounter].firstPlayer){
                return "You can't play with yourself";
            }
            gameInfo[resCounter].secondPlayer = msg.sender;
            IPC.mint(this,5);
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
    
    function RoundsGame(address _player, uint8 _bet, uint8 _round) private {
        address secondPlayer = gameInfo[resCounter].secondPlayer;
        address firstPlayer = gameInfo[resCounter].firstPlayer;
        if(_player==firstPlayer && gameInfo[resCounter].lenF ==_round){
             gameInfo[resCounter].scores[rounds].firstPlayer = _bet;
             gameInfo[resCounter].lenF++;
        }else if(_player==secondPlayer && gameInfo[resCounter].lenS==_round){
             gameInfo[resCounter].scores[rounds].secondPlayer = _bet;
             gameInfo[resCounter].lenS++;
        }
        
        if(gameInfo[resCounter].lenF==3 && gameInfo[resCounter].lenS==3) {
            rounds = 0;
            // firstRound
            uint8 i;
            for(i=1;i<4;i++){
                 if(gameInfo[resCounter].scores[i].firstPlayer == gameInfo[resCounter].scores[i].secondPlayer){
                     gameInfo[resCounter].sPlayerScore++;
                     gameInfo[resCounter].fPlayerScore++;
            }
            else if(gameInfo[resCounter].scores[i].firstPlayer == 1 && gameInfo[resCounter].scores[i].secondPlayer==0) 
               gameInfo[resCounter].sPlayerScore++;
            else if(gameInfo[resCounter].scores[i].firstPlayer == 0 && gameInfo[resCounter].scores[i].secondPlayer==1)
               gameInfo[resCounter].fPlayerScore++;
            else if(gameInfo[resCounter].scores[i].firstPlayer == 1 && gameInfo[resCounter].scores[i].secondPlayer==2)
               gameInfo[resCounter].fPlayerScore++;
            else if(gameInfo[resCounter].scores[i].firstPlayer == 2 && gameInfo[resCounter].scores[i].secondPlayer==1)
               gameInfo[resCounter].sPlayerScore++;
            else if(gameInfo[resCounter].scores[i].firstPlayer == 2 && gameInfo[resCounter].scores[i].secondPlayer==0)
               gameInfo[resCounter].fPlayerScore++;
            else if(gameInfo[resCounter].scores[i].firstPlayer == 0 && gameInfo[resCounter].scores[i].secondPlayer==2)
               gameInfo[resCounter].sPlayerScore++;
            }
            StopGame();
        }
    }
    
    function setBet(uint8 _bet) public returns(bool){
        require(msg.sender==gameInfo[resCounter].firstPlayer || msg.sender==gameInfo[resCounter].secondPlayer);
        require(rounds!=0);
        require(gameStatus==true);
        require(_bet==0 || _bet==1 || _bet==2);
        // round 1
        if(gameInfo[resCounter].lenF<1 || gameInfo[resCounter].lenS<1){
                    RoundsGame(msg.sender, _bet, 0);
                    if(gameInfo[resCounter].lenF==1 && gameInfo[resCounter].lenS==1) rounds++;
                    return true;
        }
        if(gameInfo[resCounter].lenS<2 || gameInfo[resCounter].lenF<2){
        //round2
                    RoundsGame(msg.sender, _bet, 1);
                    if(gameInfo[resCounter].lenF==2 && gameInfo[resCounter].lenS==2) rounds++;
                    return true;
        }
        if(gameInfo[resCounter].lenS<3 || gameInfo[resCounter].lenF<3){
        //round3 
                    RoundsGame(msg.sender, _bet, 2);
                    
                    return true;
        }
    }
    
    function StopGame() private {
       require(gameInfo[resCounter].lenF==3 && gameInfo[resCounter].lenS==3);
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
       counter = 0;
    }
    
    function ShowResults(uint256 _value) public returns(address){
        return gameInfo[_value].winner;
    }
    
}