
import '../enums/enums.dart';

class ModelUser {
  final String uid;
  final String email;
  final String pw;
  final String nickname;
  final String? imageUrl;
  final LoginType loginType;

  const ModelUser({
    required this.uid,
    required this.email,
    required this.pw,
    required this.nickname,
    this.imageUrl,
    required this.loginType,
  });

  // fromJson
  factory ModelUser.fromJson(Map<dynamic, dynamic> data) {
    return ModelUser(
      uid: data['uid'],
      email: data['email'],
      pw: data['pw'],
      nickname: data['nickname'],
      imageUrl: data['imageUrl'],
      loginType: data['loginType'] == null ? LoginType.email : LoginType.values.firstWhere((e) => e.name == data['loginType']),
    );
  }

  // toJson
  Map<String, dynamic> toJson() => {
        'uid': uid,
        'email': email,
        'pw': pw,
        'nickname': nickname,
        'imageUrl': imageUrl,
        'loginType': loginType.name,
      };

  // copyWith
  ModelUser copyWith({
    String? uid,
    String? email,
    String? pw,
    String? nickname,
    String? imageUrl,
    LoginType? loginType,
  }) {
    return ModelUser(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      pw: pw ?? this.pw,
      nickname: nickname ?? this.nickname,
      imageUrl: imageUrl ?? this.imageUrl,
      loginType: loginType ?? this.loginType,
    );
  }
}
