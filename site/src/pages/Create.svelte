<script>
  import { createEventDispatcher, getContext } from 'svelte';
  import defaultCode from '../conf/code.js';
  import Sandbox from '@beyondnft/sandbox';
  import { ipfs } from '../utils.js';

  const app = getContext('app');
  const dispatch = createEventDispatcher();

  let contract = $app.contract;
  let account = $app.account;

  let view;
  let data;
  let mintText;

  let name = '';
  let description = '';
  let attributes = {};
  let image = '';
  let dependencies = [];
  let code = defaultCode;
  let valid = false;

  // temp values
  let attrKey = '';
  let attrValue = '';
  let dependency = '';
  let dependencyType = 'script';

  $: view && code && data && renderSandbox();

  $: {
    let _data = {
      name,
      description,
      attributes,
      image,
    };

    if (code) {
      _data.interactive_nft = {
        code,
        dependencies,
      };

      data = _data;

      validate();
    }
  }

  function onFile(e) {
    if (this.files && this.files.length) {
      image = this.files[0];
    }
  }

  function validate() {
    let _valid = true;
    _valid = _valid && data.name.trim() !== '';
    _valid = _valid && data.description.trim() !== '';
    _valid = _valid && data.image;
    _valid = _valid && data.interactive_nft.code;
    valid = _valid;
  }

  let _sandbox;
  function renderSandbox() {
    if (_sandbox) {
      _sandbox.$destroy();
    }

    view.innerHTML = '';
    _sandbox = new Sandbox({
      target: view,
      props: {
        data,
      },
    });
  }

  function addDependency() {
    if (dependency.trim() !== '') {
      dependencies.push({
        url: dependency,
        type: dependencyType,
      });
      dependencies = dependencies;
      dependency = '';
      dependencyType = 'script';
    }
  }

  function removeDependency(dep) {
    dependencies.splice(dependencies.indexOf(dep), 1);
    dependencies = dependencies;
  }

  function addAttribute() {
    if (attrKey.trim() !== '' && attrValue.trim() !== '') {
      attributes[attrKey] = attrValue;
      attributes = attributes;
      attrKey = attrValue = '';
    }
  }

  function removeAttribute(key) {
    delete attributes[key];
    attributes = attributes;
  }

  async function mint() {
    if (
      !confirm(
        `We are ready to send data to IPFS and then to the contract ${$app.contract.address}.\nAre you sure?`
      )
    ) {
      return;
    }

    mintText = 'Uploading image to ipfs...';
    await ipfs.connect('https://ipfs.infura.io:5001');

    let file = await ipfs.add(image);
    const image_uri = `https://gateway.ipfs.io/ipfs/${file.path}`;
    data.image = image_uri;
    console.log('IMAGE URL', image_uri);

    mintText = 'Uploading code to ipfs...';
    file = await ipfs.add(code);
    const code_uri = `https://gateway.ipfs.io/ipfs/${file.path}`;
    console.log('CODE URL', code_uri);
    delete data.interactive_nft.code;
    data.interactive_nft.code_uri = code_uri;

    let nextId = await contract.methods.totalSupply().call();
    // here is where you'd set external_url in the json

    mintText = 'Uploading NFT metadata to ipfs...';
    file = await ipfs.add(JSON.stringify(data));
    const json_uri = `https://gateway.ipfs.io/ipfs/${file.path}`;

    mintText =
      'Adding NFT to blockchain - See MetaMask (or the like) for transaction';
    console.log('JSON URL', json_uri);

    await contract.methods.mint(nextId, account, json_uri).send();
    dispatch('minted');
  }
</script>

<style>
  section {
    display: flex;
    flex-direction: row;
    align-items: flex-start;
    padding: 10px 0;
    position: relative;
  }

  .render {
    position: sticky;
    top: 0;

    width: 50%;
    flex: 0 0 auto;
  }

  .form {
    width: 50%;
    border-right: 1px solid black;
    text-align: left;
  }

  form > div,
  form > label {
    margin-top: 20px;
  }

  h2 {
    margin: 20px 0;
    text-align: center;
    color: #ff3e00;
  }

  h2:first-child {
    margin-top: 0;
  }

  label strong {
    display: block;
  }

  ul {
    margin: 5px 0;
  }

  .remove {
    cursor: pointer;
    text-decoration: underline;
  }

  .row {
    display: flex;
    flex-direction: row;
  }

  .code {
    width: 100%;
    min-height: 250px;
  }

  .minting {
    padding: 20px;
    text-align: center;
  }
</style>

<section>
  <div class="form">
    <form on:submit|preventDefault>
      <h2>NFT properties</h2>
      <label>
        <strong>Name</strong>
        <input type="text" bind:value={name} />
      </label>
      <label>
        <strong>Description</strong>
        <textarea bind:value={description} />
      </label>
      <label>
        <strong>Image</strong>
        <input type="file" on:change={onFile} />
        <br /><em>This will be shown on preview and on platform where
          interactiveNFT are not supported</em>
      </label>
      <div>
        <strong>Attributes</strong>
        <ul>
          {#each Object.keys(attributes) as key}
            <li>
              <strong>{key}</strong>:
              {attributes[key]}
              (<em
                class="remove"
                on:click={() => removeAttribute(key)}>remove</em>)
            </li>
          {:else}
            <p>No attributes yet.</p>
          {/each}
        </ul>
        <div>
          <strong>New attribute</strong>
          <div class="row">
            <label> <strong>key</strong> <input bind:value={attrKey} /> </label>

            <label>
              <strong>value</strong>
              <input bind:value={attrValue} />
              <button on:click={addAttribute}>add</button>
            </label>
          </div>
        </div>
        <h2>InteractiveNFT specific</h2>
        <div>
          <strong>Dependencies</strong>
          <ul>
            {#each dependencies as dependency}
              <li>
                <a href={dependency.url} target="blank">({dependency.type})
                  {dependency.url}</a>
                (<em
                  class="remove"
                  on:click={() => removeDependency(dependency)}>remove</em>)
              </li>
            {:else}
              <p>
                No dependency yet.<br />
                <em>Script and Style that will be loaded before your code.<br />
                  You can add things like
                  <a
                    href="https://cdnjs.cloudflare.com/ajax/libs/p5.js/1.1.9/p5.min.js"
                    target="_blank">p5.js</a>
                  or d3.js or Three.js or ...</em>
              </p>
            {/each}
          </ul>
          <label>
            <strong>Dependency</strong>
            <input bind:value={dependency} />
            <select bind:value={dependencyType}>
              <option selected value="script">script</option>
              <option value="style">style</option>
            </select>
            <button on:click={addDependency}>add</button>
          </label>
        </div>
      </div>
      <label>
        <strong>Code! (needs to be valid html)</strong><textarea
          class="code"
          bind:value={code} /></label>

      <div class="minting">
        {#if !mintText}
          <button disabled={!valid} on:click={mint}>Mint this!</button>
        {:else}<strong>{mintText}</strong>{/if}
      </div>
    </form>
  </div>
  <div class="render">
    <h2>Preview</h2>
    <div bind:this={view} />
  </div>
</section>
