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

    struct Request {
        string description;
        address payable recipient;
        uint256 value;
        bool completed;
        uint256 voterCount;
        mapping(address => bool) voters;
    }

    mapping(uint256 => Request) public requests;
    uint256 public requestCount;

    constructor(uint256 _goal, uint256 _deadline) {
        goal = _goal;
        deadline = block.timestamp + _deadline;

        minimumContribution = 100; //in wei

        admin = msg.sender;
    }

    modifier authorizeAdmin() {
        require(msg.sender == admin, "UNAUTHORIZED");
        _;
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

    function getRefund() public {
        // verify if deadline has passed and campaign didnt reach its goal
        require(block.timestamp > deadline && raisedAmount < goal);
        require(contributors[msg.sender] > 0); // verify if the msg.sender is a contributor

        // refund the contributor
        address payable recipient = payable(msg.sender);
        uint256 value = contributors[msg.sender];
        recipient.transfer(value);

        // reset its contribution to this campaign to 0
        contributors[msg.sender] = 0;
    }

    function createRequest(
        string memory _description,
        address payable _recipient,
        uint256 _value
    ) public authorizeAdmin {
        Request storage newRequest = requests[requestCount];
        requestCount++;

        newRequest.description = _description;
        newRequest.recipient = _recipient;
        newRequest.value = _value;
        newRequest.completed = false;
        newRequest.voterCount = 0;
    }

    function voteRequest(uint256 _requestNumber) public {
        require(contributors[msg.sender] > 0, "NOT_CONTRIBUTOR_ERROR");
        Request storage request = requests[_requestNumber];

        require(request.voters[msg.sender] == false, "ALREADY_VOTED_ERROR");
        request.voters[msg.sender] = true;
        request.voterCount++;
    }

    function makePayment(uint256 _requestNumber) public authorizeAdmin {
        require(raisedAmount >= goal);
        Request storage request = requests[_requestNumber];
        require(request.completed == false, "COMPLETED_REQUEST_ERROR");

        // verify if 50% of the contributors voted
        require(request.voterCount > contributorsCount / 2);

        request.recipient.transfer(request.value);
        request.completed = true;
    }
}
