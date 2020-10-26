<script>
  import { onMount } from 'svelte';
  import Sandbox from '@beyondnft/sandbox';

  export let token;

  let big = false;

  // load json
  // show image and title
  let image;
  let name;

  let data;
  let attributes;

  let view;

  $: view && renderSandbox();

  function renderSandbox() {
    new Sandbox({
      target: view,
      props: {
        data,
      },
    });
  }

  onMount(async () => {
    const res = await fetch(token.tokenURI);
    const json = await res.json();

    token.json = json;

    image = json.image;
    name = json.name;

    data = json;
    attributes = [];
    Object.keys(data.attributes).forEach((key) => {
      attributes.push({ key, value: data.attributes[key] });
    });
  });
</script>

<style>
  article {
    width: 230px;
    height: 300px;
    border: 1px solid black;
    border-radius: 4px;
  }

  article:hover {
    box-shadow: 0px 0px 6px 3px rgb(0, 0, 0, 0.4);
    transform: scale(1.02);
  }

  .preview {
    cursor: pointer;
    width: 100%;
    height: 100%;
    display: flex;
    flex-direction: column;
    overflow: hidden;
  }

  .preview div {
    flex: 1 1 0;
    width: 100%;
    overflow: hidden;
  }

  .preview img {
    width: 100%;
    height: auto;
  }

  .preview strong {
    flex: 0 0 auto;
    padding: 15px 10px;
    display: block;
  }

  article.big:hover {
    transform: none;
  }

  article.big .content {
    position: fixed;
    top: 50px;
    left: 50px;
    bottom: 50px;
    right: 50px;
    background-color: #fff;
    border: 1px solid black;
    border-radius: 4px;
    display: flex;
    flex-direction: column;
  }

  h2 {
    margin: 20px 0;
  }

  .close {
    position: absolute;
    top: 30px;
    right: 30px;
    cursor: pointer;
  }

  .output {
    display: flex;
    flex-direction: row;
    flex: 1 1 0;
  }

  .render {
    width: 50%;
    flex: 0 0 auto;
  }

  .data {
    padding: 0 20px;
    text-align: left;
    flex: 1;
  }
</style>

<article class:big>
  {#if !big}
    <div class="preview" on:click={() => (big = true)}>
      <div><img src={image} alt={name} /></div>
      <strong>{name}</strong>
    </div>
  {:else}
    <div class="content">
      <button class="close" on:click={() => (big = false)}>close</button>
      <h2>{name}</h2>
      <div class="output">
        <div class="render" bind:this={view} />
        <div class="data">
          <h3>Description</h3>
          <p>{token.json.description}</p>
          {#if attributes.length}
            <h3>Attributes</h3>
            <ul>
              {#each attributes as attribute}
                <li><strong>{attribute.key}</strong>: {attribute.value}</li>
              {/each}
            </ul>
          {/if}
        </div>
      </div>
    </div>
  {/if}
</article>
