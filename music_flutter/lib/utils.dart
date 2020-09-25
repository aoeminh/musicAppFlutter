import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

Future<bool> hasStoragePermision() {
  var status = Permission.storage.request();
  return status.isGranted;
}

Future<String> getStorageDirectory() async {
  var directory = await getApplicationSupportDirectory();
  String path = join(directory.path, 'musicflutter');
  print(' path $path');
  return path;
}

/// Strips characters that are invalid for file and directory names.
String safePath(String s) {
  return s == null ? null : s.replaceAll(RegExp(r'[^\w\s\.]+'), '');
}
