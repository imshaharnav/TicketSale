const assert = require("assert");
const ganache = require("ganache-cli");
const Web3 = require("web3");
const web3 = new Web3(ganache.provider());
const {abi, bytecode} = require('../compile');

let accounts;
let TiecketSale;
beforeEach(async () => {
  // Get a list of all accounts
  accounts = await web3.eth.getAccounts();
  TiecketSale = await new web3.eth.Contract(abi)
    .deploy({
      data: bytecode,
      arguments: ["Hi there!"],
    })
    .send({ from: accounts[0],gasPrice: "550", gas: "1000000" });
});

describe("TicketSale", () => {
  it("deploys a contract", () => {
    assert.ok(inbox.options.address);
  });
  it("has a default message", async () => {
    const message = await TiecketSale.methods.message().call();
    assert.equal(message, "Hi there!");
  });
  
});