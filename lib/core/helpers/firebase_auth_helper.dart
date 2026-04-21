import 'dart:developer';

import 'package:flutter/foundation.dart' show visibleForTesting;

import 'package:firebase_auth/firebase_auth.dart';

/// Helper que encapsula [FirebaseAuth.instance].
///
/// Segue o padrão singleton do projeto (ex: [SessionHelper]).
/// Não captura exceções internamente — o chamador é responsável por tratar
/// [FirebaseAuthException] e outros erros.
///
/// Exemplo de uso no DataSource:
/// ```dart
/// final credential = await FirebaseAuthHelper.instance.signInWithEmailAndPassword(
///   email: email,
///   password: password,
/// );
/// ```
class FirebaseAuthHelper {
  FirebaseAuthHelper._();

  /// Construtor protegido para uso exclusivo em testes (subclasses fake).
  @visibleForTesting
  FirebaseAuthHelper.forTesting();

  static final FirebaseAuthHelper _instance = FirebaseAuthHelper._();

  /// Instância singleton do [FirebaseAuthHelper].
  static FirebaseAuthHelper get instance => _instance;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Usuário autenticado no momento, ou null se não houver sessão ativa.
  User? get currentUser => _auth.currentUser;

  /// Realiza login com e-mail e senha.
  ///
  /// Lança [FirebaseAuthException] em caso de falha.
  Future<UserCredential> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    log('signInWithEmailAndPassword: $email', name: '🔐 FirebaseAuthHelper');
    return _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  /// Realiza o logout do usuário atual.
  Future<void> signOut() async {
    log('signOut', name: '🔐 FirebaseAuthHelper');
    await _auth.signOut();
  }

  /// Retorna o ID Token JWT do usuário atual, ou null se não houver sessão.
  ///
  /// Passa [forceRefresh: true] para garantir que o token não está expirado.
  Future<String?> getIdToken({bool forceRefresh = false}) async {
    return _auth.currentUser?.getIdToken(forceRefresh);
  }
}
