import 'package:FaBemol/functions/numbers.dart';
import 'package:FaBemol/data/colors.dart';
import 'package:FaBemol/data/data.dart';
import 'package:FaBemol/providers/any_user_profile.dart';
import 'package:FaBemol/providers/user_profile.dart';
import 'package:FaBemol/widgets/profile/profile_edit_picture_button.dart';
import 'package:FaBemol/widgets/profile/profile_tab_challenge.dart';
import 'package:FaBemol/widgets/profile/profile_tab_lessons.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  final String userId;

  ProfilePage(this.userId);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  var _isInit = false;
  var userProfile;

  @override
  void didChangeDependencies() {
    // Si on a pas encore chargé l'utilisateur :
    if (!_isInit) {
      // Si l'utilisateur à afficher n'est pas celui qui utilise l'application on charge les infos du compte
      if (this.widget.userId != 'user') {
        // On charge les infos de l'utilisateur
        Provider.of<AnyUserProfile>(context, listen: false)
            .fetchUserInfo(this.widget.userId);
        setState(() {
          this.userProfile = Provider.of<AnyUserProfile>(context);
        });
      } else {
        setState(() {
          this.userProfile = Provider.of<UserProfile>(context);
        });
      }
    }
    _isInit = true;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    // Si les infos ne sont pas encore  chargées, on affiche un cercle qui tourne
    if (!_isInit ||
        this.userProfile == null ||
        this.userProfile.username == '') {
      print('pas encore loaded');
      return CircularProgressIndicator();
    }

    // Le stack avec de bas en haut :
    // La photo de couverture
    // Le body
    // La photo de profil
    return Stack(children: [
      // La photo de couverture
      CoverPicture(this.userProfile),

      /// La boite blanche avec des bords arrondis
      /// Margin de 120 pixels
      Container(
        width: double.infinity,
        margin: EdgeInsets.only(top: 120, right: 0, left: 0),
        padding: EdgeInsets.only(top: 75, bottom: 0, right: 40, left: 40),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(50),
            topLeft: Radius.circular(50),
          ),
          boxShadow: [
            BoxShadow(
              // Effet 3D
              color: Colors.black.withOpacity(0.4),
              spreadRadius: 2,
              blurRadius: 7,
              offset: Offset(0, 1),
            )
          ],
        ),
        // LES ENFANTS : ************************************************************
        child: Column(
          children: [
            // Le Pseudo
            AutoSizeText(
              userProfile.username,
              style: Theme.of(context)
                  .textTheme
                  .headline5
                  .copyWith(color: Theme.of(context).primaryColor),
              maxLines: 1,
            ),
            SizedBox(height: 10),

            //********** Les abonnés / abonnements
            //SocialNumbers(this.userProfile),
            //SizedBox(height: 20),

            //********** La description
            Text(
              (userProfile.description + ' '),
              style: TextStyle(fontSize: 15),
              textAlign: TextAlign.justify,
            ),
            SizedBox(height: 10),

            //******** Le contenu principal
            ProfileTabs(this.userProfile),
          ],
        ),
      ),

      if (!userProfile.isMainUser)
        Positioned(
          top: 120,
          left: 10,
          child: IconButton(
            icon: Icon(
              Icons.arrow_back,
              size: 24,
              color: Theme.of(context).primaryColor,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),

      // La photo de profil
      Center(
        child: ProfilePicture(this.userProfile),
      ),
    ]);
  }
}

/// *********************************************
/// Les onglets et les items du profil
/// *********************************************
class ProfileTabs extends StatefulWidget {
  final userProfile;

  ProfileTabs(this.userProfile);

  @override
  _ProfileTabsState createState() => _ProfileTabsState();
}

class _ProfileTabsState extends State<ProfileTabs> {
  int tabIndex = 0;

  void _changeTab(int newIndex) {
    setState(() {
      tabIndex = newIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> pagesList = [
      //ProfileGridTab(),
      //ProfileMusicTab(),
      //ProfileTabUserInfos(widget.userProfile),
      ProfileTabLessons(widget.userProfile),
      ProfileTabChallenge(widget.userProfile),
    ];
    // On crée les onglets à partir des données
    List<Widget> profileTabs = DATA.PROFILE_TABS.map((tab) {
      int index = DATA.PROFILE_TABS.indexOf(tab);
      // On renvoie un Inkwell pour gérer le changement d'onglet
      return Expanded(
        flex: 1,
        child: InkWell(
          onTap: () {
            _changeTab(index);
          },
          child: Container(
            // On définit la hauteur des icones ici
            height: 48,
            // ce qui montre l'onglet actif
            // @todo : changer pour mettre un point comme dans le reste de l'interface
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: index == tabIndex
                      ? Theme.of(context).primaryColor.withOpacity(0.8)
                      : Colors.white.withOpacity(0),
                  width: 2,
                ),
              ),
            ),
            // L'icone en question
            child: Image.asset(tab['icon']),
          ),
        ),
      );
    }).toList();

