import { ethers } from "hardhat";

async function main() {
    const [deployer] = await ethers.getSigners();
    console.log("Deploying DEX COntract with the account:", deployer.address);
    console.log("Account balance:", (await deployer.getBalance()).toString());

    const Dex = await ethers.getContractFactory("DEX");
    
    //pass in the provider address
    const dex = await Dex.deploy();
    


    await dex.deployed();
    console.log("DEX contract deployed to:", dex.address);

}

main().catch((error) => {

    console.error(error);
    process.exitCode = 1;
}
);
