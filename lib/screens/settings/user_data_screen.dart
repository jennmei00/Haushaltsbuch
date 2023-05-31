import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:haushaltsbuch/models/all_data.dart';
import 'package:haushaltsbuch/models/enums.dart';
import 'package:haushaltsbuch/models/user.dart';
import 'package:haushaltsbuch/screens/signup/signup_screen.dart';
import 'package:haushaltsbuch/services/auth_provider.dart';
import 'package:haushaltsbuch/widgets/custom_textField.dart';
import 'package:local_auth/local_auth.dart';
import 'package:localization/localization.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserDataScreen extends StatefulWidget {
  const UserDataScreen({super.key});
  static final routeName = '/user_data_screen';

  @override
  State<UserDataScreen> createState() => _UserDataScreenState();
}

class _UserDataScreenState extends State<UserDataScreen> {
  TextEditingController _userNameController = TextEditingController();
  TextEditingController _userOldPasswordController = TextEditingController();
  TextEditingController _userNewPasswordController = TextEditingController();
  TextEditingController _userRepeatNewPasswordController =
      TextEditingController();
  TextEditingController _userSecurityAnswer = TextEditingController();
  int _userSecurityQuestionIdx = 0;
  bool _userBioAuth = false;

  bool _changeUserNameEnabled = false;
  bool _signupActivated = false;

  final _formKeyPassword = GlobalKey<FormState>();
  final _formKeyName = GlobalKey<FormState>();
  final _formKeySecurityAnswer = GlobalKey<FormState>();
  ValueKey? _expansionTileKey;

  AuthProvider? authProvider;

  @override
  void initState() {
    super.initState();
    authProvider = AllData.authProvider;
    _signupActivated = authProvider != null;

    if (authProvider != null) {
      if (authProvider!.currentUser != null) {
        User user = authProvider!.currentUser!;
        _userNameController.text = user.name;
        _userSecurityQuestionIdx = user.securityQuestionIndex;
        _userBioAuth = user.bioAuth;
      } else {
        _signupActivated = false;
      }
    }
  }

