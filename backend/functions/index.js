const admin = require("firebase-admin");
const serviceAccount = require("./serviceAccount.json");
const functions = require("firebase-functions");
// Inicializa o Firebase Admin SDK se ainda não estiver inicializado.
if (admin.apps.length === 0) {
  admin.initializeApp({
    credential: admin.credential.cert(serviceAccount),
  });
}

/** apagar???
 * Inicializa o Firebase Admin SDK se ainda não estiver inicializado.
 */
// function setupAdminSDK() {
//   if (admin.apps.length === 0) {
//     admin.initializeApp({
//       credential: admin.credential.cert(serviceAccount),
//     });
//   }
// }

// Importa as funções definidas em outros arquivos
const {registerUser} = require("./auth");
const {loginUser} = require("./log");
const {adicionarMatricula, registrarAtualizarEstacionamento, carregarSaldo} = require("./mapeamento");

// Exporta as funções do Cloud Functions diretamente
exports.registerUser = functions.https.onCall(registerUser);
exports.loginUser = functions.https.onCall(loginUser);
exports.adicionarMatricula = functions.https.onCall(adicionarMatricula);
exports.registrarAtualizarEstacionamento = functions.https.onCall(registrarAtualizarEstacionamento);
exports.carregarSaldo = functions.https.onCall(carregarSaldo);
