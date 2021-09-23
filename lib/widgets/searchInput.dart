// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:github_search_repo/services/fetch.dart';

class SearchInput extends StatelessWidget {
  TextEditingController inputController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: inputController,
      decoration: InputDecoration(
        suffixIcon: IconButton(
          onPressed: () {
            FetchData().getRepos(inputController.text, '3');
          },
          icon: const Icon(Icons.search),
        ),
      ),
    );
  }
}
