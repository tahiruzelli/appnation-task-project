import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:github_search_repo/authenticaiton/bloc/githubsearch_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'app/observers/app_bloc_observer.dart';
import 'authenticaiton/bloc/authentication_bloc.dart';
import 'authenticaiton/data/providers/authentication_firebase_provider.dart';
import 'authenticaiton/data/providers/google_sign_in_provider.dart';
import 'authenticaiton/data/repositories/authenticaiton_repository.dart';
import 'home/views/home_main_view.dart';
import 'login/views/authentication.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Bloc.observer = AppBlocObserver();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthenticationBloc(
            authenticationRepository: AuthenticationRepository(
              authenticationFirebaseProvider: AuthenticationFirebaseProvider(
                firebaseAuth: FirebaseAuth.instance,
              ),
              googleSignInProvider: GoogleSignInProvider(
                googleSignIn: GoogleSignIn(),
              ),
            ),
          ),
        ),
        BlocProvider(create: (context) => GithubsearchBloc())
      ],
      //create: (context) =>
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'github-search-repo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: Authentication(),
      ),
    );
  }
}
