import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:todo_app_api/services/auth.dart';

class LoginView extends StatefulWidget {
  LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  TextEditingController emailController = TextEditingController();

  TextEditingController pwdController = TextEditingController();

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return LoadingOverlay(
      isLoading: isLoading,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Login"),
        ),
        body: Column(
          children: [
            TextField(
              controller: emailController,
            ),
            TextField(
              controller: pwdController,
            ),
            ElevatedButton(
                onPressed: () async {
                  try {
                    isLoading = true;
                    setState(() {});
                    await AuthServices()
                        .loginUser(
                            email: emailController.text,
                            password: pwdController.text)
                        .then((val) async {

                      if (val.user == null) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text("Email or password is invalid")));
                      } else {
                        await AuthServices()
                            .getUserProfile(token: val.token.toString())
                            .then((val) {
                          isLoading = false;
                          setState(() {});
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  content: Text(val.user!.name.toString()),
                                );
                              });
                        });
                      }
                    });
                  } catch (e) {
                    isLoading = false;
                    setState(() {});
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text(e.toString())));
                  }
                },
                child: Text("Login"))
          ],
        ),
      ),
    );
  }
}
