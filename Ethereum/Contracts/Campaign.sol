pragma solidity ^0.8.4;

contract CampaignFactory{
    // ==== Fields ====
    address[] public deployedCampaigns;
    
    // ==== create a new contract ====
    function createCampaign(uint minimum) public {
        address newCampaign = address(new Campaign(minimum, msg.sender));
        deployedCampaigns.push(newCampaign);
    }
    
    // ==== returning all the address of the deployed contract
    function getDeployedCampaigns() public view returns (address[] memory){
        return deployedCampaigns;
    }
    
}

contract Campaign{
    // collection of key value pairs
    struct Request{
        string description;
        uint value;
        address payable recipient;
        bool complete;
        uint approvalCount;
        mapping(address => bool) approvals;
    }
    
    // === Fields ===
    Request[] public requests;
    address public manager;
    uint public minimumContribution;
    mapping(address => bool) public approvers;
    uint public approversCount;
    
    
    // === Methods ===
    
    // == Modifier ==
    modifier authorization(){
        require(msg.sender == manager, "Only manager can call this function.");
        _;
    }
    
    // == constructor ==
    //Setting the manager and minimum amount to contribute
    constructor(uint minimum, address creator) {
        manager = creator;
        minimumContribution = minimum;
    }
    
    //donate money to campaign and became an approver
    function contribute() public payable{
        require(msg.value > minimumContribution, "Minimum contribution not met.");
        
        if(!approvers[msg.sender]){
            approvers[msg.sender] = true;
            approversCount++;
        }
    }
    
    //creating a new request by the manager
    function createRequest(string memory description, uint value, address payable recipient)
        public authorization{
            Request storage newReq = requests.push();

        newReq.description = description;
        newReq.value = value;
        newReq.recipient = recipient;
        newReq.complete = false;
        newReq.approvalCount = 0;
        }
        
    //approving a particular request by the user
    function approveRequest(uint index) public {
        Request storage request = requests[index];
        
        require(approvers[msg.sender], "Not an approver.");
        require(!request.approvals[msg.sender], "Already approved.");
        require(!request.complete, "Request already completed.");
        
        request.approvals[msg.sender] = true;
        request.approvalCount++;
    }
    
    //final approval of request by the manager and sending the amount
    function finalizeRequest(uint index) public authorization{
        Request storage request = requests[index];
        
        require(request.approvalCount > (approversCount/2), "Not enough approvals.");
        require(!request.complete, "Request already completed.");
        
        request.recipient.transfer(request.value);
        request.complete = true;
        
    }

    // function to retrieve Campaign balance, minimumContribution , no of requests , no of Contributors and manager address
    function getSummary() public view returns (
        uint, uint, uint, uint, address
        ) {
        return (
            minimumContribution,
            address(this).balance,
            requests.length,
            approversCount,
            manager
            ); 
    }

    // returning no of requests
    function getRequestsCount() public view returns (uint) {
        return  requests.length;
    }
    
}