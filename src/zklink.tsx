import { SuiClient } from '@mysten/sui/client';
import { Ed25519Keypair } from '@mysten/sui/keypairs/ed25519';
import { generateNonce, generateRandomness, getExtendedEphemeralPublicKey, jwtToAddress } from '@mysten/sui/zklogin';



const FULLNODE_URLS = 'https://fullnode.devnet.sui.io:443';

const suiClient = new SuiClient({
  url: FULLNODE_URLS,
});  

const { epoch } = await suiClient.getLatestSuiSystemState();

const MaxEpochTime = Number(epoch) + 2;
const ephemeralKeypair = new Ed25519Keypair();
const random = generateRandomness();
const nonce = generateNonce(ephemeralKeypair.getPublicKey(), MaxEpochTime, random);

//const zkLoginUserAddress = jwtToAddress(jwt, userSalt);

const extendedEphemeralPublicKey = getExtendedEphemeralPublicKey(ephemeralKeypair.getPublicKey());


console.log(nonce);

console.log(extendedEphemeralPublicKey);

