const functions = require("firebase-functions");
const admin = require("firebase-admin");

if (admin.apps.length === 0) {
  admin.initializeApp();
}

exports.registerUser = functions.https.onCall(async (data) => {
  // Validação dos dados de entrada
  const {nome, email, password} = data;
  if (!email || !password || !nome) {
    throw new functions.https.HttpsError("invalid-argument", "Os campos de nome, e-mail e senha são obrigatórios.");
  }

  try {
    // Cria o usuário com e-mail e senha
    const userRecord = await admin.auth().createUser({
      email,
      password,
      displayName: nome,
    });

    // Salva informações adicionais no Firestore
    const userRef = admin.firestore().collection("Users").doc(userRecord.uid);
    await userRef.set({
      nome,
      email,
      saldo: 0, // Inicia o saldo como 0 ou outro valor padrão
      matriculas: [], // Inicia como uma lista vazia ou outro valor padrão
      createdAt: admin.firestore.FieldValue.serverTimestamp(),
    });

    return {status: "success", userId: userRecord.uid};
  } catch (error) {
    // Log do erro no Firebase console
    console.error("Erro ao registar usuário:", error);

    // Lança um erro mais genérico se for um erro de banco de dados ou de rede
    if (error.code.startsWith("auth/")) {
      // Erros de autenticação são específicos e podem ser repassados diretamente
      throw new functions.https.HttpsError("aborted", error.message);
    } else {
      // Para outros erros, repasse uma mensagem genérica ao usuário
      throw new functions.https.HttpsError("internal", "Erro ao criar usuário, por favor tente novamente mais tarde.");
    }
  }
});