    Widget page = pagesList[tabIndex];

    // Le gros return
    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Theme.of(context).primaryColor.withOpacity(0.5),
          ),
        ),
      ),
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 10, top: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Les onglets
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: profileTabs,
          ),

          // Les pages
          Container(
            margin: EdgeInsets.symmetric(vertical: 25),
            child: page,
          )
        ],
      ),
    );
  }
}

/// *********************************************
/// La photo de couverture
/// *********************************************
class CoverPicture extends StatelessWidget {
  final userProfile;

  CoverPicture(this.userProfile);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 170,
      color: Colors.white,
      child: (userProfile.hasCoverPicture)
          ? Image.network(
              userProfile.coverPicture,
              fit: BoxFit.cover,
            )
          : Image.network(
              'https://bit.ly/38ajbBK',
              fit: BoxFit.cover,
            ),
    );
  }
}

/// *********************************************
/// La photo de profil
/// *********************************************
class ProfilePicture extends StatelessWidget {
  final userProfile;

  ProfilePicture(this.userProfile);

  @override
  Widget build(BuildContext context) {
    // On crée un container avec un dégradé
    // On affiche l'image si elle existe, sinon on affiche les initiales
    Widget profilePicture = Container(
      width: 140,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [
            COLORS.PROFILE_COLORS[userProfile.color].shade800,
            COLORS.PROFILE_COLORS[userProfile.color].shade300,
          ],
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
        ),
      ),
      child: userProfile.hasProfilePicture
          ? Hero(
              tag: 'profilePicture_' + userProfile.userId,
              child: CircleAvatar(
                radius: 70,
                backgroundImage: NetworkImage(userProfile.profilePicture),
              ),
            )
          : AutoSizeText(
              userProfile.username.substring(0, 1).toUpperCase(),
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 200,
                  fontWeight: FontWeight.bold),
            ),
    );

    // Ici on retourne le container principal avec les CircleAvatar imbriqués pour faire "joli" et pour les stories (surtout)
    return Container(
      // Pour mettre le milieu de l'image sur le bord haut du contenu principal
      margin: EdgeInsets.only(top: 45),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
      ),
      child: Stack(
        children: [
          // Le cercle pour les stories
          CircleAvatar(
            radius: 75,
            backgroundColor:
                (true) ? Colors.white : Theme.of(context).accentColor,
            // @todo: ajouter la condition pour les stories quand ce sera implémenté
            // Le cercle blanc pour contourer l'image
            child: CircleAvatar(
                radius: 73,
                backgroundColor: Colors.white,
                child: profilePicture),
          ),

          // Le bouton pour éditer si c'est le profil de l'utilisateur !
          if (userProfile.isMainUser)
            Positioned(
              bottom: 5,
              right: -5,
              child: EditPictureButton(),
            ),
        ],
        overflow: Overflow.visible,
      ),
    );
  }
}

/// *********************************************
/// Les abonnées, tout ça
/// *********************************************
class SocialNumbers extends StatelessWidget {
  final userProfile;

  SocialNumbers(this.userProfile);

  @override
  Widget build(BuildContext context) {
    int nbSubscribers = this.userProfile.nbSubscribers;
    int nbSubscriptions = this.userProfile.nbSubscriptions;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        // Les abonnés
        Column(
          children: [
            Text(
              nbSubscribers.toStringFormatted(),
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
            ),
            SizedBox(height: 5),
            Text(
              'Abonnés'.toUpperCase(),
              style: TextStyle(color: Colors.grey, fontSize: 14),
            )
          ],
        ),

        // Les abonnements
        Column(
          children: [
            Text(
              nbSubscriptions.toStringFormatted(),
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
            ),
            SizedBox(height: 5),
            Text(
              'Abonnements'.toUpperCase(),
              style: TextStyle(color: Colors.grey, fontSize: 14),
            )
          ],
        ),
      ],
    );
  }
}
