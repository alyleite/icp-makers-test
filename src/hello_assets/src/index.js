import { Actor, HttpAgent } from '@dfinity/agent';
import { idlFactory as hello_idl, canisterId as hello_id } from 'dfx-generated/hello';

const agent = new HttpAgent();
const hello = Actor.createActor(hello_idl, { agent, canisterId: hello_id });

agent.fetchRootKey();

document.getElementById('form').addEventListener('submit', async (event) => {
  event.preventDefault();
  document.getElementById('greeting').innerText = '';
  const email = document.getElementById('email').value.toString();
  const registerId = await hello.create(email);
  console.log('RegisterId: ' + registerId);

  document.getElementById('greeting').innerText = 'Thanks for the registration ' + email;

  let op = await hello.read(registerId);
  let entry = op && op.length > 0 ? op[0] : null;
  if (entry && entry.email) {
    console.log('read: ' + entry.id + ' - ' + entry.email);
  }
  //document.getElementById('emails').value = entry;
});
