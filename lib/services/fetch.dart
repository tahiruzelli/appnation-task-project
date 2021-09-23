import 'package:github_search_repo/services/rest_connector.dart';
import 'package:github_search_repo/services/urls.dart';

class FetchData {
  getRepos(String query) async {
    var response = await RestConnector(
      domain + urlSearchRepo + '?&page=1&per_page=3&q=$query',
      requestType: "GET",
      data: '',
    ).getData();
    return response;
  }
}
