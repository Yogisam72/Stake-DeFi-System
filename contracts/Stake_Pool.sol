// SPDX-License-Identifier: MIT


pragma solidity >=0.4.22 <0.9.0;

//Imported MDT Token from contracts
import "./MDT_Token.sol";

/* @author: The StakePool contract locks the coins for staking, such that an address can stake the coin once only.
			The effective interest rate = 0.41% which is compounded monthly. The Annual Percentage Yeild can be 
			expected of approx 5.03%.  
*/
contract StakePool{

	// @dev : Stake Pool System
	string public name = "Stake Pool System";

	MdtToken public mdtToken; //Initialized MdtToken contract

	uint reward_period = 1 minutes; // reward period is 30 days
	uint decimals = 4;
	uint interest_rate = 41;

	address public owner = msg.sender;

	mapping (address => uint) public stakingBalance; // stores staking balance for address
	mapping (address => uint) public stakeTime; // stores staking time for the instant staking starts
	mapping (address => bool) public hasStaked; 
	mapping (address => bool) public isStaking;

	address[] public stakers; // address array of stakers

	constructor(MdtToken _mdtToken) public{

		mdtToken = _mdtToken;

	}

	function getBal(address _caller) public view returns(uint256) {
	    
	   return mdtToken.balanceOf(_caller);
	    
	}

	function stakeTokens(uint _amount) public {

		require (_amount > 0 , 'Amount cannot be 0!');

		require (!isStaking[msg.sender], 'You can only stake after you unstake the current value!');
		
  	
  		// Transfer MDT Tokens to this contract for staking
		mdtToken.transferFrom(msg.sender, address(this), _amount) ;

  		// Update staking balance and staking time
		stakingBalance[msg.sender] += _amount;
		stakeTime[msg.sender] = block.timestamp;


  		// Add stakers to the stakers array *ONLY* if they haven't staked already
  		if (!hasStaked[msg.sender]) {
  			stakers.push(msg.sender);
  		}

  		hasStaked[msg.sender] = true;
  		isStaking[msg.sender] = true;
  
	}
	

	function mintRewards(address _staker, uint _balance) private {

		
		uint reward_time = uint((block.timestamp - stakeTime[_staker])/reward_period);

		uint reward_tokens = calculateRewards(_balance, reward_time);
		mdtToken.mint(address(this), reward_tokens);

		stakingBalance[_staker] += reward_tokens;

	}

	function calculateRewards(uint _balance, uint _rewardTime) public view returns(uint){
	    
	    uint amt=_balance;
	    
	    for(uint i=0; i<_rewardTime ; i++){
	        amt = (amt*10041)/10000;
	    }
		
		uint _reward = amt - _balance;
		return _reward;
	}
	
	function unstakeTokens() public{
		require(isStaking[msg.sender], "You are not staking anything currently!");
		require(block.timestamp > stakeTime[msg.sender] + reward_period , "You can't unstake the MDT Tokens for a minimum of 1 minutes!");

		uint balance = stakingBalance[msg.sender];
  		
  		require (balance > 0, 'There should be some balance!');

  		mintRewards(msg.sender,balance);
  		balance = stakingBalance[msg.sender];
  		mdtToken.transfer( msg.sender, balance);

	  	stakingBalance[msg.sender] =0;
	  	stakeTime[msg.sender]= 0;
	  	isStaking[msg.sender] = false;
	}


}