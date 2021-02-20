import 'package:flutter/material.dart';

class ProfileAppBar extends StatelessWidget implements PreferredSizeWidget {
  final double height;

  const ProfileAppBar({
    Key key,
    this.height = 50,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).shadowColor;

    return SafeArea(
        child: Container(
      height: height,
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(width: 1.0, color: color)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // L'icone qui ouvre le drawer
          InkWell(
            onTap: () {
              Scaffold.of(context).openEndDrawer();
            },
            child: Icon(
              Icons.settings,
              size: 30,
            ),
          ),
        ],
      ),
    ));
  }

  @override
  Size get preferredSize => Size.fromHeight(height);
}
