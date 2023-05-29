import 'dart:math';

import 'package:flutter/material.dart';
import 'package:haushaltsbuch/models/user.dart';
import 'package:haushaltsbuch/screens/signup/signup_screen.dart';
import 'package:haushaltsbuch/services/auth_provider.dart';
import 'package:haushaltsbuch/widgets/custom_textField.dart';
import 'package:localization/localization.dart';
import 'package:provider/provider.dart';

class UserDataScreen extends StatefulWidget {
  final User? user;
  const UserDataScreen({super.key, required this.user});
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
  ValueKey? _expansionTileKey;

  @override
  void initState() {
    super.initState();
    _signupActivated = widget.user != null;
    if (widget.user != null) {
      _userNameController.text = widget.user!.name;
      _userSecurityQuestionIdx = widget.user!.securityQuestionIndex;
      _userBioAuth = widget.user!.bioAuth;
    }
  }

  void _passwordChangedPressed() {
    if(_formKeyPassword.currentState!.validate()) {
      
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
        child: Form(
          // key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: ListView(
              children: [
                Card(
                  child: ExpansionTile(
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
                    initiallyExpanded: _signupActivated,
                    onExpansionChanged: (val) {
                      if (val) {
                        Navigator.of(context)
                            .pushNamed(SignupScreen.routeName)
                            .then((value) {
                          if (value == null) {
                            setState(() {
                              _expansionTileKey =
                                  ValueKey(Random().nextInt(99));
                            });
                          }
                        });
                      }
                    },
                    children: [
                      Divider(
                        indent: 5,
                        endIndent: 5,
                      ),
                      SizedBox(height: 10),
                      ListTile(
                        title: CustomTextField(
                          labelText: 'name'.i18n(),
                          controller: _userNameController,
                          mandatory: true,
                          enabled: _changeUserNameEnabled,
                          fieldname: 'userName',
                        ),
                        trailing: IconButton(
                          icon: Icon(
                            _changeUserNameEnabled ? Icons.save : Icons.edit,
                            color: _changeUserNameEnabled
                                ? Theme.of(context).primaryColor
                                : null,
                          ),
                          onPressed: () {
                            setState(() {
                              _changeUserNameEnabled = !_changeUserNameEnabled;
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
                          childrenPadding: EdgeInsets.symmetric(horizontal: 20),
                          children: [
                            SizedBox(height: 5),
                            CustomTextField(
                              controller: _userOldPasswordController,
                              mandatory: true,
                              fieldname: 'oldPassword',
                              labelText: 'old-password'.i18n(),
                              validator: (String val) {
                                if (val != widget.user!.password) {
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
                              fieldname: 'newPassword',
                              labelText: 'new-password'.i18n(),
                            ),
                            SizedBox(height: 20),
                            CustomTextField(
                                controller: _userRepeatNewPasswordController,
                                mandatory: true,
                                fieldname: 'repeatNewPassword',
                                labelText: 'repeat-new-password'.i18n(),
                                validator: (String val) {
                                  if (val != _userNewPasswordController.text) {
                                    return 'repeat-password-validator'.i18n();
                                  } else {
                                    return null;
                                  }
                                }),
                            SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: () => _passwordChangedPressed(),
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
                        childrenPadding: EdgeInsets.symmetric(horizontal: 20),
                        children: [
                          Text('Dropdown SecurityQuestion'),
                          SizedBox(height: 20),
                          CustomTextField(
                            controller: _userSecurityAnswer,
                            mandatory: true,
                            fieldname: 'securityAnswer',
                            labelText: 'answer'.i18n(),
                          ),
                          SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () {},
                            child: Text('change'.i18n()),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      SwitchListTile(
                          title: Text('bio-auth'.i18n()),
                          value: _userBioAuth,
                          onChanged: (val) {
                            setState(() {
                              _userBioAuth = val;
                            });
                          })
                    ],
                  ),
                ),
                // SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
