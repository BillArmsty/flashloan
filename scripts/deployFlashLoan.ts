import { ethers } from "hardhat";

async function main() {
  const FlashLoan = await ethers.getContractFactory("FlashLoan");
  const flashLoan = await FlashLoan.deploy("0x0496275d34753A48320CA58103d5220d394FF77F");



  await flashLoan.deployed();
  console.log("Flash loan deployed to:", flashLoan.address);
 
}


main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
