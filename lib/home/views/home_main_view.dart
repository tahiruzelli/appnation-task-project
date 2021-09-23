import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:github_search_repo/authenticaiton/bloc/authentication_bloc.dart';
import 'package:github_search_repo/authenticaiton/bloc/githubsearch_bloc.dart';
import 'package:github_search_repo/login/views/login_main_view.dart';
import 'package:github_search_repo/widgets/repoCard.dart';

class HomeMainView extends StatefulWidget {
  @override
  _HomeMainView createState() => _HomeMainView();
}

class _HomeMainView extends State<HomeMainView> {
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

  requestFunc() {
    // var tmp =
    //     await FetchData().getRepos(inputController.text, perPage.toString());
    // setState(() {
    //   response = tmp;
    // });
    BlocProvider.of<GithubsearchBloc>(context)
        .add(FetchGithubSearch(inputController.text, perPage.toString()));
  }

  perPageCounter() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          onPressed: () {
            perPage--;
            requestFunc();
          },
          icon: const Icon(Icons.remove),
        ),
        BlocBuilder<GithubsearchBloc, GithubsearchState>(
          builder: (context, state) {
            return Text(perPage.toString());
          },
        ),
        IconButton(
          onPressed: () {
            perPage++;
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
            child: BlocBuilder<GithubsearchBloc, GithubsearchState>(
              builder: (context, state) {
                if (state is GithubsearchLoadedState) {
                  return ListView.builder(
                    itemCount: state.tmp['items'].length,
                    itemBuilder: (context, index) {
                      return RepoCard(state.tmp['items'][index]);
                    },
                  );
                } else if (state is GithubsearchLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else {
                  return Center(
                    child: Container(),
                  );
                }
              },
            ),
          )
        ],
      ),
    );
  }
}
