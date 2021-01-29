// SPDX-License-Identifier: MIT

pragma solidity >=0.4.22 <0.9.0;

// Imported ERC20 and ERC20Capped from OpenZeppelin

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

// @dev : inherited erc20 features
contract MdtToken is ERC20, Ownable{
     using SafeMath for uint256;

    uint256 private _cap = 15*(10**24);

	uint256 public initialSupply = 10*(10**24); // 10 million initial supply

	constructor() public  ERC20("MindDeft Token", "MDT") 
	{
		_mint(msg.sender, initialSupply); //initialized supply
	}
	
	function mint(address to, uint256 amount) public  {
    _mint(to, amount);
    }
    /**
     * @dev Returns the cap on the token's total supply.
     */
    function cap() public view virtual returns (uint256) {
        return _cap;
    }

    /**
     * @dev See {ERC20-_beforeTokenTransfer}.
     *
     * Requirements:
     *
     * - minted tokens must not cause the total supply to go over the cap.
     */
    function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual override{
        super._beforeTokenTransfer(from, to, amount);

        if (from == address(0)) { // When minting tokens
            require(totalSupply().add(amount) <= cap(), "ERC20Capped: cap exceeded");
        }
    }
}
