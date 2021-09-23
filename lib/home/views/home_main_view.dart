import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:github_search_repo/authenticaiton/bloc/authentication_bloc.dart';
import 'package:github_search_repo/login/views/login_main_view.dart';
import 'package:github_search_repo/services/fetch.dart';

class HomeMainView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Ana Sayfa'),
          actions: [
            IconButton(
              icon: const Icon(
                Icons.exit_to_app,
              ),
              onPressed: () => BlocProvider.of<AuthenticationBloc>(context).add(
                AuthenticationExited(),
              ),
            ),
          ],
        ),
        body: Center(
          child: BlocConsumer<AuthenticationBloc, AuthenticationState>(
            listener: (context, state) {
              if (state is AuthenticationFailiure) {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (_) => LoginMainView()));
              }
            },
            builder: (context, state) {
              if (state is AuthenticationInitial) {
                BlocProvider.of<AuthenticationBloc>(context)
                    .add(AuthenticationStarted());
                return const CircularProgressIndicator();
              } else if (state is AuthenticationLoading) {
                return const CircularProgressIndicator();
              } else if (state is AuthenticationSuccess) {
                return Text('Hoşgeldin :${state.authenticationDetail.name}');
              }
              return Text('Bilinmeyen Durum : ${state.runtimeType}');
            },
          ),
        ),
      ),
    );
  }
}
