import 'package:flutter/cupertino.dart';

import '../enums/enums.dart';
import '../model/model_user.dart';
import '../value/data.dart';
import '../value/keys.dart';

class Global {
  static BuildContext? contextSplash;

  static ValueNotifier<ModelUser?> userNotifier = ValueNotifier(null);

  static String? uid;

}
