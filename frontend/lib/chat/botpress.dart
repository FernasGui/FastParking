import 'package:fastparking/autenticacao/registerPage.dart';
import 'package:http/http.dart' as http;

class iniciarChat {

RegisterPages regist = new RegisterPages();

void iniciarChatComNome(String userName) async {
  
  var url = Uri.parse('https://your-botpress-server.com/api/start-session');
  var response = await http.post(url, body: {
    'userId': 'unique-user-id',
    'userName': userName,
  });

  if (response.statusCode == 200) {
    // Continue com o fluxo do chat
  } else {
    // Tratar erro
  }
}
}