# Crowd Funding Project

This project is a smart contract that allows users to create and participate in crowdfunding campaigns. The contract enables users to create campaigns with a set goal and duration, accept donations, and automatically transfer the collected funds to the benefactor once the campaign ends.

### Prerequisites

Before you begin, ensure you have met the following requirements:

- Node.js: You should have Node.js installed. [Download Node.js]{https://node.org}
- Hardhat: Hardhat is a development environment for Ethereum. Install it using npm.

### Installation

Clone the repo and install dependencies
```shell
$ npm install
```

### Setup environment

```shell
SEPOLIA_URL=https://eth-sepolia.g.alchemy.com/v2/YOUR_SEPOLIA_PROJECT_ID
PRIVATE_KEY=your_private_key_here
ETHERSCAN_KEY=your_etherscan_key_here
```

### Usage

```shell
$ npx hardhat compile
$ npx hardhat test
$ npx hardhat ignition deploy ./ignition/modules/CrowdFunding.ts --network sepolia --verify
```
