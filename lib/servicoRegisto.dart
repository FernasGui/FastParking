import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AutenticacaoServico {
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<bool> autenticacaoUser({
    required String nome,
    required String email,
    required String password,
  }) async {
    try {
      UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Adiciona o usuário recém-criado à coleção 'Users' no Firestore
      await _firestore.collection('Users').doc(userCredential.user!.uid).set({
        'nome': nome,
        'email': email,
        'saldo': 0.toDouble(),
        'matriculas': [] // Array vazio para matrículas, pode ser preenchido posteriormente
      });

      return true; // Registro bem-sucedido, retornando verdadeiro
    } on FirebaseAuthException catch (e) {
      print("Erro ao registrar: ${e.message}"); // Considerar remover em produção
      return false; // Falha no registro, retornando falso
    }
  }

  Future<String?> loginUser({
    required String email,
    required String password,
  }) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return null; // Login bem-sucedido
    } on FirebaseAuthException catch (e) {
      return e.message; // Retorna a mensagem de erro
    }
  }
}
