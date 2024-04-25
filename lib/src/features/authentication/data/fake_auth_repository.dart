import 'package:ecommerce_app/src/exceptions/app_exception.dart';
import 'package:ecommerce_app/src/features/authentication/domain/app_user.dart';
import 'package:ecommerce_app/src/features/authentication/data/fake_app_user.dart';
import 'package:ecommerce_app/src/utils/delay.dart';
import 'package:ecommerce_app/src/utils/in_memory_store.dart';
import 'package:rive_bloc/rive_bloc.dart';
// Migrated:
// import 'package:riverpod_annotation/riverpod_annotation.dart';

class FakeAuthRepository {
  FakeAuthRepository({this.addDelay = true});
  final bool addDelay;
  final _authState = InMemoryStore<AppUser?>(null);

  Stream<AppUser?> authStateChanges() => _authState.stream;
  AppUser? get currentUser => _authState.value;

  // List to keep track of all user accounts
  final List<FakeAppUser> _users = [];

  Future<void> signInWithEmailAndPassword(String email, String password) async {
    await delay(addDelay);
    // check the given credentials agains each registered user
    for (final u in _users) {
      // matching email and password
      if (u.email == email && u.password == password) {
        _authState.value = u;
        return;
      }
      // same email, wrong password
      if (u.email == email && u.password != password) {
        throw WrongPasswordException();
      }
    }
    throw UserNotFoundException();
  }

  Future<void> createUserWithEmailAndPassword(
      String email, String password) async {
    await delay(addDelay);
    // check if the email is already in use
    for (final u in _users) {
      if (u.email == email) {
        throw EmailAlreadyInUseException();
      }
    }
    // minimum password length requirement
    if (password.length < 8) {
      throw WeakPasswordException();
    }
    // create new user
    _createNewUser(email, password);
  }

  Future<void> signOut() async {
    _authState.value = null;
  }

  void dispose() => _authState.close();

  void _createNewUser(String email, String password) {
    // create new user
    final user = FakeAppUser(
      uid: email.split('').reversed.join(),
      email: email,
      password: password,
    );
    // register it
    _users.add(user);
    // update the auth state
    _authState.value = user;
  }
}

// Migrated:
// @Riverpod(keepAlive: true)
// FakeAuthRepository authRepository(AuthRepositoryRef ref) {
//   return FakeAuthRepository(addDelay: true);
// }
final authRepositoryProvider = RiveBlocProvider.finalValue<FakeAuthRepository>(
  () => FakeAuthRepository(addDelay: true),
);

// Migrated:
// * Using keepAlive since other providers need it to be an
// * [AlwaysAliveProviderListenable]
// @Riverpod(keepAlive: true)
// Stream<AppUser?> authStateChanges(AuthStateChangesRef ref) {
//   final authRepository = ref.watch(authRepositoryProvider);
//   return authRepository.authStateChanges();
// }
final authStateChangesProvider =
    RiveBlocProvider.stream<StreamBloc<AppUser?>, AppUser?>(
        () => StreamBloc((ref, args) {
              final authRepository = ref.read(authRepositoryProvider);
              return authRepository.authStateChanges();
            }));
