const functions = require("firebase-functions");
const admin = require("firebase-admin");

// Verifica se o Firebase Admin já foi inicializado para evitar a reinicialização
if (admin.apps.length === 0) {
  admin.initializeApp();
}

const db = admin.firestore();

// precisamos de desenvolver marcadores dos parques e api maybe??


