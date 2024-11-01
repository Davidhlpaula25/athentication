import 'package:authentication/home/home.view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

// Classe que representa um usuário local com email e senha.
class LocalUser {
  final String email;
  final String password;

  LocalUser(this.email, this.password);
}

/// Controlador responsável pela lógica de login.
class LoginController extends GetxController {
  /// Controladores de texto para os campos de email e senha.
  TextEditingController emailInput = TextEditingController();
  TextEditingController passwordInput = TextEditingController();

  /// Lista reativa de usuários locais.
  final RxList<LocalUser> userList = RxList<LocalUser>();
  /// Indicador reativo de carregamento.
  final RxBool loading = false.obs; 
  
  /// Instância do GoogleSignIn para login com Google.
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    clientId: '753775895492-rtu6ac7sgqidsuv65fo5cqulfhbh3i48.apps.googleusercontent.com',
  );

  String ?userName = "";
  String ?userEmail = "";
  String ?imageUrl = "";

  @override
  void onInit() {
    super.onInit();
    userList.add(LocalUser('fulano@gmail.com', 'fulano123'));
    userList.add(LocalUser('siclano@gmail.com', 'siclano123'));
    userList.add(LocalUser('david@gmail.com', 'david123'));
    userList.add(LocalUser('admin@gmail.com', 'admin123'));
  }

  /// Tenta realizar o login usando a lista local de usuários.
  void tryToLogin(BuildContext context) {
    for (var user in userList) {
      if (emailInput.text == user.email && passwordInput.text == user.password) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
        _showSuccessMessage(context, "Logado com sucesso!");
        return;
      }
    }
    _showError();
  }

  /// Tenta realizar o login usando o Google.
  Future<void> tryToLoginWithGoogle(BuildContext context) async {
    loading.value = true;  
    final result = await _googleLogin();
    loading.value = false;

    if (result) {
      Navigator.pushReplacement(
       
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
      
      _showSuccessMessage(context, "Logado com sucesso!");
    } else {
      _showError();
    }
  }

  Future<bool> _googleLogin() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser != null) {
        userName = googleUser.displayName;
        userEmail = googleUser.email;
        imageUrl = googleUser.photoUrl;
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print("Erro no login com Google: $e");
      return false;
    }
  }

  void _showError() {
     print('ERRO AO ENTRAR: Email ou senha incorretos');
  }

  /// Exibe uma mensagem de sucesso.
  void _showSuccessMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
      ),
    );
  }
}
