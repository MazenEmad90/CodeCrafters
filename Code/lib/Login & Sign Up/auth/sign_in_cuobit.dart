import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_life_organizer/Login & Sign Up/auth/sign_in_state.dart';

class SignUpCubit extends Cubit<SignUpState> {
  SignUpCubit() : super(SignUpInitial());

  Future<void> register(String name, String email, String password) async {
    emit(SignUpLoading());

    final prefs = await SharedPreferences.getInstance();
    List users = [];

    String? usersString = prefs.getString("users");
    if (usersString != null) {
      users = jsonDecode(usersString);//r
    }

    bool emailExists = users.any((user) => user["email"] == email);//r

    if (emailExists) {
      emit(SignUpError("Email already exists"));
      return;
    }

    Map<String, dynamic> newUser = {
      "name": name,
      "email": email,
      "password": password,
    };

    users.add(newUser);
    await prefs.setString("users", jsonEncode(users));

    emit(SignUpSuccess());
  }
}
