/**
 * Configura a conta de serviço para acesso aos recursos do Google Cloud Platform.
 * @return {Promise<Object>} Uma promessa que resolve com os dados da conta de serviço.
 */
async function setupServiceAccount() {
  const admin = require("firebase-admin");
  const {google} = require("googleapis");
  const {GoogleAuth} = require("google-auth-library");

  const serviceAccount = require("./serviceAccount.json");

  admin.initializeApp({
    credential: admin.credential.cert(serviceAccount),
  });

  const auth = new GoogleAuth({
    keyFilename: "./serviceAccount.json",
    scopes: ["https://www.googleapis.com/auth/cloud-platform"],
  });

  const authClient = await auth.getClient();
  const iam = google.iam({version: "v1", auth: authClient});

  const project = "intrepid-nova-406010";
  const serviceAccountEmail = "firebase-adminsdk-3btos@intrepid-nova-406010.iam.gserviceaccount.com";
  const response = await iam.projects.serviceAccounts.keys.list({
    name: `projects/${project}/serviceAccounts/${serviceAccountEmail}`,
  });

  // Retornar a resposta ou processar conforme necessário
  return response.data;
}

// Para chamar a função, você precisa utilizar uma função assíncrona ou o método then() para lidar com a Promise retornada.
setupServiceAccount()
    .then((data) => {
      console.log(data);
    })
    .catch((error) => {
      console.error(error);
    });
