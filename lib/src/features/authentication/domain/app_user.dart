typedef UserID = String;

/// Simple class representing the user UID and email.
class AppUser {
  const AppUser({
    required this.uid,
    this.email,
  });
  final UserID uid;
  final String? email;

  // * Here we override methods from [Object] directly rather than using
  // * [Equatable], since this class will be subclassed or implemented
  // * by other classes.
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AppUser && other.uid == uid && other.email == email;
  }

  @override
  int get hashCode => uid.hashCode ^ email.hashCode;

  @override
  String toString() => 'AppUser(uid: $uid, email: $email)';
}
