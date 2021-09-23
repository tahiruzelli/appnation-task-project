import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:github_search_repo/authenticaiton/bloc/authentication_bloc.dart';
import 'package:github_search_repo/home/views/home_main_view.dart';
import 'package:github_search_repo/login/views/login_main_view.dart';

class Authentication extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: BlocConsumer<AuthenticationBloc, AuthenticationState>(
        listener: (context, state) {
          if (state is AuthenticationFailiure) {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (_) => LoginMainView()));
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
            Fluttertoast.showToast(
                msg: 'Hoşgeldin: ' + state.authenticationDetail.name,
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.CENTER,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 16.0);
            return HomeMainView();
          }
          return Container();
        },
      ),
    );
  }
}
