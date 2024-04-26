const functions = require("firebase-functions");
const admin = require("firebase-admin");

if (admin.apps.length === 0) {
    admin.initializeApp();
}

exports.registarEntradaEstacionamento = functions.https.onCall(async (data, context) => {
    console.log("Dados recebidos:", data);
    // Verificar se o usuário está autenticado
    if (!context.auth) {
        throw new functions.https.HttpsError("unauthenticated", "O usuário deve estar autenticado para registar a entrada.");
    }



    const uid = data.uid; // UID do usuário passado na chamada da função
    const matricula = data.matricula;
    const parqueID = data.parqueID;
  
    if (!parqueID) {
        throw new functions.https.HttpsError("invalid-argument", "O ID do parque deve ser uma string não vazia.");
    }
    
    const parqueRef = admin.firestore().collection("Parques").doc(parqueID);
    const parqueSnapshot = await parqueRef.get(); // Obter o DocumentSnapshot
    
    if (!parqueSnapshot.exists) {
      throw new functions.https.HttpsError("not-found", "Parque não encontrado com o ID fornecido.");
    }
    

    const parqueData = parqueSnapshot.data();
    const nomeParque = parqueData.nome; // Assume que o campo nome está presente no documento do parque
    const lotacao = parqueData.lotacao;
    const capacidade = parqueData.capacidade;

    if (lotacao >= capacidade) {
        throw new functions.https.HttpsError("resource-exhausted", "O parque está lotado, aguarda.");
    }

    const agora = admin.firestore.Timestamp.now();
    const dataEntrada = agora.toDate().toISOString().split("T")[0];// Data atual no formato YYYY-MM-DD
    const horaEntrada = agora.toDate() // Hora atual no formato HH:MM:SS

    // Criar documento em 'EstacionamentoAtivo' com um ID automático
    const estacionamentoAtivoRef = admin.firestore().collection("EstacionamentoAtivo").doc();
    const idEstacionamento = estacionamentoAtivoRef.id; // Pega o ID gerado automaticamente

    // Iniciar uma transação para garantir atomicidade
    await admin.firestore().runTransaction(async (transaction) => {
        // Incrementa a lotação do parque
        transaction.update(parqueRef, { // <-- O erro pode estar ocorrendo aqui
            lotacao: admin.firestore.FieldValue.increment(1),
        });
    
        // Cria o documento de entrada no estacionamento
        transaction.set(estacionamentoAtivoRef, { 
            UID: uid,
            Data: dataEntrada,
            HoraEntrada: horaEntrada,
            Matricula: matricula,
            ID_Parque: parqueID,
            NomeParque: nomeParque,
            HoraSaida: 0,
            Preco: 0,
            Duracao: 0,
            ID_Estacionamento: idEstacionamento,
        });
    });
    return {message: "Entrada registada com sucesso.", idEstacionamento: idEstacionamento};
});
