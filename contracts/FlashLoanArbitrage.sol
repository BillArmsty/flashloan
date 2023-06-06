//SPDX-License-Identifier: MIT
pragma solidity 0.8.10;

import {IERC20} from "../node_modules/@aave/core-v3/contracts/dependencies/openzeppelin/contracts/IERC20.sol";
import {IPoolAddressesProvider} from "../node_modules/@aave/core-v3/contracts/interfaces/IPoolAddressesProvider.sol";
import {FlashLoanSimpleReceiverBase} from "../node_modules/@aave/core-v3/contracts/flashloan/base/FlashLoanSimpleReceiverBase.sol";
import {IPool} from "../node_modules/@aave/core-v3/contracts/interfaces/IPool.sol";

interface IDex {
    function buyDAI(uint256 _amount) external;

    function sellDAI(uint256 _amount) external;

    function depositUSDC(uint256 _amount) external;

    function depositDAI(uint256 _amount) external;

    function withdraw(address _tokenAddress) external;

    function getBalance(address _tokenAddress) external view returns (uint256);
}

contract FlashLoanArbitrage is FlashLoanSimpleReceiverBase {
    address payable owner;

    //Aave ERC20 Token addresses on Sepolia network
    address private immutable DAI_ADDRESS =
        0x68194a729C2450ad26072b3D33ADaCbcef39D574;

    address private immutable USDC_ADDRESS =
        0xda9d4f9b69ac6C22e444eD9aF0CfC043b7a7f53f;

    address private immutable DEX_CONTRACT_ADDRESS =
        0x3918A384FAA17f840990616fC95CD5B154875792;

    IERC20 private dai;
    IERC20 private usdc;
    IDex private dexContract;

    //Implement constructor
    constructor(
        address _addressProvider
    ) FlashLoanSimpleReceiverBase(_addressProvider) {
        owner = payable(msg.sender);
        dai = IERC20(DAI_ADDRESS);
        usdc = IERC20(USDC_ADDRESS);
        dexContract = IDex(DEX_CONTRACT_ADDRESS);
    }

    //This function is called after your contract has received the flash loaned amount
    function executeOperation(
        address asset,
        uint256 amount,
        uint256 premium,
        address initiator,
        bytes calldata params
    ) external override returns (bool) {
        //Implement Arbitrage Operation
        dexContract.depositUSDC(1000000000); // 1000 USDC
        dexContract.buyDAI();
        dexContract.depositDAI(dai.balanceOf(address(this)));
        dexContract.sellDAI();

        //This contract owes x amount of flashloaned amount + premium to Aave
        //Approve the owed amount to be transfered to Aave
        uint256 totalDebt = amount + premium;
        IERC20(asset).approve(address(POOL), totalDebt);

        return true;
    }

    //Implement requestFlashLoan function
    function requestFlashLoan(address _token, uint256 _amount) public {
        address receiverAddress = address(this);
        address asset = _token;
        uint256 amount = _amount;
        bytes memory params = "";
        uint16 referralCode = 0;

        //Call Aave LendingPool contract to request the flash loan
        POOL.flashLoanSimple(
            receiverAddress,
            asset,
            amount,
            params,
            referralCode
        );
    }

    //Implement approve function
    function approveUSDC(uint256 _amount) external returns (bool) {
        return usdc.approve(DEX_CONTRACT_ADDRESS, _amount);
    }

    function approveDAI(uint256 _amount) external returns (bool) {
        return dai.approve(DEX_CONTRACT_ADDRESS, _amount);
    }

    //Implement allowance function
    function allowanceUSDC() external view returns (uint256) {
        return usdc.allowance(address(this), DEX_CONTRACT_ADDRESS);
    }

    function allowanceDAI() external view returns (uint256) {
        return dai.allowance(address(this), DEX_CONTRACT_ADDRESS);
    }

    //Implement getBalance function
    function getBalance(address _tokenAddress) external view returns (uint256) {
        return IERC20(_tokenAddress).balanceOf(address(this));
    }

    //Implement withdraw function
    function withdraw(address _tokenAddress) external onlyOwner {
        IERC20 token = IERC20(_tokenAddress);
        token.transfer(msg.sender, token.balanceOf(address(this)));
    }

    modifier onlyOwner() {
        require(
            msg.sender == owner,
            "Only the contract owner can call this function"
        );
        _;
    }

    receive() external payable {}
}
