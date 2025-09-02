import fetch from 'node-fetch';

const res = await fetch('https://fullnode.sui.io:443');
console.log(await res.text());
