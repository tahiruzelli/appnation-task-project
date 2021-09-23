import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:github_search_repo/authenticaiton/bloc/authentication_bloc.dart';
import 'package:github_search_repo/login/views/login_main_view.dart';
import 'package:github_search_repo/services/fetch.dart';
import 'package:github_search_repo/widgets/repoCard.dart';

class HomeMainView extends StatefulWidget {
  @override
  _HomeMainView createState() => _HomeMainView();
}

class _HomeMainView extends State<HomeMainView> {
  var response;
  TextEditingController inputController = TextEditingController();
  bool changed = false;
  int perPage = 3;
  onChangedButton() {
    changed = true;
    Timer(const Duration(seconds: 1), () async {
      if (changed) {
        requestFunc();
      }
      changed = false;
    });
  }

  requestFunc() async {
    var tmp =
        await FetchData().getRepos(inputController.text, perPage.toString());
    setState(() {
      response = tmp;
    });
  }

  perPageCounter() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          onPressed: () async {
            setState(() {
              perPage--;
            });
            requestFunc();
          },
          icon: const Icon(Icons.remove),
        ),
        Text(perPage.toString()),
        IconButton(
          onPressed: () async {
            setState(() {
              perPage++;
            });
            requestFunc();
          },
          icon: const Icon(Icons.add),
        ),
      ],
    );
  }

  appBar() {
    return AppBar(
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: perPageCounter(),
      appBar: appBar(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          //SearchInput(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: TextField(
              controller: inputController,
              onChanged: (value) {
                /*bu fonksiyon ile yazdiktan hemen sonra degil, bir harf yazdiktan 
                sonra 1 saniye bekliyor baska bir sey yazilmamissa istek atiyor.
                boylece performans kazaniyoruz.
                */
                onChangedButton();
              },
              decoration: InputDecoration(
                suffixIcon: IconButton(
                  onPressed: () async {
                    requestFunc();
                  },
                  icon: const Icon(Icons.search),
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              child: response == null
                  ? Column(
                      children: [
                        const Spacer(),
                        Center(
                          child: BlocConsumer<AuthenticationBloc,
                              AuthenticationState>(
                            listener: (context, state) {
                              if (state is AuthenticationFailiure) {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => LoginMainView()));
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
                                return Text(
                                    'Hoşgeldin: ${state.authenticationDetail.name}');
                              }
                              return Text(
                                  'Bilinmeyen Durum : ${state.runtimeType}');
                            },
                          ),
                        ),
                        const Spacer(),
                      ],
                    )
                  : response['total_count'] == 0
                      ? const Text('Sonuç yok')
                      : ListView.builder(
                          itemCount: response['items'].length,
                          itemBuilder: (context, index) {
                            return RepoCard(response['items'][index]);
                          },
                        ),
            ),
          )
        ],
      ),
    );
  }
}
