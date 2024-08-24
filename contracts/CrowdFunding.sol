// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

contract CrowdFunding is Ownable, ReentrancyGuard {
    struct Campaign {
        string title;
        string description;
        address payable benefactor;
        uint goal;
        uint deadline;
        uint amountRaised;
        bool ended;
    }

    mapping (uint => Campaign) campaigns;

    uint campaignId;

    // Create events
    event CampaignCreated( uint indexed creator, string title, string description, uint goal, uint deadline );
    event DonateToCampaign(uint indexed campaignId, address indexed donator, uint amount);
    event CampaignEnded(uint indexed campaignId, uint amountRaised, address indexed benefactor);

    constructor(address initialOwner) Ownable(initialOwner) {}

    function createCampaign(string memory _title, string memory _description, address payable _benefactor, uint _goal, uint _deadline) external {
        require(_goal > 0, "Goal must be greater than zero");
        require(_benefactor != address(0), "Invalid benefactor address");

        campaignId++;
        uint deadline = block.timestamp + _deadline;

        campaigns[campaignId] = Campaign({
            title: _title,
            description: _description,
            benefactor: _benefactor,
            goal: _goal,
            deadline: deadline,
            amountRaised: 0,
            ended: false
        });       

        emit CampaignCreated(campaignId, _title, _description, _goal, _deadline);
    }

    function donateToCampaign(uint _campaignId) external payable {
        Campaign storage campaign = campaigns[_campaignId];

        require(block.timestamp <= campaign.deadline, "Campaign deadline has passed");
        require(!campaign.ended, "Campaign has already ended");

        campaign.amountRaised += msg.value;

        emit DonateToCampaign(_campaignId, msg.sender, msg.value);
    }

    function endCampaign(uint _campaignId) external {
        Campaign storage campaign = campaigns[_campaignId];

        require(block.timestamp >= campaign.deadline, "Campaign deadline has not yet passed");
        require(!campaign.ended, "Campaign has already ended");

        campaign.ended = true;
        campaign.benefactor.transfer(campaign.amountRaised);

        emit CampaignEnded(_campaignId, campaign.amountRaised, campaign.benefactor);
    }

    function withdrawLeftFunds() external onlyOwner nonReentrant {
        uint256 bal = address(this).balance;
        require(bal > 0, "No funds remaining");

        (bool sent, ) = msg.sender.call{value: bal}("");

        require(sent, "Failed to send funds");
    }

    // Fallback function to prevent accidental ETH transfer
    receive() external payable {
        revert("Use donateToCampaign to contribute to a campaign");
    }
}