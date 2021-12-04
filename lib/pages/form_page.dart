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
  String _email = '';
  String _emailError = '';
  bool _emailShowError = false;

  String _theBest = '';
  String __theBestError = '';
  bool __theBestShowError = false;

  String _theWorst = '';
  String _theWorstError = '';
  bool _theWorstShowError = false;

  String _remarks = '';
  String _remarksError = '';
  bool _remarksShowError = false;

  bool _showLoader = false;

  final PollsProvider _pollsProvider = PollsProvider();

  Map<String, dynamic> _params = {"token": ''};
  late Polls responsePolls;

  late final _ratingController;
  late double _rating;

//Rating
  double _userRating = 3.0;
  int _ratingBarMode = 1;
  double _initialRating = 2.0;
  bool _isRTLMode = false;
  bool _isVertical = false;
  IconData? _selectedIcon;

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
      backgroundColor: CustomColors.firebaseNavy,
      body: Stack(
        children: <Widget>[
          SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 40,
                ),
                _showRating(),
                _showEmail(),
                _theBestField(),
                _theBestField(),
                _theWorstField(),
                _remarksField(),
                SizedBox(height: 10),
                _showButton(),
                SizedBox(height: 20),
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

  Widget _showEmail() {
    return Container(
      padding: EdgeInsets.all(10),
      child: TextField(
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          filled: true,
          hintText: 'Ingresa tu email...',
          labelText: 'Email',
          errorText: _emailShowError ? _emailError : null,
          labelStyle: TextStyle(color: Colors.white),
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

  Widget _theBestField() {
    return Container(
      padding: EdgeInsets.all(10),
      child: TextField(
        maxLines: 2,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          filled: true,
          hintText: 'Lo mejor del curso...',
          labelText: 'Lo mejor del curso',
          labelStyle: TextStyle(color: Colors.white),
          errorText: __theBestShowError ? __theBestError : null,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        onChanged: (value) {
          _theBest = value;
        },
      ),
    );
  }

  Widget _theWorstField() {
    return Container(
      padding: EdgeInsets.all(10),
      child: TextField(
        maxLines: 2,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          filled: true,
          hintText: 'Lo malo del curso...',
          labelText: 'Lo malo del curso',
          labelStyle: TextStyle(color: Colors.white),
          errorText: _theWorstShowError ? _theWorstError : null,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        onChanged: (value) {
          _theWorst = value;
        },
      ),
    );
  }

  Widget _remarksField() {
    return Container(
      padding: EdgeInsets.all(10),
      child: TextField(
        maxLines: 2,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          filled: true,
          hintText: 'Comentarios...',
          labelText: 'Comentarios',
          errorText: _remarksShowError ? _remarksError : null,
          labelStyle: TextStyle(color: Colors.white),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        onChanged: (value) {
          _remarks = value;
        },
      ),
    );
  }

  Widget _showRating() {
    return Column(
      children: [
        Text("Calificación del curso",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        RatingBar.builder(
          initialRating: _initialRating,
          minRating: 1,
          direction: _isVertical ? Axis.vertical : Axis.horizontal,
          allowHalfRating: true,
          unratedColor: Colors.amber.withAlpha(50),
          itemCount: 5,
          itemSize: 50.0,
          itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
          itemBuilder: (context, _) => Icon(
            _selectedIcon ?? Icons.star,
            color: Colors.amber,
          ),
          onRatingUpdate: (rating) {
            setState(() {
              _rating = rating;
            });
          },
          updateOnDrag: true,
        ),
        SizedBox(height: 20),
      ],
    );
  }

  Widget _showButton() {
    return SizedBox(
      width: MediaQuery.of(context).size.width - 20,
      child: ElevatedButton(
        child: Text("Guardar"),
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith<Color>(
              (Set<MaterialState> states) {
            return Color(0xFF12E46);
          }),
        ),
        onPressed: () => {},
      ),
    );
  }
}
