import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/material.dart';
import 'package:haushaltsbuch/widgets/custom_textField.dart';
import 'package:localization/localization.dart';

class Login extends StatelessWidget {
  final TextEditingController userPasswordController;
  final Function loginPressed;
  final Function forgotPasswordPressed;
  final Function fingerprintPressed;
  final bool bioAuthActivated;
  final formKey;
  const Login({
    super.key,
    required this.userPasswordController,
    required this.loginPressed,
    required this.forgotPasswordPressed,
    required this.formKey,
    required this.bioAuthActivated,
    required this.fingerprintPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
        key: formKey,
        child: Column(
          children: [
            CustomTextField(
              controller: userPasswordController,
              mandatory: false,
              fieldname: 'userPasswordLogin',
              labelText: 'password'.i18n(),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => loginPressed(),
              child: Text('login'.i18n()),
              style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary),
            ),
            TextButton(
              onPressed: () => forgotPasswordPressed(),
              child: Text(
                'forgot-password'.i18n(),
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
            ),
            bioAuthActivated
                ? Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 25.0),
                      child: SizedBox(
                        height: 70,
                        width: 70,
                        child: FloatingActionButton(
                          onPressed: () => fingerprintPressed(context),
                          child: Icon(
                            CommunityMaterialIcons.fingerprint,
                            size: 50,
                          ),
                          backgroundColor: Colors.transparent,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ),
                  )
                : Container(),
          ],
        ));
  }
}
