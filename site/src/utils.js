import detectProvider from '@metamask/detect-provider';
import abi from './conf/abi.json';

export async function initProvider(app) {
  // detect provider
  const provider = await detectProvider();

  if (!provider) {
    throw new Error(
      'Please install Metamask.io or any other wallet in the browser.'
    );
  }

  if (provider !== window.ethereum) {
    throw new Error('Provider problem.');
  }

  // legacy
  if ('function' === typeof provider.enable) {
    await provider.enable();
  }

  // create web3
  const web3 = new Web3(provider);

  const accounts = await web3.eth.getAccounts();
  if (!accounts.length) {
    throw new Error('Please connect an address use for minting.');
  }

  const account = accounts[0];

  // create contract instance
  const contract = new web3.eth.Contract(abi, process.env.CONTRACT_ADDRESS, {
    from: account,
  });

  app.set({
    web3,
    contract,
    provider,
    account,
  });
}

export const ipfs = {
  ipfsclient: null,
  async connect(config) {
    this.ipfsClient = window.IpfsHttpClient(config);
  },
  async add(content) {
    if (!this.ipfsClient) {
      console.warn('IPFS not connected');
      return;
    }

    try {
      const file = await this.ipfsClient.add(content);
      return file;
    } catch (e) {
      throw e;
    }
  },
  client() {
    return this.ipfsClient;
  },
};
