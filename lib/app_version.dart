import 'package:pub_semver/pub_semver.dart';

class AppVersion {
  static final current = Version.parse("0.1.0+1");

  static void checkIsSupportedVersion(String version) {
    if (version == "") {
      return;
    }
    if (Version.parse(version) > current) {
      throw Exception("Unsupported version - $version");
    }
  }
}