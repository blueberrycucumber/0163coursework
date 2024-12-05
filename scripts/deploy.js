const { ethers } = require("hardhat");

async function main() {
    // 获取合约工厂
    const MedicalRecordManagement = await ethers.getContractFactory("MedicalRecordManagement");
    
    // 部署合约
    console.log("Deploying MedicalRecordManagement contract...");
    const contract = await MedicalRecordManagement.deploy();
    await contract.deployed();

    // 输出合约地址
    console.log("MedicalRecordManagement contract deployed to:", contract.address);
}

// 执行部署脚本
main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });
