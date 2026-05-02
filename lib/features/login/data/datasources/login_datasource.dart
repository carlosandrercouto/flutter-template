import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

import '../../../../core/enums/login_error_type_enum.dart';
import '../../../../core/errors/errors_export.dart';
import '../../../../core/helpers/firebase_auth_helper.dart';

import '../../domain/entities/entities_export.dart';
import '../../domain/repositories/login_repository.dart';
import '../models/models_export.dart';

/// Datasource de login via Firebase Authentication.
///
/// Arquitetura do Datasource:
/// - Extends o repositório abstrato diretamente
/// - Recebe [FirebaseAuthHelper] como dependência injetável no construtor
/// - Mapeia [FirebaseAuthException.code] para [LoginErrorType]
/// - Usa Streams do Firebase apenas para autenticação; demais chamadas
///   à API ainda utilizam [ApiService] se necessário em outros datasources.
class LoginDatasource extends LoginRepository {
  final FirebaseAuthHelper _authHelper;

  LoginDatasource({FirebaseAuthHelper? authHelper})
    : _authHelper = authHelper ?? FirebaseAuthHelper.instance;

  @override
  Future<Either<Failure?, UserLoginData>> postRequestLogin({
    required String email,
    required String password,
  }) async {
    try {
      final UserCredential credential = await _authHelper
          .signInWithEmailAndPassword(
            email: email,
            password: password,
          );

      final idToken = await _authHelper.getIdToken();

      if (idToken == null) {
        log(
          'idToken is null after login',
          name: 'LoginDatasource: postRequestLogin',
        );
        return const Left(null);
      }

      return Right(
        UserLoginDataModel.fromFirebase(
          userCredential: credential,
          idToken: idToken,
        ),
      );
    } on FirebaseAuthException catch (error) {
      log(
        'FirebaseAuthException: ${error.code}',
        name: 'LoginDatasource: postRequestLogin',
      );

      return Right(
        UserLoginDataModel.fromFirebaseError(
          error: error.code,
        ),
      );
    } catch (error, stackTrace) {
      log(
        'Unexpected error: $error',
        name: 'LoginDatasource: postRequestLogin',
        stackTrace: stackTrace,
      );
      FirebaseCrashlytics.instance.recordError(error, stackTrace);
      return const Left(null);
    }
  }
}
