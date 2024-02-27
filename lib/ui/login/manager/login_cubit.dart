import 'package:cookpal/ui/login/manager/login_state.dart';
import 'package:cookpal/utils/app_connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());

  Future<void> login({
    required GlobalKey<FormState> formKey,
    required String email,
    required String password,
  }) async {
    if (!formKey.currentState!.validate()) {
      return;
    }
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      emit(LoginSuccess());
    } catch (error) {
      if (await AppConnectivity.checkConnection()) {
        emit(LoginFailure('Invalid Credentials!'));
      } else {
        emit(LoginFailure('Check Your internet!'));
      }
    }
  }

  void onObscureChange() => emit(ObscureChange());
}
