const functions = require("firebase-functions");
const admin = require("firebase-admin");

// Verifica se o Firebase Admin já foi inicializado para evitar a reinicialização
if (admin.apps.length === 0) {
  admin.initializeApp();
}

const db = admin.firestore();

// Função para adicionar matrícula
exports.adicionarMatricula = functions.https.onCall(async (data, context) => {
  // Verifica a autenticação do usuário
  if (!context.auth) {
    throw new functions.https.HttpsError("unauthenticated", "O usuário deve estar autenticado para adicionar matrículas.");
  }

  const {userId, dadosVeiculo} = data;
  if (!userId || !dadosVeiculo) {
    throw new functions.https.HttpsError("invalid-argument", "Dados do usuário ou veículo estão faltando.");
  }

  try {
    await db.collection("Matriculas").doc(userId).set({
      veiculos: admin.firestore.FieldValue.arrayUnion(dadosVeiculo),
    }, {merge: true});
    return {message: "Matrícula adicionada com sucesso!"};
  } catch (error) {
    console.error("Erro ao adicionar matrícula:", error);
    throw new functions.https.HttpsError("internal", "Erro ao adicionar matrícula.");
  }
});

// Função para registrar ou atualizar estacionamento
exports.registrarAtualizarEstacionamento = functions.https.onCall(async (data, context) => {
  const {userId, dadosEstacionamento} = data;
  if (!userId || !dadosEstacionamento) {
    throw new functions.https.HttpsError("invalid-argument", "Dados do usuário ou estacionamento estão faltando.");
  }

  // Lógica para registrar ou atualizar o estacionamento
  return {message: "Operação de estacionamento realizada com sucesso!"};
});

// Função para carregar saldo
exports.carregarSaldo = functions.https.onCall(async (data, context) => {
  const {userId, valor} = data;
  if (!userId || !valor) {
    throw new functions.https.HttpsError("invalid-argument", "Dados do usuário ou valor estão faltando.");
  }

  // Lógica para carregar o saldo
  return {message: "Saldo carregado com sucesso!"};
});

