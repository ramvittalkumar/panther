const Migrations = artifacts.require("Panther");

module.exports = function (deployer) {
  const _name = 'Panther';
  const _symbol = 'PNT'
  const _initBaseURI = 'ipfs://QmRX3wkqm1Jz1yxrUDth7A7CpQ8oPUsPuNtJXWo3Kh38MK/';
  const _initNotRevealedUri = 'ipfs://QmRX3wkqm1Jz1yxrUDth7A7CpQ8oPUsPuNtJXWo3Kh38MK/';
  deployer.deploy(Migrations, _name, _symbol, _initBaseURI, _initNotRevealedUri);
};
