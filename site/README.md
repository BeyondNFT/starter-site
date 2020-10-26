# BeyondNFT - Interactive NFTs Starter site

We are using Svelte here. It is very easy to use and understand if you ever worked with vanilla js, Vue or React.

First go in the directory and install dependencies

```bash
cd site
npm install
```

Then you can type of of theos two commands

`npm run dev`
Starts the site in `dev` mode (which means auto-reload when modifying any imported file). It will echo a local address at which you can see the site

`npm run build`
to build the website, if you want to publish it for example

## .env

copy [.env.sample] into `.env`

Edit it to set the right `CONTRACT_ADDRESS` for the network your are on

## Overview

The website is composed of two pages. List and Create.

All request to the blockchain are done through MetaMask (or any other web wallet). Be sure to be connected on the right Network (Mainnet, Rinkeby, Local Ganache...).

### List

List will list all the currently created NFT in your contract.

### Create

Create will let you create an InteractiveNFT through a form.

You'll be able to set usual NFT properties like name, description, attributes and image (to display in small/cards, and also on places where InteractiveNFTs are not supported).

Then you'll have access to a big textarea where you'll be able to past the HTML code (can contain style and script tags) of your NFT.

You'll be able to add a list of dependencies (script, style - for example p5.js or d3) to load.

If the code is valid, there will be a preview of the NFT on the right side of the screen.

Rhen on submitting:
- image will be hosted on IPFS
- code will be hosted on IPFS
- Metamask will ask to do the transaction to store the value in the contract

You can then see the NFT in the List