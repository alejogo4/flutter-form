import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:parcial_final/components/loader_component.dart';
import 'package:parcial_final/pages/form_page.dart';
import 'package:parcial_final/providers/login_provider.dart';
import 'package:parcial_final/utils/colors.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);
  static const String routeName = "login_page";

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isSigningIn = false;
  bool _showLoader = false;
  final LoginProvider _loginProvider = LoginProvider();

  Widget _showGoogleLoginButton() {
    return Row(
      children: <Widget>[
        Expanded(
            child: ElevatedButton.icon(
                onPressed: () => _loginGoogle(),
                icon: FaIcon(
                  FontAwesomeIcons.google,
                  color: Colors.red,
                ),
                label: Text('Iniciar sesión con Google'),
                style: ElevatedButton.styleFrom(
                    primary: Colors.white, onPrimary: Colors.black)))
      ],
    );
  }

  void _loginGoogle() async {
    setState(() {
      _showLoader = true;
    });

    var googleSignIn = GoogleSignIn(
      scopes: [
        'email',
        'https://www.googleapis.com/auth/contacts.readonly',
      ],
    );
    await googleSignIn.signOut();
    var user = await googleSignIn.signIn();

    if (user == null) {
      setState(() {
        _showLoader = false;
      });

      await showAlertDialog(
          context: context,
          title: 'Error',
          message:
              'Hubo un problema al obtener el usuario de Google, por favor intenta más tarde.',
          actions: <AlertDialogAction>[
            AlertDialogAction(key: null, label: 'Aceptar'),
          ]);
      return;
    }

    Map<String, dynamic> request = {
      'email': user.email,
      'id': user.id,
      'loginType': 1,
      'fullName': user.displayName,
      'photoURL': user.photoUrl,
    };

    var response = await _loginProvider.googleLogin(request);

    Navigator.pushNamedAndRemoveUntil(
        context, FormPage.routeName, (route) => false,
        arguments: {"token": response});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.firebaseNavy,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(
            left: 16.0,
            right: 16.0,
            bottom: 20.0,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Row(),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 20),
                    Text(
                      'Made by: Alejandro',
                      style: TextStyle(
                        color: CustomColors.firebaseYellow,
                        fontSize: 25,
                      ),
                    ),
                    Text(
                      'Giraldo Duque',
                      style: TextStyle(
                        color: CustomColors.firebaseOrange,
                        fontSize: 30,
                      ),
                    ),
                    SizedBox(height: 20),
                    _showGoogleLoginButton(),
                    _showLoader
                        ? LoaderComponent(text: 'Por favor espere...')
                        : Container(),
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
