import 'package:flutter/material.dart';
import 'package:parcial_final/components/loader_component.dart';
import 'package:parcial_final/models/polls.dart';
import 'package:parcial_final/models/response.dart';
import 'package:parcial_final/models/token.dart';
import 'package:parcial_final/providers/polls_provider.dart';

class FormPage extends StatefulWidget {
  FormPage({Key? key}) : super(key: key);
  static const String routeName = "form_page";
  @override
  _FormPageState createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  String _email = '';
  String _emailError = '';
  bool _emailShowError = false;

  bool _showLoader = false;

  final PollsProvider _pollsProvider = PollsProvider();

  Map<String, dynamic> _params = {"token": ''};
  late Polls responsePolls;

  bool _validateFields() {
    bool isValid = true;

    if (_email.isEmpty) {
      isValid = false;
      _emailShowError = true;
      _emailError = 'Debes ingresar tu email.';
    }

    setState(() {});
    return isValid;
  }

  Widget _showEmail() {
    return Container(
      padding: EdgeInsets.all(10),
      child: TextField(
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          fillColor: Colors.white,
          filled: true,
          hintText: 'Ingresa tu email...',
          labelText: 'Email',
          errorText: _emailShowError ? _emailError : null,
          prefixIcon: Icon(Icons.alternate_email),
          suffixIcon: Icon(Icons.email),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        onChanged: (value) {
          _email = value;
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    Future(() {
      _params =
          ModalRoute.of(context)!.settings.arguments! as Map<String, dynamic>;
      setState(() {});
      fetchPolls(_params["token"]);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo,
      body: Stack(
        children: <Widget>[
          SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 40,
                ),
                _showEmail(),
              ],
            ),
          ),
          _showLoader
              ? LoaderComponent(text: 'Por favor espere...')
              : Container(),
        ],
      ),
    );
  }

  Future fetchPolls(Token token) async {
    setState(() {
      _showLoader = true;
    });

    responsePolls = (await _pollsProvider.getPolls(token)).result;
    setState(() {
      _showLoader = false;
    });
    setState(() {});
  }
}
