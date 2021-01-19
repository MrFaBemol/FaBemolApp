import 'package:FaBemol/widgets/container_flat_design.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:FaBemol/functions/localization.dart';

class LoginForm extends StatefulWidget {
  // On récup la fonction qu'il faut appeler, et ce qui nous dit si ça charge ou pas.
  final void Function(String email, String password, String username, bool isLogin, BuildContext ctx) submitFn;

  final bool isLoading;

  LoginForm(this.submitFn, this.isLoading);

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();

  bool _isLogin = true; // Pour switch entre les 2 formulaires
  String _userEmail, _userName, _userPassword = ''; // Les variables de stockage

  String bubbleText = 'welcome_back_text'.tr(); // Le texte dans la bulle

  void switchLogin(bool isLogin) {
    setState(() {
      _isLogin = isLogin;
      bubbleText = isLogin ? 'welcome_back_text'.tr() : 'welcome_text'.tr();
    });
  }

  void _trySubmit() {
    // On vérifie que tout est valide
    bool isValid = _formKey.currentState.validate();
    // On vire le clavier s'il est encore apparent
    FocusScope.of(context).unfocus();

    if (isValid) {
      // On enregistre les valeurs des champs
      _formKey.currentState.save();
      // Un petit hack pour l'username et les blancs inutiles
      _userName = (_isLogin) ? '' : _userName.trim();
      // On envoie tout dans la fonction
      widget.submitFn(_userEmail.trim(), _userPassword.trim(), _userName.trim(), _isLogin, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            //Divider(indent: 50, endIndent: 50,color: Theme.of(context).primaryColor,),
            //********************** Les jolis Boutons
            LoginSignupButtons(this._isLogin, switchLogin),

            SizedBox(height: 10),

            // Le bonhomme qui parle
            Container(
              height: 120,
              //color: Colors.red,
              margin: EdgeInsets.symmetric(horizontal: 30),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: ContainerFlatDesign(
                      //height: double.infinity,
                      padding: EdgeInsets.all(5),

                      child: SingleChildScrollView(
                          child: AutoSizeText(
                        bubbleText,
                        style: TextStyle(fontWeight: FontWeight.bold),
                        textAlign: TextAlign.right,
                      )),
                    ),
                  ),
                  SizedBox(width: 20),
                  Image.asset('assets/icons/96/homme-content.png'),
                ],
              ),
            ),

            SizedBox(height: 20),

            //**********************DEBUT DU FORMULAIRE
            // De quoi centrer et donner un peu de padding
            Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 30),
                // Les items du formulaire
                child: Column(
                  children: [
                    // L'email ************
                    Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                      Image.asset(
                        'assets/icons/96/email.png',
                        height: 30,
                        color: Theme.of(context).primaryColor,
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: TextFormField(
                          key: ValueKey('email'),
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(labelText: 'email'.tr()),
                          onSaved: (value) {
                            _userEmail = value;
                          },
                          validator: (value) {
                            bool emailValid = RegExp(
                                    r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
                                .hasMatch(value);
                            if (value.isEmpty || !emailValid) {
                              return 'error_badformatted_email'.tr();
                            }
                            return null;
                          },
                        ),
                      ),
                    ]),

                    // Le password *********
                    Row(
                      children: [
                        Image.asset(
                          'assets/icons/96/mot-de-passe.png',
                          height: 30,
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: TextFormField(
                            key: ValueKey('password'),
                            keyboardType: TextInputType.text,
                            obscureText: true,
                            decoration: InputDecoration(labelText: 'password'.tr()),
                            onSaved: (value) {
                              _userPassword = value;
                            },
                            validator: (value) {
                              if (value.isEmpty || value.length < 8 || value.length > 20) {
                                return 'error_badformatted_password'.tr();
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),

                    // L'username *********
                    if (!_isLogin)
                      Row(
                        children: [
                          Image.asset(
                            'assets/icons/96/user.png',
                            height: 30,
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: TextFormField(
                              key: ValueKey('username'),
                              keyboardType: TextInputType.name,
                              decoration: InputDecoration(
                                labelText: 'username'.tr(),
                                helperText: 'username_helper'.tr(),
                              ),
                              onSaved: (value) {
                                _userName = value;
                              },
                              validator: (value) {
                                bool usernameValid = RegExp(r"^[a-zA-Z0-9_-]{3,24}$").hasMatch(value);
                                if (value.isEmpty || value.length < 3 || value.length > 24 || !usernameValid) {
                                  return 'error_badformatted_username'.tr();
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                    if (_isLogin)
                      SizedBox(
                        height: 30,
                      ),

                    SizedBox(height: 10),

                    // On affiche si ça charge ou pas
                    if (widget.isLoading) CircularProgressIndicator(),

                    if (!widget.isLoading)
                      ElevatedButton(
                        onPressed: _trySubmit,
                        child: Text(
                          (_isLogin) ? 'login_button'.tr().toUpperCase() : 'signin_button'.tr().toUpperCase(),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//**************************************************
// Les "boutons" pour switch
class LoginSignupButtons extends StatelessWidget {
  final bool _isLogin;
  final Function switchLogin;

  LoginSignupButtons(this._isLogin, this.switchLogin);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 3, horizontal: 4),
      margin: EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: Theme.of(context).accentColor,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 4,
            blurRadius: 7,
            offset: Offset(0, 2), // changes position of shadow
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 1,
            child: InkWell(
              child: Container(
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: (_isLogin) ? Colors.white : Theme.of(context).accentColor,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.login, color: (_isLogin) ? Theme.of(context).accentColor : Colors.white),
                    SizedBox(
                      width: 5,
                    ),
                    Expanded(
                      child: AutoSizeText(
                        'login'.tr().toUpperCase(),
                        maxLines: 1,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: (_isLogin) ? Theme.of(context).accentColor : Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              onTap: () {
                switchLogin(true);
              },
            ),
          ),
          Expanded(
            flex: 1,
            child: InkWell(
              child: Container(
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: (_isLogin) ? Theme.of(context).accentColor : Colors.white,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(
                      Icons.person_add,
                      color: (_isLogin) ? Colors.white : Theme.of(context).accentColor,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Expanded(
                      child: AutoSizeText(
                        'signin'.tr().toUpperCase(),
                        maxLines: 1,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: (_isLogin) ? Colors.white : Theme.of(context).accentColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              onTap: () {
                switchLogin(false);
              },
            ),
          ),
        ],
      ),
    );
    //********* FIN DES BOUTONS;
  }
}
