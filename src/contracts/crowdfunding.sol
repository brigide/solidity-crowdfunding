// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.5.0 <0.9.0;

contract CrowdFunding {
    mapping(address => uint256) public contributors;
    address public admin;
    uint256 public contributorsCount;

    uint256 public minimumContribution;
    uint256 public deadline; //timestamp
    uint256 public goal;

    uint256 public raisedAmount;

    constructor(uint256 _goal, uint256 _deadline) {
        goal = _goal;
        deadline = block.timestamp + _deadline;

        minimumContribution = 100; //in wei

        admin = msg.sender;
    }

    function contribute() public payable {
        require(block.timestamp <= deadline, "DEADLINE_ERROR");
        require(msg.value >= minimumContribution, "MINUMUM_CONTRIBUTION_ERROR");

        if (contributors[msg.sender] == 0) {
            contributorsCount++;
        }
        contributors[msg.sender] += msg.value;
        raisedAmount += msg.value;
    }

    receive() external payable {
        contribute();
    }

    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }
}
