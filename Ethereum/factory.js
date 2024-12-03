import web3 from './web3';
import CampaignFactory from './build/CampaignFactory.json';

const instance = new web3.eth.Contract(
    JSON.parse(CampaignFactory.interface),
    '0x7B032Fefd0F20ce6AD5cf709DBd7567d6bcf4d05'
);

export default instance;