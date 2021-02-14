import 'dart:io';

import 'package:FaBemol/functions/rounded_modal_bottom_sheet.dart';
import 'package:FaBemol/functions/localization.dart';
import 'package:FaBemol/providers/user_profile.dart';
import 'package:FaBemol/widgets/container_flat_design.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class EditPictureButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black54,
        borderRadius: BorderRadius.circular(150),
      ),
      child: IconButton(
        icon: Icon(
          Icons.edit,
          size: 24,
        ),
        color: Colors.white,
        //@todo : ajouter une action au bouton
        onPressed: () {
          showRoundedMBS(
            context: context,
            child: EditPictureBottomSheet(),
          );
        },
      ),
    );
  }
}

class EditPictureBottomSheet extends StatelessWidget {
  /// *********************************************
  /// Permet de sélectionner l'image à uploader
  /// *********************************************
  void _pickImage(
      String pictureType, BuildContext context, ImageSource source) async {
    // Initialisation du picker
    final picker = ImagePicker();
    // On récup l'image avec les bons arguments, et en qualité bof
    final pickedImage = await picker.getImage(
      source: source,
      imageQuality: 50,
      maxWidth: pictureType == 'profilePicture' ? 250 : 800,
      preferredCameraDevice: pictureType == 'profilePicture'
          ? CameraDevice.front
          : CameraDevice.rear,
    );

    // Si l'utilisateur a effectivement envoyé une image
    if (pickedImage != null) {
      final pickedImageFile = File(pickedImage.path);
      Provider.of<UserProfile>(context, listen: false)
          .changePicture(pickedImageFile, pictureType);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          //**************************************************************
          // Ici on modifie l'image de profil
          //**************************************************************
          ContainerFlatDesign(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            margin: EdgeInsets.only(bottom: 10),
            child: Column(
              children: [
                Row(
                  children: [
                    Image.asset('assets/icons/96/profile-picture.png', height: 25),
                    SizedBox(width: 3),
                    Expanded(
                      child: AutoSizeText(
                        'profile_change_profile_picture'.tr(),
                        maxLines: 1,
                        style: Theme.of(context).textTheme.headline6,
                      ),
                    ),
                  ],
                ),
                Divider(color: Theme.of(context).shadowColor,),

                //*** Les choix pour changer l'image
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                      flex: 1,
                      child: InkWell(
                        // On appelle la fonction pour la galerie
                        onTap: () {
                          _pickImage(
                              'profilePicture', context, ImageSource.gallery);
                        },
                        child: Column(
                          children: [
                            Image.asset('assets/icons/96/dossier-image.png',
                                height: 50),
                            AutoSizeText(
                              'media_from_gallery'.tr(),
                              maxLines: 1,
                              maxFontSize: 14,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: InkWell(
                        // On appelle la fonction pour l'appareil
                        onTap: () {
                          _pickImage(
                              'profilePicture', context, ImageSource.camera);
                        },
                        child: Column(
                          children: [
                            Image.asset('assets/icons/96/appareil-photo.png',
                                height: 50),
                            AutoSizeText(
                              'media_take_picture'.tr(),
                              maxLines: 1,
                              maxFontSize: 14,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),



          //**************************************************************
          // Ici on modifie l'image de couverture
          //**************************************************************

          ContainerFlatDesign(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              children: [
                Row(
                  children: [
                    Image.asset('assets/icons/96/cover-picture.png', height: 30),
                    Expanded(
                      child: AutoSizeText(
                        'profile_change_cover_picture'.tr(),
                        maxLines: 1,
                        style: Theme.of(context).textTheme.headline6,
                      ),
                    ),
                  ],
                ),
                Divider(color: Theme.of(context).shadowColor,),

                //*** Les choix pour changer l'image
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                      flex: 1,
                      child: InkWell(
                        // On appelle la fonction pour la galerie
                        onTap: () {
                          _pickImage('coverPicture', context, ImageSource.gallery);
                        },
                        child: Column(
                          children: [
                            Image.asset('assets/icons/96/dossier-image.png',
                                height: 50),
                            AutoSizeText(
                              'media_from_gallery'.tr(),
                              maxLines: 1,
                              maxFontSize: 14,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: InkWell(
                        // On appelle la fonction pour la galerie
                        onTap: () {
                          _pickImage('coverPicture', context, ImageSource.camera);
                        },
                        child: Column(
                          children: [
                            Image.asset('assets/icons/96/appareil-photo.png',
                                height: 50),
                            AutoSizeText(
                              'media_take_picture'.tr(),
                              maxLines: 1,
                              maxFontSize: 14,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
