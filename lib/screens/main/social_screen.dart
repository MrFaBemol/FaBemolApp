import 'package:FaBemol/data/colors.dart';
import 'package:FaBemol/providers/searchs.dart';
import 'package:FaBemol/providers/user_profile.dart';
import 'package:FaBemol/screens/social/any_user_profile_page_screen.dart';
import 'package:FaBemol/widgets/container_flat_design.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:FaBemol/functions/localization.dart';
import 'package:provider/provider.dart';

class MeetScreen extends StatefulWidget {
  static const String routeName = '/meet';

  @override
  _MeetScreenState createState() => _MeetScreenState();
}

class _MeetScreenState extends State<MeetScreen> {
  final _formKey = GlobalKey<FormState>();
  String searchText = '';
  List<Map<String, dynamic>> resultsList = [];
  bool hasMadeASearch = false;

  void trySearch() async {
    // On vérifie que tout est valide
    bool isValid = _formKey.currentState.validate();
    // On vire le clavier s'il est encore apparent
    FocusScope.of(context).unfocus();

    if (isValid) {
      // On save le formulaire
      _formKey.currentState.save();
      // On arrange le texte pour pas avoir de blancs
      searchText = searchText.trim();

      List<Map<String, dynamic>> resultsFromDB =
          await Provider.of<Searchs>(context, listen: false)
              .searchUsers(search: searchText, limit: 5);

      setState(() {
        // On récupère les résultats de la base de données.
        resultsList = resultsFromDB;
        // On précise qu'une recherche a été effectuée, peu importe le résultat
        hasMadeASearch = true;
      });

      //print(resultsList);
    }
  }

  @override
  Widget build(BuildContext context) {
    var userProfile = Provider.of<UserProfile>(context, listen: false);

    return Column(
      children: [
        ///************ La boite de recherche
        ContainerFlatDesign(
          margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          child: Column(
            children: [
              AutoSizeText(
                'search'.tr() + ' :',
                maxLines: 1,
                style: Theme.of(context).textTheme.headline6,
              ),
              SizedBox(height: 10),
              Form(
                key: _formKey,
                child: Row(
                  children: [
                    // L'icone
                    Image.asset('assets/icons/96/search-user-byname.png',
                        height: 38),
                    SizedBox(width: 10),
                    // Le formulaire
                    Expanded(
                      child: TextFormField(
                        key: ValueKey('search_username'),
                        keyboardType: TextInputType.name,
                        decoration: InputDecoration(
                          hintText: 'social_search_username_or_email'.tr(),
                        ),
                        onSaved: (value) {
                          searchText = value;
                        },
                        validator: (value) {
                          if (value.length < 3) {
                            return 'error_input_too_short_3'.tr();
                          }
                          if (value == searchText) {
                            return 'error_social_search_already_complete'.tr();
                          }
                          return value != ''
                              ? null
                              : 'error_social_enter_search'.tr();
                        },
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: trySearch,
                child: Text('button_search'.tr()),
              ),
              SizedBox(height: 10),

              if (hasMadeASearch && resultsList.isEmpty)
                Text('error_social_no_result'.tr()),

              // On affiche tous les résultats s'il y en a
              if (resultsList != []) SizedBox(height: 10),
              if (resultsList != [])
                ...resultsList.map((user) {
                  // On parcourt tous les résultats et on crée un user Tile + un espace blanc si ce n'est pas le dernier user à s'afficher
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // On n'affiche pas l'user tile si c'est l'utilisateur qui a fait la recherche (il a un onglet spécialement pour ça)
                      if (user['userId'] != userProfile.userId) UserTile(user),
                      if (resultsList.indexOf(user) < resultsList.length - 1)
                        SizedBox(height: 10),
                      //Divider(color: Theme.of(context).shadowColor),
                    ],
                  );
                }),
            ],
          ),
        ),
      ],
    );
  }
}

/// *********************************************
/// Crée un Tile basique pour afficher l'utilisateur (à améliorer si besoin)
/// *********************************************
class UserTile extends StatelessWidget {
  final Map<String, dynamic> user;

  UserTile(this.user);

  @override
  Widget build(BuildContext context) {
    // On crée l'avatar qu'on va insérer dans le leading *******************************
    Widget avatar =
        // Si on a une profilePicture enregistrée
        user['profilePicture'] != '' && user['profilePicture'] != null
            // On crée un circle avatar
            ? Hero(
                tag: 'profilePicture_' + user['userId'],
                child: CircleAvatar(
                  minRadius: 35,
                  backgroundImage: NetworkImage(user['profilePicture']),
                ),
              )
            // Sinon on crée un texte comme d'hab
            : AutoSizeText(
                user['username'].substring(0, 1).toUpperCase(),
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 200,
                    fontWeight: FontWeight.bold),
              );

    return ListTile(
      onTap: () {
        // On s'envole vers la nouvelle page.
        Navigator.of(context)
            .pushNamed(AnyUserProfilePageScreen.routeName, arguments: {
          'userId': user['userId'],
        });
      },
      // ***************** La ProfilePicture
      leading: Container(
        height: 70,
        width: 70,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: [
              COLORS.PROFILE_COLORS[user['color']].shade800,
              COLORS.PROFILE_COLORS[user['color']].shade300,
            ],
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
          ),
        ),
        child: avatar,
      ),

      // ***************** L'Username
      title: AutoSizeText(
        user['username'],
        style: TextStyle(fontSize: 24),
        maxLines: 1,
      ),

      //trailing: Icon(Icons.keyboard_arrow_right, color: Colors.grey,),
    );
  }
}
