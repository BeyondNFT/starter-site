export default `<style>
	body {
		text-align: center;
		font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto,
	Oxygen-Sans, Ubuntu, Cantarell, 'Helvetica Neue', sans-serif;
	}
</style>
<h1>Current Time</h1>
<strong>...</strong>
<script>
	const strong = document.querySelector('strong');
	function time() {
		const date = new Date();
		const time = date.getHours() + ":" + date.getMinutes() + ":" + date.getSeconds();
		strong.innerText = time;
	}
	setInterval(time, 1000);
	time();
</script>
`;
