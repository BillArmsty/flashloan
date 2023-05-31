// SPDX-License Identifier: MIT
pragma solidity 0.8.10;

import {IERC20} from "@aave/core-v3/contracts/dependencies/openzeppelin/contracts/IERC20.sol";
import {IPoolAddressesProvider} from "@aave/core-v3/contracts/interfaces/IPoolAddressesProvider.sol";
import {FlashLoanSimpleReceiverBase} from "@aave/core-v3/contracts/flashloan/base/FlashLoanSimpleReceiverBase.sol";

contract Flashloan is FlashLoanSimpleReceiverBase {
    //Implement withdraw function for the contract by owner
    address payable owner;

    //Define constructor
    constructor(address _addressProvider) 
        FlashLoanSimpleReceiverBase(IPoolAddressesProvider(_addressProvider)) 
        {
            owner = payable(msg.sender);
        }


    //Implement executeOperation function

    function executeOperation(
        address asset,
        uint256 amount,
        uint256 premium,
        address initiator,
        bytes calldata params
    ) external override returns (bool) {

    //Mock Arbitrage Logic

    uint256 amountToRepay = amount + premium;
    IERC20(asset).approve(address(POOL), amountToRepay);

    return true;
    }

    //Implement flashloan function
    function requestFlashLoan() public {
        
    }
}
