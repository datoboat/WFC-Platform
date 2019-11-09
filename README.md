# World-Family-Coin-Platform
Trustless and decentralised donation platform (https://www.worldfamilycoin.io/)

Decentralized platform linked to a Dao in which a WFC token holder has a power according to his portion of tokens. Initially an help request receives proof of identity by the organizations if the identity is confirmed according to the Dao vote the organization will be accepted. The help request filters also single fundraisings submitted by organizations previously approved. The fundraising have a softcap, an hardcap and a timeout, if hardcap is reached or softcap is reached after deadline, the fundraising will be approved and an escrow contract created. This contract will release funds for the organization  with value identical to a warranty previously submitted by organization. If according to Dao vote, proof of expenses submitted if correct next funds will be released, otherwise the warranty will be hold by the Dao and it will be send to a smart contract reserve that according to donors vote will redistribute to other fundraisings.
Support for multi-token payment method (Eth, Dai initially).


------------------------------------------------------------------------------------------------------------------------------------

TRUFFLE INSTALLATION:

Install Node.js (download at https://github.com/nodesource/distributions/blob/master/README.md for linux dist and https://nodejs.org/it/download/ for Windows or MacOs)

npm install -g truffle (install Truffle framework globally on your machine)

TRUFFLE DEPENDENCIES:

openzeppelin library:

npm install @openzeppelin/contracts

truffle module that integrate link with Infura:

npm install truffle-hdwallet-provider

js library for mocha test:

npm install truffle-assertions
