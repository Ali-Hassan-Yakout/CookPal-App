import 'package:cookpal/ui/reset_password/manager/reset_password_state.dart';
import 'package:cookpal/utils/app_connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ResetPasswordCubit extends Cubit<ResetPasswordState> {
  ResetPasswordCubit() : super(ResetPasswordInitial());

  Future<void> resetPassword({
    required GlobalKey<FormState> formKey,
    required String email,
  }) async {
    if (!formKey.currentState!.validate()) {
      return;
    }
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: email,
      );
      emit(ResetPasswordSuccess());
    } catch (error) {
      if (await AppConnectivity.checkConnection()) {
        emit(ResetPasswordFailure(error.toString()));
      } else {
        emit(ResetPasswordFailure('Check Your internet!'));
      }
    }
  }
}
