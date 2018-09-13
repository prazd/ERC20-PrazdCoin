pragma solidity ^0.4.21;


contract Ownable {
    
    address owner;
    
    function Ownable() public {
        owner = msg.sender;
    }
 
    modifier onlyOwner{
        require(msg.sender == owner);
        _;
    }
 
    function transferOwnership(address newOwner) public onlyOwner {
        owner = newOwner;
    }
    
}

contract PCoin is Ownable{
    
    string public constant name = "Simple Prazd Coin";
    
    string public constant symbol = "SPC";
    
    uint32 public constant decimals = 18;
    
    uint public totalSupply = 0;
    
    mapping (address => uint) balances;
    
    function balanceOf(address _owner) public constant returns (uint balance) {
        return balances[_owner];
    }
 
    function transfer(address _to, uint _value) public returns (uint success) {
        if(balances[msg.sender] >= _value){
            balances[msg.sender] -= _value; 
            balances[_to] += _value;
            Transfer(msg.sender, _to, _value);
            return balances[msg.sender];
        }
        
        return balances[msg.sender];
    }
    
    function transferFrom(address _from, address _to, uint _value) public returns (bool success) {
        if(balances[_from] >= _value && balances[_to] + _value >= balances[_to]){
            balances[_from] -= _value;
            balances[_to] += _value;
            Transfer(_from, _to , _value);
            return true;
        }
        return false; 
    }
    
    
    function approve(address _spender, uint _value) public returns (bool success) {
        return true;
    }
    
    function allowance(address _owner, address _spender) public constant returns (uint remaining) {
        return 0;
    }
    
    event Transfer(address indexed _from, address indexed _to, uint _value);
    
    event Approval(address indexed _owner, address indexed _spender, uint _value);
    
    function getOwner() view public returns(address){
        return owner;
    }
    // Mint 
    function mint(address _to, uint _value) public onlyOwner{
      assert(totalSupply + _value >= totalSupply && balances[_to] + _value >= balances[_to]);
      balances[_to] += _value;
      totalSupply += _value;
    }
    
}