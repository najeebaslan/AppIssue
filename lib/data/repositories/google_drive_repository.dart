import 'package:easy_localization/easy_localization.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/drive/v2.dart' as api_v2;
import 'package:googleapis/drive/v3.dart' as api_v3;
import 'package:http/http.dart' as http;
import 'package:issue/core/networking/type_response.dart';

import '../../core/constants/default_settings.dart';
import '../../core/networking/network_info.dart';

GoogleSignIn _googleSignIn = GoogleSignIn(
  scopes: <String>[
    'email',
    'https://www.googleapis.com/auth/documents.readonly',
    'https://www.googleapis.com/auth/drive.readonly'
  ],
);

abstract class BaseGoogleDriveRepository {
  /// Attempts to sign in a previously authenticated user without interaction.
  Future<ResponseResult<String, GoogleSignInAccount?>> googleSignInSilently();

  /// In this method just get the google drive api for i can manage the all file
  /// by using reference form callback for this method and i can delete file or remove it
  /// like [referenceGetDriveApi.delete OR  referenceGetDriveApi.download]
  /// NOTE=======> just you can use reference for this method only for [DOWNLOAD]OR[DELETE]
  Future<ResponseResult<String, api_v3.DriveApi?>> getDriveApi();

  Future<ResponseResult<String, bool>> googleSignOut();

  Future<ResponseResult<String, List<api_v2.File>>> getAllBackups({
    required GoogleSignInAccount currentUser,
  });
  Future<ResponseResult<String, Stream<List<int>>>> downloadBackup(
    api_v3.DriveApi driveApiV3,
    String backupID,
  );
  Future<ResponseResult<String, bool>> deleteBackup(
    api_v3.DriveApi driveApiV3,
    String backupID,
  );
  Future<ResponseResult<String, bool>> uploadBackup({
    required api_v3.DriveApi driveApiV3,
    required String backup,
  });
}

class GoogleDriveRepositoryImpl extends BaseGoogleDriveRepository {
  final NetworkInfo networkInfo;
  GoogleDriveRepositoryImpl({required this.networkInfo});

  @override
  Future<ResponseResult<String, GoogleSignInAccount?>> googleSignInSilently() async {
    try {
      if (!await networkInfo.isConnected) {
        return Failure('noInternet'.tr());
      }
      GoogleSignInAccount? signIn = await _googleSignIn.signInSilently();
      signIn ??= await _googleSignIn.signIn();
      if (signIn == null) return Failure('UnKnow Error');
      return Success(signIn);
    } catch (e) {
      return Failure(e.toString());
    }
  }

  @override
  Future<ResponseResult<String, bool>> googleSignOut() async {
    try {
      if (!await networkInfo.isConnected) {
        return Failure('noInternet'.tr());
      }
      await _googleSignIn.disconnect();
      return Success(true);
    } catch (e) {
      return Failure(e.toString());
    }
  }

  @override
  Future<ResponseResult<String, api_v3.DriveApi?>> getDriveApi() async {
    try {
      if (!await networkInfo.isConnected) {
        return Failure('noInternet'.tr());
      }
      // Google Drive Sign In By Specific configuration
      final googleSignIn = GoogleSignIn.standard(
        scopes: [
          api_v3.DriveApi.driveAppdataScope,
          api_v3.DriveApi.driveFileScope,
        ],
      );
      GoogleSignInAccount? signIn = await googleSignIn.signInSilently();
      signIn ??= await googleSignIn.signIn();
      if (signIn == null) return Failure('error sign-in with google');
      final headers = await googleSignIn.currentUser!.authHeaders;
      final client = GoogleAuthClient(headers);
      final driveApi = api_v3.DriveApi(client);

      return Success(driveApi);
    } catch (e) {
      return Failure(e.toString());
    }
  }

  @override
  Future<ResponseResult<String, Stream<List<int>>>> downloadBackup(
    api_v3.DriveApi driveApiV3,
    String backupID,
  ) async {
    try {
      if (!await networkInfo.isConnected) {
        return Failure('noInternet'.tr());
      }
      api_v3.Media? response = await driveApiV3.files.get(
        backupID,
        downloadOptions: api_v3.DownloadOptions.fullMedia,
      ) as api_v3.Media?;

      if (response == null) return Failure('response is null');
      return Success(response.stream);
    } catch (e) {
      return Failure(e.toString());
    }
  }

  @override
  Future<ResponseResult<String, bool>> deleteBackup(
      api_v3.DriveApi driveApiV3, String backupID) async {
    try {
      if (!await networkInfo.isConnected) {
        return Failure('noInternet'.tr());
      }
      await driveApiV3.files.delete(backupID);
      return Success(true);
    } catch (e) {
      return Failure(e.toString());
    }
  }

  @override
  Future<ResponseResult<String, bool>> uploadBackup(
      {required api_v3.DriveApi driveApiV3, required String backup}) async {
    try {
      if (!await networkInfo.isConnected) {
        return Failure('noInternet'.tr());
      }

      final Stream<List<int>> mediaStream =
          Future.value(backup.codeUnits).asStream().asBroadcastStream();
      var media = api_v3.Media(mediaStream, backup.length);
      var driveFile = api_v3.File();
      final timestamp = DateTime.now().toIso8601String();
      driveFile.name = "Issus_App-$timestamp.txt";
      // Please don't delete [drive File.modified Time]
      // it's provide the file  upload date backup
      driveFile.modifiedTime = DateTime.now().toUtc();
      driveFile.parents = [DefaultSettings.nameFolderBackupsInGoogleDrive];

      final response = await driveApiV3.files
          .create(driveFile, uploadMedia: media)
          .timeout(const Duration(minutes: 5), onTimeout: () => throw 'noInternet'.tr());
      if (response.toJson().isNotEmpty) {
        return Success(true);
      } else {
        return Failure('UnKnow error when upload backup');
      }
    } catch (e) {
      return Failure(e.toString());
    }
  }

  @override
  Future<ResponseResult<String, List<api_v2.File>>> getAllBackups({
    required GoogleSignInAccount currentUser,
  }) async {
    try {
      if (!await networkInfo.isConnected) {
        return Failure('noInternet'.tr());
      }
      GoogleSignInAuthentication authentication = await currentUser.authentication;
      final headers = {'Authorization': 'Bearer ${authentication.accessToken}'};
      final client = CustomHttpClient(defaultHeaders: headers);
      api_v2.DriveApi driveApi = api_v2.DriveApi(client);

      final files = await driveApi.files.list(
        spaces: DefaultSettings.nameFolderBackupsInGoogleDrive,
      );

      return Success(files.items ?? []);
    } catch (e) {
      return Failure(e.toString());
    }
  }
}

class GoogleAuthClient extends http.BaseClient {
  final Map<String, String> _headers;
  final _client = http.Client();

  GoogleAuthClient(this._headers);

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    request.headers.addAll(_headers);
    return _client.send(request);
  }
}

class CustomHttpClient extends http.BaseClient {
  final Map<String, String> defaultHeaders;
  final http.Client _httpClient = http.Client();

  CustomHttpClient({this.defaultHeaders = const {}});

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    request.headers.addAll(defaultHeaders);
    return _httpClient.send(request);
  }
}
