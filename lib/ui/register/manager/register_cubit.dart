import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cookpal/ui/register/manager/register_state.dart';
import 'package:cookpal/utils/app_connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit() : super(RegisterInitial());

  Future<void> register({
    required GlobalKey<FormState> formKey,
    required String email,
    required String password,
  }) async {
    if (!formKey.currentState!.validate()) {
      return;
    }
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      emit(RegisterSuccess());
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        emit(RegisterFailure('The password provided is too weak.'));
      } else if (e.code == 'email-already-in-use') {
        emit(RegisterFailure('The account already exists for that email.'));
      }
    } catch (e) {
      if (await AppConnectivity.checkConnection()) {
        emit(RegisterFailure(e.toString()));
      } else {
        emit(RegisterFailure('Check Your internet!'));
      }
    }
  }

  Future<void> saveUserData({
    required String userName,
    required String email,
  }) async {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    await FirebaseFirestore.instance.collection('users').doc(userId).set({
      'userId': userId,
      'userName': userName,
      'email': email,
      'favoriteRecipesId': [],
    });
  }

  void onObscureChange() => emit(ObscureChange());
}
