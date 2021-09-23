part of 'githubsearch_bloc.dart';

abstract class GithubsearchEvent extends Equatable {
  const GithubsearchEvent();

  @override
  List<Object> get props => [];
}

class FetchGithubSearch extends GithubsearchEvent {
  String query;
  String itemCount;
  FetchGithubSearch(this.query, this.itemCount);
}
