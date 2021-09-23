import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:github_search_repo/authenticaiton/data/repositories/authenticaiton_repository.dart';
import 'package:github_search_repo/authenticaiton/models/authentication_detail.dart';
part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final AuthenticationRepository _authenticationRepository;

  AuthenticationBloc({AuthenticationRepository authenticationRepository})
      : _authenticationRepository = authenticationRepository,
        super(AuthenticationInitial());

  StreamSubscription<AuthenticationDetail> authStreamSub;

  @override
  Future<void> close() {
    authStreamSub?.cancel();
    return super.close();
  }

  @override
  Stream<AuthenticationState> mapEventToState(
    AuthenticationEvent event,
  ) async* {
    if (event is AuthenticationStarted) {
      try {
        yield AuthenticationLoading();
        authStreamSub = _authenticationRepository
            .getAuthDetailStream()
            .listen((authDetail) {
          add(AuthenticationStateChanged(authenticationDetail: authDetail));
        });
      } catch (error) {
        print('Kimlik doğrulama yapilirken  hata oluştu : ${error.toString()}');
        yield AuthenticationFailiure(
            message: 'Kimlik doğrulama yapilirken  hata oluştu');
      }
    } else if (event is AuthenticationStateChanged) {
      if (event.authenticationDetail.isValid) {
        yield AuthenticationSuccess(
            authenticationDetail: event.authenticationDetail);
      } else {
        yield AuthenticationFailiure(message: 'Kullanici cikis yapti');
      }
    } else if (event is AuthenticationGoogleStarted) {
      try {
        yield AuthenticationLoading();
        AuthenticationDetail authenticationDetail =
            await _authenticationRepository.authenticateWithGoogle();

        if (authenticationDetail.isValid) {
          yield AuthenticationSuccess(
              authenticationDetail: authenticationDetail);
        } else {
          yield AuthenticationFailiure(message: 'Kullanici detayi yok');
        }
      } catch (error) {
        print('Google girisi yaparken hata olustu ${error.toString()}');
        yield AuthenticationFailiure(
          message: 'Google girisi yaparken hata olustu. Tekrar dene',
        );
      }
    } else if (event is AuthenticationExited) {
      try {
        yield AuthenticationLoading();
        await _authenticationRepository.unAuthenticate();
      } catch (error) {
        print('Cikis yaparken hata oldu : ${error.toString()}');
        yield AuthenticationFailiure(
            message: 'Cikis yaparken hata oldu tekrar dene');
      }
    }
  }
}
