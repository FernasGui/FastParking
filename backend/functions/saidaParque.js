const functions = require("firebase-functions");
const admin = require("firebase-admin");
if (admin.apps.length === 0) {
    admin.initializeApp();
}

exports.registarSaidaEstacionamento = functions.https.onCall(async (data, context) => {
  // Verificar se o usuário está autenticado
  if (!context.auth) {
    throw new functions.https.HttpsError("unauthenticated", "O usuário deve estar autenticado para realizar a atualização.");
  }

  const colecao = admin.firestore().collection("EstacionamentoAtivo");
  const uid = data.uid; 
   //const uid = context.auth.uid;
    const parqueID = "P2";
    let valorEstacionamento = 0;
    let saldoNovo = 0;
 
  try {
    const snapshot = await colecao.where("UID", "==", uid).get();
  
    if (snapshot.empty) {
      console.log("Nenhum documento encontrado com o UID fornecido.");
      return {message: "Nenhum documento encontrado."};
    }

    // Supondo que haverá apenas um documento correspondente por UID
    const docEstacionamentoAtivo = snapshot.docs[0];
    const dadosEstacionamentoAtivo = docEstacionamentoAtivo.data();

    const agora = admin.firestore.Timestamp.now();
    const horaSaida = agora.toDate()
    
    const horaEntrada = dadosEstacionamentoAtivo.HoraEntrada.toDate();
    const horaSaidaDate = agora.toDate();

    const duracaoMs = horaSaidaDate - horaEntrada; //milisegundos
    const duracaoMinutos = Math.round(duracaoMs / 60000); //minutos

    const parqueRef = admin.firestore().collection("Parques").doc(parqueID);

    if (duracaoMinutos <= 15) {
        valorEstacionamento = 0.35; // $1,00 para até 15 minutos
      } else if (duracaoMinutos <= 60) {
        valorEstacionamento = 1;
    } else if (duracaoMinutos <= 120) {
        valorEstacionamento = 2; // $2,00 para até 60 minutos
      } 
      else if (duracaoMinutos <= 180) {
        valorEstacionamento = 2.8; // $2,00 para até 60 minutos
      }
      else if (duracaoMinutos <= 240) {
        valorEstacionamento = 3.5; // $2,00 para até 60 minutos
      }else {
        // Para mais de 240 minutos, adicione $2,00 para cada hora adicional ou fração
        valorEstacionamento = 3.5 + 2 * Math.floor((duracaoMinutos - 240) / 60);
      }

    const userRef = admin.firestore().collection("Users").doc(uid);
    const userDoc = await userRef.get();
    const userData = userDoc.data();
    const saldoAtual = userData.saldo;
    saldoNovo = saldoAtual - valorEstacionamento;

    await userRef.update({saldo: saldoNovo});
   // await snapshot.update({Duracao: duracaoMinutos, HoraSaida: horaSaida, Preco: valorEstacionamento});
   const colecaoEstacionamentoExpirado = admin.firestore().collection("EstacionamentoExpirado");

    const docExpirado = colecaoEstacionamentoExpirado.doc(docEstacionamentoAtivo.id);
    

    await admin.firestore().runTransaction(async (transaction) => {

      transaction.set(docExpirado, dadosEstacionamentoAtivo);
        
      transaction.update(parqueRef, { 
          lotacao: admin.firestore.FieldValue.increment(-1),
      });

      transaction.update(docExpirado, { 
        Duracao: duracaoMinutos, 
        HoraSaida: horaSaida, 
        Preco: valorEstacionamento,
    });
    
  
    // Remove o documento da 'EstacionamentoAtivo'.
    transaction.delete(docEstacionamentoAtivo.ref);
    
      });


    return {message: "Documento atualizado com sucesso."};

  } catch (error) {
    console.log("Erro ao atualizar documento:", error);
    throw new functions.https.HttpsError("unknown", "Erro ao atualizar documento com o UID fornecido.");
  }
});
