// SPDX-License Identifier: MIT
pragma solidity ^0.6.6;

import "./interfaces/ILendingPool.sol";
import "./aaave/FlashLoanReceiverBase.sol";
import "./interfaces/ILendingPoolAddressesProvider.sol";

contract Flashloan is FlashLoanReceiverBase {
    constructor(
        address _addressProvider
    ) public FlashLoanReceiverBase(_addressProvider) {}

    function startFlashloan(uint256 amount) public {
        address receiverAddress = address(this);

        address[] memory assets = new address[](1);
        assets[0] = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE; // ETH

        uint256[] memory amounts = new uint256[](1);
        amounts[0] = amount;

        uint256[] memory modes = new uint256[](1);
        modes[0] = 0; // no debt

        address onBehalfOf = address(this);
        bytes memory params = "";

        uint16 referralCode = 0;

        ILendingPool lendingPool = ILendingPool(
            addressesProvider.getLendingPool()
        );
        lendingPool.flashLoan(
            receiverAddress,
            assets,
            amounts,
            modes,
            onBehalfOf,
            params,
            referralCode
        );
    }

    function executeOperation(
        address[] calldata assets,
        uint256[] calldata amounts,
        uint256[] calldata premiums,
        address initiator,
        bytes calldata params
    ) external override returns (bool) {
        // do whatever you want with the funds
        // NOTE: If you want to use the received ETH you MUST use the `initiator` address
        // Avoid reentrancy
        return true;
    }
}