  void _userChangedPressed(String change, {bool bioAuthVal = false}) async {
    User newUserData = authProvider!.currentUser!;
    bool validate = false;
    String text = '';

    switch (change) {
      case 'password':
        if (_formKeyPassword.currentState!.validate()) {
          validate = true;
          newUserData = authProvider!.currentUser!
              .copyWith(password: _userNewPasswordController.text);
          text = 'changed-password'.i18n();
        }
        break;
      case 'name':
        if (_formKeyName.currentState!.validate()) {
          if (_userNameController.text != authProvider!.currentUser!.name) {
            validate = true;
            newUserData = authProvider!.currentUser!
                .copyWith(name: _userNameController.text);
            text = 'changed-name'.i18n();
            var prefs = await SharedPreferences.getInstance();
            prefs.setString('userName', _userNameController.text);
          }
        }
        break;
      case 'securityQuestion':
        if (_formKeySecurityAnswer.currentState!.validate()) {
          validate = true;
          newUserData = authProvider!.currentUser!.copyWith(
              securityAnswer: _userSecurityAnswer.text,
              securityQuestionIndex: _userSecurityQuestionIdx);
          text = 'changed-security-question';
        }
        break;
      case 'bioAuth':
        if (bioAuthVal) {
          try {
            await LocalAuthentication()
                .authenticate(localizedReason: 'local-auth-text'.i18n())
                .then((value) async {
              if (value) {
                _userBioAuth = true;
                newUserData =
                    authProvider!.currentUser!.copyWith(bioAuth: _userBioAuth);
                var prefs = await SharedPreferences.getInstance();
                prefs.setBool('userBioAuth', _userBioAuth);
                validate = true;
                text = 'changed-bio-auth';
              }
            });
          } catch (e) {
            print(e);
            if (e is PlatformException) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(
                'local-auth-exception-text'.i18n(),
              )));
            }
          }
        } else {
          _userBioAuth = bioAuthVal;
          newUserData =
              authProvider!.currentUser!.copyWith(bioAuth: _userBioAuth);
          var prefs = await SharedPreferences.getInstance();
          prefs.setBool('userBioAuth', _userBioAuth);
          validate = true;
          text = 'changed-bio-auth';
        }

        break;
    }
    if (validate) {
      await authProvider!.updateUser(newUserData).then((value) {
        setState(() {
          _userNewPasswordController.text = '';
          _userOldPasswordController.text = '';
          _userRepeatNewPasswordController.text = '';
          _userSecurityAnswer.text = '';
        });
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('$text')));
      });
    }
  }

  void _onExpansionChanged() async {
    if (!_signupActivated) {
      Navigator.of(context).pushNamed(SignupScreen.routeName).then((value) {
        if (value != null) {
          setState(() {
            _signupActivated = true;
          });
        }
      });
    } else if (_signupActivated) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              icon: Icon(Icons.no_accounts),
              title: Text('deactivate-title'.i18n()),
              content: Text('deactivate-content'.i18n()),
              actions: [
                TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text('cancel'.i18n())),
                TextButton(
                    onPressed: () async {
                      var prefs = await SharedPreferences.getInstance();
                      prefs.setBool('loginActivated', false);
                      setState(() {
                        _signupActivated = false;
                        authProvider!.deleteUser();
                      });
                      Navigator.of(context).pop();
                    },
                    child: Text('deactivate'.i18n()))
              ],
            );
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('user-data'.i18n()),
        centerTitle: true,
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: ListView(
            children: [
              Card(
                child: ExpansionPanelList(
                  expansionCallback: (panelIndex, isExpanded) =>
                      _onExpansionChanged(),
                  expandIconColor: Colors.transparent,
                  expandedHeaderPadding: EdgeInsets.all(0),
                  children: [
                    ExpansionPanel(
                      isExpanded: _signupActivated,
                      headerBuilder: (BuildContext context, bool isExpanded) {
                        return GestureDetector(
                          onTap: () => _onExpansionChanged(),
                          child: ListTile(
                            key: _expansionTileKey,
                            title: Text(_signupActivated
                                ? 'deactivate-login'.i18n()
                                : 'activate-login'.i18n()),
                            trailing: IgnorePointer(
                              child: Switch(
                                value: _signupActivated,
                                onChanged: (_) {},
                              ),
                            ),
                          ),
                        );
                      },
                      body: Column(
                        children: [
                          Divider(
                            indent: 5,
                            endIndent: 5,
                          ),
                          SizedBox(height: 10),
                          ListTile(
                            title: Form(
                              key: _formKeyName,
                              child: CustomTextField(
                                labelText: 'name'.i18n(),
                                controller: _userNameController,
                                mandatory: true,
                                enabled: _changeUserNameEnabled,
                                fieldname: 'userName',
                              ),
                            ),
                            trailing: IconButton(
                              icon: Icon(
                                _changeUserNameEnabled
                                    ? Icons.save
                                    : Icons.edit,
                                color: _changeUserNameEnabled
                                    ? Theme.of(context).primaryColor
                                    : null,
                              ),
                              onPressed: () {
                                if (_changeUserNameEnabled) {
                                  _userChangedPressed('name');
                                }
                                setState(() {
                                  _changeUserNameEnabled =
                                      !_changeUserNameEnabled;
                                });
                              },
                            ),
                          ),
                          SizedBox(height: 10),
                          Form(
                            key: _formKeyPassword,
                            child: ExpansionTile(
                              title: Text(
                                'change-password'.i18n(),
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              childrenPadding:
                                  EdgeInsets.symmetric(horizontal: 20),
                              children: [
                                SizedBox(height: 5),
                                CustomTextField(
                                  controller: _userOldPasswordController,
                                  mandatory: true,
                                  fieldname: 'oldPassword',
                                  labelText: 'old-password'.i18n(),
                                  validator: (String val) {
                                    if (val !=
                                        authProvider!.currentUser!.password) {
                                      return 'wrong-password'.i18n();
                                    } else {
                                      return null;
                                    }
                                  },
                                ),
                                SizedBox(height: 20),
                                CustomTextField(
                                  controller: _userNewPasswordController,
                                  mandatory: true,
                                  fieldname: 'userPassword',
                                  labelText: 'new-password'.i18n(),
                                ),
                                SizedBox(height: 20),
                                CustomTextField(
                                    controller:
                                        _userRepeatNewPasswordController,
                                    mandatory: true,
                                    fieldname: 'repeatNewPassword',
                                    labelText: 'repeat-new-password'.i18n(),
                                    validator: (String val) {
                                      if (val !=
                                          _userNewPasswordController.text) {
                                        return 'repeat-password-validator'
                                            .i18n();
                                      } else {
                                        return null;
                                      }
                                    }),
                                SizedBox(height: 20),
                                ElevatedButton(
                                  onPressed: () =>
                                      _userChangedPressed('password'),
                                  child: Text('change'.i18n()),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 10),
                          ExpansionTile(
                            title: Text(
                              'change-security-question'.i18n(),
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            childrenPadding:
                                EdgeInsets.symmetric(horizontal: 20),
                            children: [
                              DropdownButton<int>(
                                value: _userSecurityQuestionIdx,
                                underline: Container(),
                                isExpanded: true,
                                items: SecurityQuestionEnum.values
                                    .map((e) => DropdownMenuItem(
                                        value: e.index,
                                        child: Text(
                                          e.value,
                                          overflow: TextOverflow.visible,
                                        )))
                                    .toList(),
                                onChanged: (val) =>
                                    _userSecurityQuestionIdx = val!,
                              ),
                              SizedBox(height: 20),
                              Form(
                                key: _formKeySecurityAnswer,
                                child: CustomTextField(
                                  controller: _userSecurityAnswer,
                                  mandatory: true,
                                  fieldname: 'securityAnswer',
                                  labelText: 'answer'.i18n(),
                                ),
                              ),
                              SizedBox(height: 20),
                              ElevatedButton(
                                onPressed: () =>
                                    _userChangedPressed('securityQuestion'),
                                child: Text('change'.i18n()),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          SwitchListTile(
                              title: Text('bio-auth'.i18n()),
                              value: _userBioAuth,
                              onChanged: (val) {
                                _userChangedPressed('bioAuth', bioAuthVal: val);
                              })
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
