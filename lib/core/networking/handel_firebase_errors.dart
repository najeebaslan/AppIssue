import 'package:firebase_auth/firebase_auth.dart';
import 'package:issue/core/helpers/helper_user.dart';
import 'package:issue/core/services/services_locator.dart';

class FirebaseErrorHandler {
  static String filterError(errorCode) {
    switch (errorCode is FirebaseAuthException ? errorCode.code : errorCode) {
      case "ERROR_EMAIL_ALREADY_IN_USE":
      case "account-exists-with-different-credential":
      case "email-already-in-use":
        return _adaptiveErrorMessages(
          ar: "البريد الإلكتروني مستخدم بالفعل. انتقل إلى صفحة تسجيل الدخول.",
          en: 'Email already in use',
        );

      case "ERROR_WRONG_PASSWORD":
      case "wrong-password":
        return _adaptiveErrorMessages(
          ar: 'كلمة المرور غير صالحة أو المستخدم ليس لديه كلمة مرور.',
          en: 'The password is invalid or the user does not have a password.',
        );
      case "invalid-credential":
        return _adaptiveErrorMessages(
          ar: 'خطأ في اسم المستخدم او كلمة المرور',
          en: 'Error email or password',
        );

      case "ERROR_USER_NOT_FOUND":
      case "user-not-found":
        return _adaptiveErrorMessages(
          ar: 'لم يتم العثور على مستخدم بهذا البريد الإلكتروني.',
          en: 'User not found',
        );

      case "INVALID_LOGIN_CREDENTIALS":
        return _adaptiveErrorMessages(
          ar: 'المستخدم غير موجود.',
          en: 'User not found',
        );
      case "ERROR_USER_DISABLED":
      case "user-disabled":
        return _adaptiveErrorMessages(
          ar: 'تم تعطيل المستخدم.',
          en: 'User disabled',
        );
      case "firebase_storage":
      case "image_upload_error":
        return _adaptiveErrorMessages(
          ar: 'هناك خطأ في تحميل الصورة، قد يكون ذلك بسبب ضعف الاتصال بالإنترنت.',
          en: 'Image upload error',
        );
      case "ERROR_TOO_MANY_REQUESTS":
      case "operation-not-allowed":
      case "ERROR_OPERATION_NOT_ALLOWED":
        return _adaptiveErrorMessages(
          ar: 'تم تجاوز الحد المسموح به لعدد طلبات تسجيل الدخول لهذا الحساب.',
          en: 'Operation not allowed',
        );

      case "network-request-failed":
        return _adaptiveErrorMessages(
          ar: 'هناك خطأ في الشبكة، يرجى التحقق من اتصالك بالإنترنت.',
          en: 'Network request failed',
        );
      case "ERROR_INVALID_EMAIL":
      case "invalid-email":
        return _adaptiveErrorMessages(
          ar: 'عنوان البريد الإلكتروني غير صالح.',
          en: 'Invalid email',
        );
      default:
        return errorCode.toString();
    }
  }

  static String _adaptiveErrorMessages({required String ar, required String en}) {
    bool isArabic = getIt.get<UserHelper>().getAppLanguage().startsWith('ar');
    return isArabic ? ar : en;
  }
}
