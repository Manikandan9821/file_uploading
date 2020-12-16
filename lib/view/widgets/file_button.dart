import 'package:flutter/material.dart';

class FileButton extends StatelessWidget {
  final String title;
  final IconData iconData;
  final Color color;
  final Function onPressed;

  const FileButton(
      {Key key, this.title, this.iconData, this.color, this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RaisedButton.icon(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      elevation: 0.5,
      label: Text(
        title,
        style: TextStyle(color: Colors.white, fontSize: 20.0),
      ),
      color: color,
      icon: Icon(
        iconData,
        color: Colors.white,
      ),
      onPressed: onPressed,
    );
  }
}
