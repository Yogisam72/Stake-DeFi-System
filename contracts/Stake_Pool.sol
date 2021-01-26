pragma solidity >=0.4.17 <0.8.0;

import "./MDT_Token.sol";

contract StakePool{

    string public name = "Stake Pool System";

    MdtToken public mdtToken;

    uint reward_period = 1 months;

    address public owner = msg.sender;

    mapping (address => uint) public stakingBalance;
    mapping (address =>  uint) public stakeTime;
	mapping (address => bool) public hasStaked;
	mapping (address => bool) public isStaking;

	address[] public stakers;

	constructor(MdtToken _mdtToken) public{

		mdtToken = _mdtToken;

	}

	function stakeTokens(uint256 _amount) public {

		require (_amount > 0 , 'Amount cannot be 0!');

		require (!isStaking[msg.sender], 'You can only stake after you unstake the current value!');
		
  	
  		// Transfer MDT Tokens to this  contract for staking
		mdtToken.transferFrom(msg.sender, address(this), _amount) ;

  		// Update staking balance and staking time
		stakingBalance[msg.sender] += _amount;
		stakeTime[msg.sender] = now;


  		// Add stakers to the stakers array *ONLY* if they haven't staked already
  		if (!hasStaked[msg.sender]) {
  			stakers.push(msg.sender);
  		}

  		hasStaked[msg.sender] = true;
  		isStaking[msg.sender] = true;
  
	}
	

	function mintRewards(address _staker, uint _balance) public {

		reward_time = uint((now - stakeTime[_staker])/reward_period);

		
		
	}

	function calculateRewards() public {


	}
	
	function unstakeTokens(uint256 _amount) public{

		require(now > staketime[msg.sender] + 1 months , "You can't unstake the MDT Tokens for a minimum of 1 month!");

		uint balance = stakingBalance[msg.sender];
  		
  		require (balance > 0, 'There should be some balance!');

  		mintRewards(msg.sender,balance);

  		mdtToken.transfer(msg.sender, balance);

	  	stakingBalance[msg.sender] =0;
	  	isStaking[msg.sender] = false;




}