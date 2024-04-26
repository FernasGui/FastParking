const functions = require("firebase-functions");
const admin = require("firebase-admin");
if (admin.apps.length === 0) {
    admin.initializeApp();
  }

  exports.checkSaldoAndGenerateQR = functions.https.onCall(async (data, context) => {
  // Verificar se o usuário está autenticado
  if (!context.auth) {
    throw new functions.https.HttpsError("unauthenticated", "O usuário deve estar autenticado para gerar o QR Codqe.");
  }

  const uid = context.auth.uid;
  const matricula = data.matricula;
  const parqueID = data.parqueID;
   // Acessa a matrícula passada pelo cliente

  const doc = await admin.firestore().doc(`Users/${uid}`).get();
    const userData = doc.data();
    if (userData.saldo > 0) {
        // Lógica para gerar os dados do QR Code incluindo a matrícula
        const qrData = {
            "uid": uid,
            "data": new Date().toISOString().slice(0, 10), // Data atual no formato YYYY-MM-DD
            "hora": new Date().toISOString().slice(11, 19),
            "matricula": matricula,
            "parqueID": parqueID, // Inclui a matrícula nos dados do QR Code
        };
        return {qrData};
    } else {
        throw new functions.https.HttpsError("failed-precondition", "Carrega o teu saldo para entares no parque. Em caso de dúvidas contacta-nos ou consulta o tutorial da aplicação em Informações");
    }
});