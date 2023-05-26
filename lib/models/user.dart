class User {
  final String name;
  final String? password;
  final int securityQuestionIndex;
  final String? securityAnswer;
  final bool bioAuth;

  User({
    required this.name,
    required this.password,
    required this.securityQuestionIndex,
    required this.securityAnswer,
    required this.bioAuth,
  });

  User copyWith({
    String? name,
    String? password,
    int? securityQuestionIndex,
    String? securityAnswer,
    bool? bioAuth,
  }) {
    return User(
      name: name ?? this.name,
      password: password ?? this.password,
      securityQuestionIndex:
          securityQuestionIndex ?? this.securityQuestionIndex,
      securityAnswer: securityAnswer ?? this.securityAnswer,
      bioAuth: bioAuth ?? this.bioAuth,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'password': password,
      'securityQuestionIndex': securityQuestionIndex,
      'securityAnswer': securityAnswer,
      'bioAuth': bioAuth,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      name: map['name'] as String,
      password: map['password'] as String,
      securityQuestionIndex: map['securityQuestionIndex'],
      securityAnswer: map['securityAnswer'],
      bioAuth: map['bioAuth'] == 0 ? false : true,
    );
  }
}
