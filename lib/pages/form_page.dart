import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:parcial_final/components/loader_component.dart';
import 'package:parcial_final/models/polls.dart';
import 'package:parcial_final/models/response.dart';
import 'package:parcial_final/models/token.dart';
import 'package:parcial_final/providers/polls_provider.dart';
import 'package:parcial_final/utils/colors.dart';

class FormPage extends StatefulWidget {
  FormPage({Key? key}) : super(key: key);
  static const String routeName = "form_page";
  @override
  _FormPageState createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  int? id = 0;

  final _email = TextEditingController();
  String _emailError = '';
  bool _emailShowError = false;

  final _theBest = TextEditingController();
  String __theBestError = '';
  bool __theBestShowError = false;

  final _theWorst = TextEditingController();
  String _theWorstError = '';
  bool _theWorstShowError = false;

  final _remarks = TextEditingController();
  String _remarksError = '';
  bool _remarksShowError = false;

  bool _showLoader = false;

  final PollsProvider _pollsProvider = PollsProvider();

  Map<String, dynamic> _params = {"token": ''};
  late Polls responsePolls;

  late final _ratingController;
  late double _rating = 1;

//Rating
  double _userRating = 3.0;
  int _ratingBarMode = 1;
  double _initialRating = 2.0;
  bool _isRTLMode = false;
  bool _isVertical = false;
  IconData? _selectedIcon;

  bool _validateFields() {
    bool isValid = true;

    if (_email.text.isEmpty) {
      isValid = false;
      _emailShowError = true;
      _emailError = 'Debes ingresar tu email.';
    }

    bool emailValid = RegExp(
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))$')
        .hasMatch(_email.text);

    if (!emailValid) {
      isValid = false;
      _emailShowError = true;
      _emailError = 'Debes ingresar un correo valido.';
    }

    if (_theBest.text.isEmpty) {
      isValid = false;
      __theBestShowError = true;
      __theBestError = 'Debes ingresar lo mejor del curso.';
    }

    if (_theWorst.text.isEmpty) {
      isValid = false;
      _theWorstShowError = true;
      _theWorstError = 'Debes ingresar lo malo del curso.';
    }

    if (_remarks.text.isEmpty) {
      isValid = false;
      _remarksShowError = true;
      _remarksError = 'Debes ingresar un comentario.';
    }

