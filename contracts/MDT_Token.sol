pragma solidity >=0.4.17 <0.8.0;

// Imported ERC20 and ERC20Capped from OpenZeppelin

import "@openzeppelin\contracts\token\ERC20.sol";
import "@openzeppelin\contracts\token\ERC20Capped.sol";

// @dev : inherited erc20 features
contract MdtToken is ERC20, ERC20Capped{

	uint256 public initialSupply = 10*(10**24); // 10 million initial supply

	constructor() ERC20("MindDeft Token", "MDT") //ERC20
	ERC20Capped(15*(10**24)) //Capped for making final supply of 15 million only
	public{
		_mint(msg.sender, initialSupply); //initialized supply
	}
}
