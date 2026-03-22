// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title CubaLibre
 * @notice Escrow + milestone-based investment contract for Cuban businesses
 * @dev Funds held in escrow, released as milestones are verified by agent
 */
contract CubaLibre {
    
    // -----------------------------------------------------------------------
    // Data Structures
    // -----------------------------------------------------------------------
    
    enum InvestmentStatus {
        Created,
        Funded,
        InProgress,
        Completed,
        Cancelled,
        Disputed
    }
    
    struct Milestone {
        string description;
        uint256 amount;          // Amount allocated to this milestone
        bool completed;
        bool verified;
        uint256 verifiedAt;
    }
    
    struct Investment {
        address payable business;       // Cuban business receiving funds
        address payable investor;       // International investor
        address agent;                 // AI agent coordinating
        uint256 totalAmount;           // Total investment amount
        uint256 releasedAmount;        // Amount released so far
        InvestmentStatus status;
        Milestone[] milestones;
        uint256 createdAt;
        uint256 updatedAt;
    }
    
    // -----------------------------------------------------------------------
    // State
    // -----------------------------------------------------------------------
    
    uint256 public investmentCount;
    mapping(uint256 => Investment) public investments;
    
    // Agent registry (ERC-8004 agent addresses that are approved)
    mapping(address => bool) public approvedAgents;
    
    // Reputation tracking
    mapping(address => uint256) public investorReputation;
    mapping(address => uint256) public businessReputation;
    
    // -----------------------------------------------------------------------
    // Events
    // -----------------------------------------------------------------------
    
    event InvestmentCreated(
        uint256 indexed investmentId,
        address indexed business,
        address indexed investor,
        uint256 totalAmount
    );
    
    event InvestmentFunded(uint256 indexed investmentId, uint256 amount);
    event MilestoneCompleted(uint256 indexed investmentId, uint256 milestoneIndex);
    event MilestoneVerified(uint256 indexed investmentId, uint256 milestoneIndex);
    event FundsReleased(uint256 indexed investmentId, uint256 amount, address indexed to);
    event InvestmentCompleted(uint256 indexed investmentId);
    event InvestmentCancelled(uint256 indexed investmentId);
    event DisputeRaised(uint256 indexed investmentId, string reason);
    
    // -----------------------------------------------------------------------
    // Modifiers
    // -----------------------------------------------------------------------
    
    modifier onlyApprovedAgent() {
        require(approvedAgents[msg.sender], "Caller is not an approved agent");
        _;
    }
    
    modifier onlyInvestor(uint256 _investmentId) {
        require(
            investments[_investmentId].investor == msg.sender,
            "Only investor can call this"
        );
        _;
    }
    
    modifier onlyBusiness(uint256 _investmentId) {
        require(
            investments[_investmentId].business == msg.sender,
            "Only business can call this"
        );
        _;
    }
    
    modifier onlyActiveInvestment(uint256 _investmentId) {
        Investment storage inv = investments[_investmentId];
        require(
            inv.status == InvestmentStatus.Funded ||
            inv.status == InvestmentStatus.InProgress,
            "Investment is not active"
        );
        _;
    }
    
    // -----------------------------------------------------------------------
    // Constructor
    // -----------------------------------------------------------------------
    
    constructor() {
        // Contract deployer can add approved agents
    }
    
    // -----------------------------------------------------------------------
    // Core Functions
    // -----------------------------------------------------------------------
    
    /**
     * @notice Create a new investment with milestones
     * @dev Called by business or agent on their behalf
     */
    function createInvestment(
        address payable _business,
        address payable _investor,
        address _agent,
        uint256 _totalAmount,
        string[] memory _milestoneDescriptions,
        uint256[] memory _milestoneAmounts
    ) external returns (uint256) {
        require(_totalAmount > 0, "Amount must be > 0");
        require(
            _milestoneDescriptions.length == _milestoneAmounts.length,
            "Milestone data mismatch"
        );
        
        uint256 sum;
        for (uint256 i = 0; i < _milestoneAmounts.length; i++) {
            sum += _milestoneAmounts[i];
        }
        require(sum == _totalAmount, "Milestone amounts must equal total");
        
        investmentCount++;
        uint256 invId = investmentCount;
        
        Investment storage inv = investments[invId];
        inv.business = _business;
        inv.investor = _investor;
        inv.agent = _agent;
        inv.totalAmount = _totalAmount;
        inv.status = InvestmentStatus.Created;
        inv.createdAt = block.timestamp;
        inv.updatedAt = block.timestamp;
        
        // Create milestones
        for (uint256 i = 0; i < _milestoneDescriptions.length; i++) {
            inv.milestones.push(Milestone({
                description: _milestoneDescriptions[i],
                amount: _milestoneAmounts[i],
                completed: false,
                verified: false,
                verifiedAt: 0
            }));
        }
        
        emit InvestmentCreated(invId, _business, _investor, _totalAmount);
        return invId;
    }
    
    /**
     * @notice Fund an investment (investor sends stablecoins to contract)
     */
    function fundInvestment(uint256 _investmentId) external payable 
        onlyInvestor(_investmentId) 
    {
        Investment storage inv = investments[_investmentId];
        require(
            inv.status == InvestmentStatus.Created,
            "Investment not in fundable state"
        );
        require(
            msg.value >= inv.totalAmount,
            "Must fund full amount"
        );
        
        inv.status = InvestmentStatus.Funded;
        inv.updatedAt = block.timestamp;
        
        // Return excess if overfunded
        if (msg.value > inv.totalAmount) {
            payable(msg.sender).transfer(msg.value - inv.totalAmount);
        }
        
        emit InvestmentFunded(_investmentId, inv.totalAmount);
    }
    
    /**
     * @notice Mark a milestone as completed by the business
     */
    function completeMilestone(uint256 _investmentId, uint256 _milestoneIndex)
        external
        onlyBusiness(_investmentId)
        onlyActiveInvestment(_investmentId)
    {
        Investment storage inv = investments[_investmentId];
        require(
            _milestoneIndex < inv.milestones.length,
            "Milestone does not exist"
        );
        
        Milestone storage ms = inv.milestones[_milestoneIndex];
        require(!ms.completed, "Milestone already completed");
        
        ms.completed = true;
        inv.updatedAt = block.timestamp;
        
        emit MilestoneCompleted(_investmentId, _milestoneIndex);
    }
    
    /**
     * @notice Agent verifies milestone completion and triggers fund release
     */
    function verifyMilestoneAndRelease(
        uint256 _investmentId, 
        uint256 _milestoneIndex
    ) external 
        onlyApprovedAgent()
        onlyActiveInvestment(_investmentId) 
    {
        Investment storage inv = investments[_investmentId];
        require(
            _milestoneIndex < inv.milestones.length,
            "Milestone does not exist"
        );
        
        Milestone storage ms = inv.milestones[_milestoneIndex];
        require(ms.completed, "Milestone not completed by business");
        require(!ms.verified, "Milestone already verified");
        
        ms.verified = true;
        ms.verifiedAt = block.timestamp;
        
        inv.releasedAmount += ms.amount;
        inv.updatedAt = block.timestamp;
        
        // Transfer funds to business
        (bool success, ) = inv.business.call{value: ms.amount}("");
        require(success, "Transfer to business failed");
        
        // Update reputation
        businessReputation[inv.business] += 1;
        investorReputation[inv.investor] += 1;
        
        emit MilestoneVerified(_investmentId, _milestoneIndex);
        emit FundsReleased(_investmentId, ms.amount, inv.business);
        
        // Check if all milestones are verified
        _checkAndUpdateStatus(inv, _investmentId);
    }
    
    /**
     * @notice Agent can release funds manually for simpler flow
     */
    function agentRelease(
        uint256 _investmentId,
        uint256 _amount
    ) external 
        onlyApprovedAgent()
        onlyActiveInvestment(_investmentId)
    {
        Investment storage inv = investments[_investmentId];
        require(
            _amount <= (inv.totalAmount - inv.releasedAmount),
            "Amount exceeds remaining"
        );
        
        inv.releasedAmount += _amount;
        inv.updatedAt = block.timestamp;
        
        (bool success, ) = inv.business.call{value: _amount}("");
        require(success, "Transfer to business failed");
        
        emit FundsReleased(_investmentId, _amount, inv.business);
        
        _checkAndUpdateStatus(inv, _investmentId);
    }
    
    /**
     * @notice Investor can cancel and reclaim funds if agent misbehaves
     */
    function raiseDispute(uint256 _investmentId, string memory _reason) 
        external 
        onlyInvestor(_investmentId)
        onlyActiveInvestment(_investmentId)
    {
        Investment storage inv = investments[_investmentId];
        inv.status = InvestmentStatus.Disputed;
        inv.updatedAt = block.timestamp;
        
        emit DisputeRaised(_investmentId, _reason);
    }
    
    /**
     * @notice Resolve dispute — return funds to investor or release to business
     */
    function resolveDispute(uint256 _investmentId, bool _releaseToBusiness) 
        external 
        onlyInvestor(_investmentId)
    {
        Investment storage inv = investments[_investmentId];
        require(
            inv.status == InvestmentStatus.Disputed,
            "Investment not in dispute"
        );
        
        uint256 remaining = inv.totalAmount - inv.releasedAmount;
        
        if (_releaseToBusiness) {
            // Release remaining to business
            inv.releasedAmount = inv.totalAmount;
            (bool success, ) = inv.business.call{value: remaining}("");
            require(success, "Transfer failed");
            inv.status = InvestmentStatus.Completed;
        } else {
            // Return remaining to investor
            inv.status = InvestmentStatus.Cancelled;
            (bool success, ) = inv.investor.call{value: remaining}("");
            require(success, "Refund failed");
        }
        
        inv.updatedAt = block.timestamp;
        emit InvestmentCompleted(_investmentId);
    }
    
    /**
     * @notice Cancel unfunded investment
     */
    function cancelUnfunded(uint256 _investmentId) 
        external 
        onlyInvestor(_investmentId) 
    {
        Investment storage inv = investments[_investmentId];
        require(
            inv.status == InvestmentStatus.Created,
            "Can only cancel unfunded"
        );
        
        inv.status = InvestmentStatus.Cancelled;
        inv.updatedAt = block.timestamp;
        
        emit InvestmentCancelled(_investmentId);
    }
    
    // -----------------------------------------------------------------------
    // Admin / Agent Management
    // -----------------------------------------------------------------------
    
    function approveAgent(address _agent) external {
        // In production: DAO or multisig should control this
        approvedAgents[_agent] = true;
    }
    
    function revokeAgent(address _agent) external {
        approvedAgents[_agent] = false;
    }
    
    // -----------------------------------------------------------------------
    // View Functions
    // -----------------------------------------------------------------------
    
    function getInvestment(uint256 _investmentId) external view returns (Investment memory) {
        return investments[_investmentId];
    }
    
    function getMilestoneCount(uint256 _investmentId) external view returns (uint256) {
        return investments[_investmentId].milestones.length;
    }
    
    function getMilestone(uint256 _investmentId, uint256 _milestoneIndex) 
        external 
        view 
        returns (Milestone memory) 
    {
        return investments[_investmentId].milestones[_milestoneIndex];
    }
    
    function getInvestmentProgress(uint256 _investmentId) 
        external 
        view 
        returns (uint256 percentComplete) 
    {
        Investment storage inv = investments[_investmentId];
        if (inv.totalAmount == 0) return 0;
        return (inv.releasedAmount * 100) / inv.totalAmount;
    }
    
    function getRemainingBalance(uint256 _investmentId) external view returns (uint256) {
        Investment storage inv = investments[_investmentId];
        return inv.totalAmount - inv.releasedAmount;
    }
    
    // -----------------------------------------------------------------------
    // Internal
    // -----------------------------------------------------------------------
    
    function _checkAndUpdateStatus(Investment storage inv, uint256 invId) internal {
        // Check if all milestones are verified
        bool allVerified = true;
        for (uint256 i = 0; i < inv.milestones.length; i++) {
            if (!inv.milestones[i].verified) {
                allVerified = false;
                break;
            }
        }
        
        if (allVerified && inv.milestones.length > 0) {
            inv.status = InvestmentStatus.Completed;
            emit InvestmentCompleted(invId);
        } else if (inv.releasedAmount > 0) {
            inv.status = InvestmentStatus.InProgress;
        }
    }
    
    // -----------------------------------------------------------------------
    // Receive
    // -----------------------------------------------------------------------
    
    receive() external payable {}
}
