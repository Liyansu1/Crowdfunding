import Web3 from 'web3';

let web3;

async function initializeWeb3() {
    if (typeof window !== 'undefined' && typeof window.ethereum !== 'undefined') {
        // We are in the browser and MetaMask is installed
        web3 = new Web3(window.ethereum);
        try {
            // Request account access if needed
            await window.ethereum.enable();
        } catch (error) {
            // User denied account access...
            console.error("User denied account access");
        }
    } else {
        // We are on the server *OR* MetaMask is not running
        // Creating our own provider
        const provider = new Web3.providers.HttpProvider(
            'https://sepolia.infura.io/v3/15ab3ed7faa3490e9afd244b7d332e36'
        );

        web3 = new Web3(provider);
    }
}

// Call the function to initialize Web3
initializeWeb3();

export default web3;
