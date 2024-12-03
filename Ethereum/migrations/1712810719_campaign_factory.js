const CampaignFactory = artifacts.require("CampaignFactory");

module.exports = async function(deployer) {
 // Deploy the CampaignFactory contract
 await deployer.deploy(CampaignFactory);

 // Get the instance of the deployed CampaignFactory contract
 const campaignFactory = await CampaignFactory.deployed();

 // Call the createCampaign function to create a new Campaign contract
 // Replace '100' with the minimum contribution amount you want to set
 await campaignFactory.createCampaign(100);
};
