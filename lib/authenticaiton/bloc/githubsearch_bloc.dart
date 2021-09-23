import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:github_search_repo/services/fetch.dart';

part 'githubsearch_event.dart';
part 'githubsearch_state.dart';

class GithubsearchBloc extends Bloc<GithubsearchEvent, GithubsearchState> {
  GithubsearchBloc() : super(GithubsearchInitial());
  @override
  Stream<GithubsearchState> mapEventToState(
    GithubsearchEvent event,
  ) async* {
    if (event is FetchGithubSearch) {
      yield GithubsearchLoading();

      var response = await FetchData().getRepos(event.query, event.itemCount);
      await Future.delayed(const Duration(milliseconds: 500));
      yield GithubsearchLoadedState(response);
    }
  }
}
