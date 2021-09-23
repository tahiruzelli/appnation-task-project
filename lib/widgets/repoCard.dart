// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class RepoCard extends StatelessWidget {
  void _launchURL(String _url) async => await canLaunch(_url)
      ? await launch(_url)
      : throw 'Could not launch $_url';
  var json;
  RepoCard(this.json);
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        _launchURL(json['html_url']);
      },
      leading: CircleAvatar(
        backgroundImage: NetworkImage(
          json['owner']['avatar_url'],
        ),
      ),
      title: Text(json['name']),
      trailing: json['language'] == null
          ? const Text('Dil: ?')
          : Text('Dil: ' + json['language']),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Forks: ' + json['forks'].toString()),
          Text('Açık Issues: ' + json['open_issues'].toString()),
        ],
      ),
    );
  }
}
