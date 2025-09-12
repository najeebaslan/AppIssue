enum AuthFailuresEnum {
  userNotSignIn(message: 'user not signIn'),
  noInternet(message: 'noInternet'),
  catchError(message: 'حدث خطأ ما , حاول مرة أخرى لاحقًا'),
  firebaseError(message: 'حدث خطأ ما , حاول مرة أخرى لاحقًا');

  final String? message;

  const AuthFailuresEnum({this.message});
}
