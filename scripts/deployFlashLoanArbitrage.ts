// import { ethers } from "hardhat";

// async function main() {
//     const [deployer] = await ethers.getSigners();
//     console.log("Deploying Flash loan arbitrage with the account:", deployer.address);
//     console.log("Account balance:", (await deployer.getBalance()).toString());


//     const FlashLoanArbitrage = await ethers.getContractFactory("FlashLoanArbitrage");


//     const flashLoanArbitrage = await FlashLoanArbitrage.deploy("0x0496275d34753A48320CA58103d5220d394FF77F");

//     await flashLoanArbitrage.deployed();
//     console.log("Flash loan arbitrage deployed to:", flashLoanArbitrage.address);

// }

// main().catch((error) => {

//     console.error(error);
//     process.exitCode = 1;
// }
// );