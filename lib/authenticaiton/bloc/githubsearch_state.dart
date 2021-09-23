part of 'githubsearch_bloc.dart';

abstract class GithubsearchState extends Equatable {
  const GithubsearchState();

  @override
  List<Object> get props => [];
}

class GithubsearchInitial extends GithubsearchState {}

class GithubsearchLoadedState extends GithubsearchState {
  final tmp;
  GithubsearchLoadedState(this.tmp);
}

class GithubsearchLoading extends GithubsearchState {}

class GithubsearchError extends GithubsearchState {}
