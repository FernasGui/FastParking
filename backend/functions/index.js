// const functions = require("firebase-functions");
const admin = require("firebase-admin");
const serviceAccount = require("./serviceAccount.json");

/**
 * Inicializa o Firebase Admin SDK se ainda não estiver inicializado.
 */
function setupAdminSDK() {
  if (admin.apps.length === 0) {
    admin.initializeApp({
      credential: admin.credential.cert(serviceAccount),
    });
  }
}

// Importar a função de registro de auth.js.
const {registerUser} = require("./auth");
const {loginUser} = require("./log");

// Exportar a função setupAdminSDK juntamente com as outras funções
exports.setupAdminSDK = setupAdminSDK;
exports.registerUser = registerUser;
exports.loginUser = loginUser;

// Agora, você pode chamar setupAdminSDK em qualquer lugar que importe este arquivo
