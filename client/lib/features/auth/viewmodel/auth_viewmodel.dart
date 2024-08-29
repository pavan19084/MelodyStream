// ignore_for_file: avoid_print

import 'package:client/core/provider/current_user_notifier.dart';
import 'package:client/core/models/user_model.dart';
import 'package:client/features/auth/repoositories/auth_local_repository.dart';
import 'package:client/features/auth/repoositories/auth_remote_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_viewmodel.g.dart';

@riverpod
class AuthViewmodel extends _$AuthViewmodel {
  late AuthLocalRepository _authLocalRepository;
  late AuthRemoteRepository _authRemoteRepository;
  late CurrentUserNotifier _currentUserNotifier;

  @override
  AsyncValue<UserModel>? build() {
    _authRemoteRepository = ref.watch(authRemoteRepositoryProvider);
    _authLocalRepository = ref.watch(authLocalRepositoryProvider);
    _currentUserNotifier = ref.watch(currentUserNotifierProvider.notifier);
    return null;
  }

  Future<void> initSharedPrefrences() async {
    await _authLocalRepository.init();
  }

  Future<void> signupUser({
    required String name,
    required String email,
    required String password,
  }) async {
    state = const AsyncValue.loading();
    final res = await _authRemoteRepository.signup(
      name: name,
      email: email,
      password: password,
    );
    final message = res.fold(
      (l) => state = AsyncValue.error(
        l.message,
        StackTrace.current,
      ), // Error message
      (r) => state = AsyncValue.data(r), // Success message
    );
    print(message);
  }

  Future<void> loginUser({
    required String email,
    required String password,
  }) async {
    state = const AsyncValue.loading();
    final res = await _authRemoteRepository.login(
      email: email,
      password: password,
    );
    res.fold(
      (l) => state = AsyncValue.error(
        l.message,
        StackTrace.current,
      ), // Error message
      (r) => _loginSuccess(r), // Success message
    );
  }

  AsyncValue<UserModel> _loginSuccess(UserModel user) {
    _authLocalRepository.setToken(user.token);
    _currentUserNotifier.addUser(user);
    state = AsyncValue.data(user);
    return state!;
  }

  Future<UserModel?> getData() async {
    state = const AsyncValue.loading();
    final token = _authLocalRepository.getToken();
    if (token != null) {
      final res = await _authRemoteRepository.getCurrentUserData(token);
      final val = res.fold(
        (l) => state = AsyncValue.error(
          l.message,
          StackTrace.current,
        ),
        (r) => _getDataSuccess(r), // Success message
      );
      return val.value;
    }
    return null;
  }

  AsyncValue<UserModel> _getDataSuccess(UserModel user) {
    _currentUserNotifier.addUser(user);
    return state = AsyncValue.data(user);
  }
}
