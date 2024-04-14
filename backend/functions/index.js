// index.js

// const functions = require("firebase-functions");
const admin = require("firebase-admin");

if (admin.apps.length === 0) {
  admin.initializeApp();
}

// Importar a função de registro de auth.js.
const {registerUser} = require("./auth");
const {checkSaldoAndGenerateQR} = require("./qrCode");

// ...aqui você pode adicionar mais funções a serem exportadas se necessário.
exports.registerUser = registerUser;
exports.checkSaldoAndGenerateQR = checkSaldoAndGenerateQR;


