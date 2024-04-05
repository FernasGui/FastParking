const functions = require("firebase-functions");
const admin = require("firebase-admin");

// Verifica se o Firebase Admin já foi inicializado para evitar a reinicialização
if (admin.apps.length === 0) {
  admin.initializeApp();
}

const db = admin.firestore();

exports.registrarAtualizarEstacionamento = functions.https.onCall(async (data, context) => {
  // Verifica a autenticação do usuário
  if (!context.auth) {
    throw new functions.https.HttpsError("unauthenticated", "O usuário deve estar autenticado.");
  }

  const userId = context.auth.uid;
  const {zona, lugar} = data;

  if (!zona || !lugar) {
    throw new functions.https.HttpsError("invalid-argument", "Zona ou lugar estão faltando.");
  }

  // Busca por estacionamento ativo
  const estacionamentoAtivoQuery = await db.collection("Estacionamentos")
      .where( "userId", "==", userId )
      .where( "estado", "==", "ativo" )
      .get();

  if (estacionamentoAtivoQuery.empty) {
    // Registra um novo estacionamento
    await db.collection("Estacionamentos").add({
      userId,
      zona,
      lugar,
      estado: "ativo",
      timestamp: admin.firestore.FieldValue.serverTimestamp(),
    });
  } else {
    // Atualiza estacionamento ativo existente
    const docId = estacionamentoAtivoQuery.docs[0].id;
    await db.collection("Estacionamentos").doc(docId).update({
      zona,
      lugar,
      timestamp: admin.firestore.FieldValue.serverTimestamp(),
    });
  }

  return {message: "Estacionamento atualizado com sucesso."};
});