    setState(() {});
    return isValid;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _email.dispose();
    _theBest.dispose();
    _theWorst.dispose();
    _remarks.dispose();
  }

  @override
  void initState() {
    super.initState();
    Future(() async {
      _params =
          ModalRoute.of(context)!.settings.arguments! as Map<String, dynamic>;
      fetchPolls(_params["token"]);
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.firebaseNavy,
      body: Stack(
        children: <Widget>[
          SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const SizedBox(
                  height: 40,
                ),
                _showRating(),
                Column(
                  children: [
                    Row(
                      children: [
                        _showEmail(),
                        _prefixTxt(),
                      ],
                    ),
                  ],
                ),
                _theBestField(),
                _theWorstField(),
                _remarksField(),
                const SizedBox(height: 10),
                _showButton(),
                const SizedBox(height: 20),
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

    id = responsePolls.id;
    dynamic emailSplit = responsePolls?.email?.split("@");
    _email.text = emailSplit?[0] ?? '';
    _theBest.text = responsePolls.theBest ?? '';
    _theWorst.text = responsePolls.theWorst ?? '';
    _remarks.text = responsePolls.remarks ?? '';
    _rating = double.parse(responsePolls.qualification.toString());
    setState(() {});
  }

  Widget _prefixTxt() {
    return Text("@correo.itm.edu.co");
  }

  Widget _showEmail() {
    return Container(
      width: (MediaQuery.of(context).size.width - 20) / 1.5,
      padding: const EdgeInsets.all(10),
      child: TextField(
        controller: _email,
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          filled: true,
          hintText: 'Ingresa tu email...',
          labelText: 'Email',
          errorText: _emailShowError ? _emailError : null,
          labelStyle: const TextStyle(color: Colors.white),
          prefixIcon: const Icon(Icons.alternate_email),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }

  Widget _theBestField() {
    return Container(
      padding: const EdgeInsets.all(10),
      child: TextField(
        controller: _theBest,
        maxLines: 2,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          filled: true,
          hintText: 'Lo mejor del curso...',
          labelText: 'Lo mejor del curso',
          labelStyle: const TextStyle(color: Colors.white),
          errorText: __theBestShowError ? __theBestError : null,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }

  Widget _theWorstField() {
    return Container(
      padding: const EdgeInsets.all(10),
      child: TextField(
        maxLines: 2,
        controller: _theWorst,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          filled: true,
          hintText: 'Lo malo del curso...',
          labelText: 'Lo malo del curso',
          labelStyle: const TextStyle(color: Colors.white),
          errorText: _theWorstShowError ? _theWorstError : null,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }

  Widget _remarksField() {
    return Container(
      padding: const EdgeInsets.all(10),
      child: TextField(
        controller: _remarks,
        maxLines: 2,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          filled: true,
          hintText: 'Comentarios...',
          labelText: 'Comentarios',
          errorText: _remarksShowError ? _remarksError : null,
          labelStyle: const TextStyle(color: Colors.white),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }

  Widget _showRating() {
    return Column(
      children: [
        const Text(
          "Calificación del curso",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        RatingBar.builder(
          initialRating: _rating,
          minRating: 1,
          direction: _isVertical ? Axis.vertical : Axis.horizontal,
          allowHalfRating: true,
          unratedColor: Colors.amber.withAlpha(50),
          itemCount: 5,
          itemSize: 50.0,
          itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
          itemBuilder: (context, index) {
            switch (index) {
              case 0:
                return const Icon(
                  Icons.sentiment_very_dissatisfied,
                  color: Colors.red,
                );
              case 1:
                return const Icon(
                  Icons.sentiment_dissatisfied,
                  color: Colors.redAccent,
                );
              case 2:
                return const Icon(
                  Icons.sentiment_neutral,
                  color: Colors.amber,
                );
              case 3:
                return const Icon(
                  Icons.sentiment_satisfied,
                  color: Colors.lightGreen,
                );
              case 4:
                return const Icon(
                  Icons.sentiment_very_satisfied,
                  color: Colors.green,
                );
              default:
                return Container();
            }
          },
          onRatingUpdate: (rating) {
            setState(() {
              _rating = rating;
            });
          },
          updateOnDrag: true,
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _showButton() {
    return SizedBox(
      width: MediaQuery.of(context).size.width - 20,
      child: ElevatedButton(
        child: const Text("Guardar"),
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith<Color>(
              (Set<MaterialState> states) {
            return const Color(0xFF12E46);
          }),
        ),
        onPressed: () async {
          _emailShowError = false;
          __theBestShowError = false;
          _theWorstShowError = false;
          _remarksShowError = false;
          setState(() {});
          if (!_validateFields()) {
            return;
          }
          Polls poll = Polls(
            email: _email.text + "@correo.itm.edu.co",
            remarks: _remarks.text,
            theBest: _theBest.text,
            theWorst: _theWorst.text,
            qualification: _rating.round(),
            date: DateTime.now().toString(),
            id: id!,
          );
          setState(() {
            _showLoader = true;
          });
          Response response =
              await _pollsProvider.saveOrUpdatePolls(poll, _params["token"]);
          id = response.result.id;
          await showAlertDialog(
              context: context,
              title: 'Registro exitoso',
              message:
                  'Se han registrado los datos de la encuesta de manera correcta',
              actions: <AlertDialogAction>[
                AlertDialogAction(key: null, label: 'Aceptar'),
              ]);
          setState(() {
            _showLoader = false;
          });
        },
      ),
    );
  }
}
