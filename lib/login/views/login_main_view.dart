import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:github_search_repo/authenticaiton/bloc/authentication_bloc.dart';
import 'package:github_search_repo/home/views/home_main_view.dart';

class LoginMainView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Giris'),
      ),
      body: Builder(
        builder: (context) {
          return BlocConsumer<AuthenticationBloc, AuthenticationState>(
            listener: (context, state) {
              if (state is AuthenticationSuccess) {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => HomeMainView()));
              } else if (state is AuthenticationFailiure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                  ),
                );
              }
            },
            buildWhen: (current, next) {
              if (next is AuthenticationSuccess) {
                return false;
              }
              return true;
            },
            builder: (context, state) {
              if (state is AuthenticationInitial ||
                  state is AuthenticationFailiure) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      OutlinedButton(
                        onPressed: () =>
                            BlocProvider.of<AuthenticationBloc>(context).add(
                          AuthenticationGoogleStarted(),
                        ),
                        child: const Text('Google ile giris yap'),
                      ),
                    ],
                  ),
                );
              } else if (state is AuthenticationLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              return Center(
                  child: Text('Bilinmeyen durum : ${state.runtimeType}'));
            },
          );
        },
      ),
    );
  }
}
