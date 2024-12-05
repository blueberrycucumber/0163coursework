// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;


// 医疗记录管理合约
contract MedicalRecordManagement {
    // 数据结构：医疗记录
    struct MedicalRecord {
        string patientId;
        string dataHash; // 加密数据的哈希值
        address uploadedBy; // 上传者地址
        uint256 timestamp; // 上传时间
    }

    // 数据结构：奖励记录
    struct Reward {
        address recipient;
        uint256 amount;
        uint256 timestamp;
    }

    // 存储医疗记录
    mapping(string => MedicalRecord[]) public records; // 以患者ID为键存储记录
    // 存储用户的权限
    mapping(address => bool) public authorizedDoctors;
    // 奖励余额
    mapping(address => uint256) public rewards;

    // 合约管理员地址
    address public admin;

    // 构造函数
    constructor() {
        admin = msg.sender;
    }

    // 限制仅管理员调用的修饰符
    modifier onlyAdmin() {
        require(msg.sender == admin, "Only admin can perform this action");
        _;
    }

    // 限制仅授权医生调用的修饰符
    modifier onlyAuthorizedDoctor() {
        require(authorizedDoctors[msg.sender], "You are not an authorized doctor");
        _;
    }

    // 授权医生
    function authorizeDoctor(address doctor) external onlyAdmin {
        authorizedDoctors[doctor] = true;
    }

    // 移除医生授权
    function revokeDoctor(address doctor) external onlyAdmin {
        authorizedDoctors[doctor] = false;
    }

    // 上传医疗记录
    function uploadRecord(string memory patientId, string memory dataHash) external onlyAuthorizedDoctor {
        records[patientId].push(MedicalRecord({
            patientId: patientId,
            dataHash: dataHash,
            uploadedBy: msg.sender,
            timestamp: block.timestamp
        }));
        // 给上传者奖励
        rewards[msg.sender] += 10; // 每次上传奖励10代币
    }

    // 获取患者的医疗记录
    function getRecords(string memory patientId) external view returns (MedicalRecord[] memory) {
        return records[patientId];
    }

    // 提取奖励
    function withdrawRewards() external {
        uint256 amount = rewards[msg.sender];
        require(amount > 0, "No rewards available");
        rewards[msg.sender] = 0;

        // 奖励转账逻辑（此处简单示例，未涉及真实代币合约）
        payable(msg.sender).transfer(amount);
    }

    // 接收以太币
    receive() external payable {}
}
