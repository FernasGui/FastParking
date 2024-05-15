const functions = require("firebase-functions");
const admin = require("firebase-admin");
if (admin.apps.length === 0) {
    admin.initializeApp();
}

exports.cashback = functions.https.onCall(async (data, context) => {
  // Verificar se o usuário está autenticado
  if (!context.auth) {
    throw new functions.https.HttpsError("unauthenticated", "O usuário deve estar autenticado para realizar a atualização.");
  }
  
  const uid = data.uid; 
  const userRef = admin.firestore().collection("Users").doc(uid);
  const estacionamentosRef = admin.firestore().collection("EstacionamentoExpirado")
      .where("UID", "==", uid)
      .orderBy("HoraEntrada", "desc")
      .limit(1);

  try {
    const estacionamentoSnapshot = await estacionamentosRef.get();
    if (estacionamentoSnapshot.empty) {
      throw new functions.https.HttpsError("not-found", "Não há estacionamentos registrados para este usuário.");
    }

    // Obter o valor do último estacionamento
    const ultimoEstacionamento = estacionamentoSnapshot.docs[0];
    const valorCashback = ultimoEstacionamento.data().Preco;

    // Obter dados do usuário para atualizar saldo
    const userData = (await userRef.get()).data();
    const saldoAtual = userData.saldo;
    const saldoNovo = saldoAtual + valorCashback;

    // Atualizar o saldo do usuário
    await userRef.update({saldo: saldoNovo});

    return {message: `Recebeste cashback de ${valorCashback} € !`};
  } catch (error) {
    console.log("Erro ao processar cashback:", error);
    throw new functions.https.HttpsError("unknown", "Erro ao processar cashback.", error);
  }
});
