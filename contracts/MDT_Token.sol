pragma solidity >=0.4.17 <0.8.0;

import "@openzeppelin\contracts\token\ERC20.sol";
import "@openzeppelin\contracts\token\ERC20Capped.sol";

contract MdtToken is ERC20, ERC20Capped{

	uint256 public initialSupply = 10*(10**24);

	constructor() ERC20("MindDeft Token", "MDT") ERC20Capped(15*(10**24)) public(){
		_mint(msg.sender, initialSupply);
	}
}
