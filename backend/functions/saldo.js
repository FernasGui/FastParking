const functions = require("firebase-functions");
const admin = require("firebase-admin");

// Verifica se o Firebase Admin já foi inicializado para evitar a reinicialização
if (admin.apps.length === 0) {
  admin.initializeApp();
}

const db = admin.firestore();

// Função para carregar saldo
exports.carregarSaldo = functions.https.onCall(async (data, context) => {
  const {userId, valor} = data;
  if (!userId || !valor) {
    throw new functions.https.HttpsError("invalid-argument", "Dados do usuário ou valor estão faltando.");
  }

  // Lógica para carregar o saldo
  return {message: "Saldo carregado com sucesso!"};
});
