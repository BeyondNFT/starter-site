# BeyondNFT - Interactive NFTs Starter contracts

We are using Truffle here, if you don't have in installed, `npm install -g truffle`
You also might want to read [truffle's guide](https://www.trufflesuite.com/docs/truffle/overview) first.

Then go in the truffle directory, and install dependencies

```bash
cd truffle
npm install
```

## Disclaimer

**Be aware that the current contracts allows anyone to Mint NFTs. If you go public, you might want to add some Ownable stuff somewhere.**

This repo is only to have a quick and easy setup available to anyone for testing and curiosity purpose.

## Configure Truffle

First of all copy [.env.sample](./.env.sample) into `.env`
Then modify [truffle-config.js](truffle-config.js) for your network.

*Verify the port for development as ganache and ganache-cli don't have the same.*

## .env

Keys are pretty explicit

`RINKEBY_CONTRACT_OWNER_PKEY` used in [truffle-config.js] as the Rinkeby Wallet PKEY to deploy on the network
`RINKEBY_PROVIDER_URL` used in [truffle-config.js] as the Rinkeby Wallet Provider to deploy on the network
`MAINNET_CONTRACT_OWNER_PKEY` used in [truffle-config.js] as the Mainnet Wallet PKEY to deploy on the network
`MAINNET_PROVIDER_URL` used in [truffle-config.js] as the Mainnet Wallet Provider to deploy on the network
`ETHERSCAN_API_KEY` used to verify contracts on Etherscan.

## Compile and Deploy

Compile to be sure everything is fine.

```bash
truffle compile
```

Then if everything is fine, you can deploy to the network of your chosing

```bash
truffle deploy --network development
```

When you have deployed, you need to do two things:
- copy the contract address and use it in [the site .env file](../site/.env)
- copy the contract abi (located inside the big json truffle/build/contracts/InteractiveNFT.json) in [the site's src/conf/abi.json](../site/src/conf/abi.json). Note that this project comes with an ABI already valid in site and you should only modify it if you modify the contract and need to update the abi.

## Tests

@TODO but the contract is a very basic ERC721 contract. Shouldn't really need tests.

## Verify

This project use [truffle-plugin-verify](https://github.com/rkalis/truffle-plugin-verify) to verify contracts on Etherscan.io

example :

```
truffle run verify InteractiveNFT --network rinkeby
```