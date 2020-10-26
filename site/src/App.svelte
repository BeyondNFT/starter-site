<script>
  import { setContext } from 'svelte';
  import { writable } from 'svelte/store';

  import { initProvider } from './utils';

  import List from './pages/List.svelte';
  import Create from './pages/Create.svelte';

  let mode = 'list';

  const app = writable({});
  setContext('app', app);

  initProvider(app);
</script>

<style>
  main {
    text-align: center;
    padding: 1em;
    max-width: 240px;
    margin: 0 auto;
  }

  h1 {
    color: #ff3e00;
    text-transform: uppercase;
    font-size: 4em;
    font-weight: 100;
    margin: 0 10px;
  }

  li {
    display: inline;
    margin: 0 10px;
    cursor: pointer;
  }

  .selected {
    text-decoration: underline;
  }

  @media (min-width: 640px) {
    main {
      max-width: none;
    }
  }
</style>

<header>
  <h1>InteractiveNFT - Starter</h1>
  <nav>
    <ul>
      <li class:selected={mode === 'list'} on:click={() => (mode = 'list')}>
        List
      </li>
      <li class:selected={mode === 'create'} on:click={() => (mode = 'create')}>
        Create
      </li>
    </ul>
  </nav>
</header>
<main>
  {#if $app.contract}
    {#if mode === 'list'}
      <List />
    {:else if mode === 'create'}
      <Create on:minted={() => (mode = 'list')} />
    {/if}
  {:else}Connecting to ethereum provider ...{/if}
</main>
