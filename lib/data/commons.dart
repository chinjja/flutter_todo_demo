import 'package:uuid/uuid.dart';

class Utils {
  static const u = Uuid();

  static String uuid() {
    return u.v4();
  }
}
