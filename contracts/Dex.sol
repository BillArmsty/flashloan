// SPDX-License-Identifier: MIT
pragma solidity 0.8.10;

import {IERC20} from "@aave/core-v3/contracts/dependencies/openzeppelin/contracts/IERC20.sol";

contract Dex {
    //Implement withdraw function for the contract by owner
    address payable public owner;

    //Aave ERC20 Token addresses on Sepolia network
    address private immutable DAI_ADDRESS =
        0x68194a729C2450ad26072b3D33ADaCbcef39D574;

    address private immutable USDC_ADDRESS =
        0xda9d4f9b69ac6C22e444eD9aF0CfC043b7a7f53f;

    IERC20 private dai;
    IERC20 private usdc;

    //Exchange rate indexes for  DAI/USDC
    uint256 dexARate = 90;
    uint256 dexBRate = 100;

    //Keep track of the dai balances
    mapping(address => uint256) public DAI_BALANCES;

    //Keep track of the usdc balances
    mapping(address => uint256) public USDC_BALANCES;

    //Define constructor
    constructor() {
        owner = payable(msg.sender);
        dai = IERC20(DAI_ADDRESS);
        usdc = IERC20(USDC_ADDRESS);
    }

    //Implement deposit function for the given token
    function depositUSDC(uint256 _amount) external {
        USDC_BALANCES[msg.sender] += _amount;
        uint256 allowance = usdc.allowance(msg.sender, address(this));
        require(allowance >= _amount, "Check the token allowance");
        usdc.transferFrom(msg.sender, address(this), _amount);
    }

    function depositDAI(uint256 _amount) external {
        DAI_BALANCES[msg.sender] += _amount;
        uint256 allowance = dai.allowance(msg.sender, address(this));
        require(allowance >= _amount, "Check the token allowance");
        dai.transferFrom(msg.sender, address(this), _amount);
    }

    //Implement buy function for the given token
    function buyDAI() external {
        uint256 daiToReceive = ((USDC_BALANCES[msg.sender] / dexARate) * 100) *
            (10 ** 12);
        dai.transfer(msg.sender, daiToReceive);
    }

    //Implement sell function for the given token
    function sellDAI() external {
        uint256 usdcToReceive = ((DAI_BALANCES[msg.sender] / dexBRate) * 100) *
            (10 ** 12);
        usdc.transfer(msg.sender, usdcToReceive);
    }

    //Implement withdraw function for the contract by owner
    function withdraw(address _tokenAddress) external onlyOwner {
        IERC20 token = IERC20(_tokenAddress);
        token.transfer(msg.sender, token.balanceOf(address(this)));
    }

    //Implement get balance function for the contract
    function getBalance(address _tokenAddress) external view returns (uint256) {
        return IERC20(_tokenAddress).balanceOf(address(this));
    }
}
