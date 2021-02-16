import 'package:FaBemol/data/models/musicKey.dart';
import 'package:FaBemol/data/models/musicNote.dart';
import 'package:FaBemol/data/models/musicStaff.dart';
import 'package:flutter/material.dart';

class StaffWidget extends StatelessWidget {
  final dynamic media;

  StaffWidget({this.media});

  @override
  Widget build(BuildContext context) {
    List<MusicNote> notesList = [];
    MusicKey key;
    MusicStaff staff;

    if (media['key'] != null) {
      var keyObject = media['key'];
      key = MusicKey(
        keyType: keyObject['type'] != null ? keyObject['type'] : 'G',
        line: keyObject['line'] != null ? keyObject['line'] : 0,
        color: keyObject['color'] != null ? keyObject['color'] : Colors.black,
      );
    }

    if (media['notes'] != null) {
      media['notes'].forEach((note) {
        notesList.add(MusicNote(
          height: note['height'] != null ? note['height'].toDouble() : 3.toDouble(),
          duration: note['duration'] != null ? note['duration'].toDouble() : 4.toDouble(),
        ));
      });
    }
    // Pour que ce soit assez gros de base
    double scale = media['scale'] != null ? media['scale']*1.2 : 1.2;

    staff = new MusicStaff(
      key: key,
      notes: notesList,
      scale: scale,
    );

    staff.setClickable();

    return Center(
      child: Container(
        // Un calcul complexe pour que ce soit plus ou moins centré !
        padding: EdgeInsets.only(bottom: 40*scale*2),
        //alignment: Alignment.center,
        child: staff.render(),
      ),
    );
  }
}
