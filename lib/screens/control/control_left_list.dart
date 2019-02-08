import 'package:flutter/material.dart';

typedef Null ItemSelectedCallback(int value);

class ControlLeftListWidget extends StatefulWidget {

  final ItemSelectedCallback onItemSelected;

  ControlLeftListWidget( this.onItemSelected );

  @override
  _ListWidgetState createState() => _ListWidgetState();
}

class _ListWidgetState extends State<ControlLeftListWidget> {

  var items = const ["Models", "Fotografen", "Zeugen", "Erziehungsberechtigte", "Vorlagen", "Aufnahmebereiche", "Layouts", "Wording"];
  var icons = const [Icons.person_pin, Icons.person_pin, Icons.person_pin, Icons.wallpaper, Icons.camera, Icons.camera, Icons.layers, Icons.speaker_notes];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, position) {
        return ListTile(
          onTap: () {
            widget.onItemSelected(position);
          },
          leading: Icon(icons[position]),
          title: Text(items[position]),
        );
      },
    );
  }
}