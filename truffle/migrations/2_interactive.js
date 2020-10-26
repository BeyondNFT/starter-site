const InteractiveNFT = artifacts.require('InteractiveNFT');

module.exports = async function (deployer) {
  await deployer.deploy(InteractiveNFT);
  const erc721 = await InteractiveNFT.deployed();
};
