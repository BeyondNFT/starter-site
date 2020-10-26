<script>
  import { getContext } from 'svelte';
  import Token from '../components/Token.svelte';

  let tokens = [];
  let totalTokens = 0;
  let contract;

  // app is a store, reading its value using $app will
  // create a subscriber to the store changes
  const app = getContext('app');

  // so now when $app change,
  // if contract is now set in it
  // we can request things from Blockchain
  $: $app.contract && !contract && getTokens();

  async function getTokens() {
    contract = $app.contract;

    // feels like the best way to do it in the browser when there are only few items
    const events = await contract.getPastEvents('Transfer', {
      fromBlock: 0,
    });
    const address = contract.address;

    let _totalTokens = totalTokens;
    for (const event of events) {
      const values = event.returnValues;
      const _from = values.from;
      const _to = values.to;
      const tokenId = values.tokenId;

      if (_from === '0x0000000000000000000000000000000000000000') {
        const tokenURI = await contract.methods.tokenURI(tokenId).call();
        tokens.push({
          tokenURI,
          id: tokenId,
          creator: _to,
          contract: address,
        });
        _totalTokens++;
      }

      if (_to === '0x0000000000000000000000000000000000000000') {
        tokens.splice(
          tokens.findIndex((t) => t.id == tokenId),
          1
        );
        _totalTokens--;
      } else {
        const token = tokens.find((t) => t.id == tokenId);
        token.owner = _to;
      }
    }

    totalTokens = _totalTokens;
    tokens = tokens;
  }
</script>

<style>
  div {
    display: grid;
    grid-template-columns: repeat(auto-fill, 230px);
    grid-gap: 20px;
    padding: 10px 0;
    position: relative;
  }
</style>

<section>
  <strong>{totalTokens} Token(s)</strong>
  <div class="list">
    {#each tokens as token}
      <Token {token} />
    {/each}
  </div>
</section>
