// log.js

const functions = require("firebase-functions");
const admin = require("firebase-admin");

// Inicializa o app do Firebase apenas se ainda não tiver sido inicializado
if (admin.apps.length === 0) {
  admin.initializeApp();
}

exports.loginUser = functions.https.onCall(async (data, context) => {
  const {email, password} = data;

  // Verifica se o e-mail e a senha foram fornecidos
  if (!email || !password) {
    throw new functions.https.HttpsError("invalid-argument", "Os campos de e-mail e senha são obrigatórios para o login.");
  }

  try {
    // Realiza o login com o Firebase Authentication
    const userRecord = await admin.auth().getUserByEmail(email);

    // Aqui você verifica se o usuário tem assinatura premium
    // Isso assumirá que você tem um campo/atributo no registro do usuário ou em outro banco de dados que guarda essa informação.
    // Vou assumir que é um campo `premium` no documento do usuário no Firestore.
    const userDoc = await admin.firestore().collection("Users").doc(userRecord.uid).get();

    if (!userDoc.exists) {
      throw new functions.https.HttpsError("not-found", "Usuário não encontrado.");
    }

    const userData = userDoc.data();
    if (!userData.premium) {
      throw new functions.https.HttpsError("permission-denied", "Acesso restrito a usuários premium.");
    }

    const customToken = await admin.auth().createCustomToken(userRecord.uid);
    return {status: "success", customToken: customToken};
  } catch (error) {
    console.error("Erro ao logar utilizador:", error);
    if (error.code && error.code.startsWith("auth/")) {
      // Erros específicos de autenticação
      throw new functions.https.HttpsError("aborted", error.message);
    } else {
      // Outros erros
      throw new functions.https.HttpsError("internal", "Erro ao logar utilizador, por favor tente novamente mais tarde.");
    }
  }
});
