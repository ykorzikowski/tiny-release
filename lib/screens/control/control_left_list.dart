import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

typedef Null ItemSelectedCallback(int value);

class ControlLeftListWidget extends StatefulWidget {

  final ItemSelectedCallback onItemSelected;

  ControlLeftListWidget( this.onItemSelected );

  @override
  _ListWidgetState createState() => _ListWidgetState();
}

class _ListWidgetState extends State<ControlLeftListWidget> {

  var items = const ["People", "Vorlagen", "Aufnahmebereiche", "Layouts", "Wording"];
  var icons = const [CupertinoIcons.person_solid, CupertinoIcons.collections_solid, CupertinoIcons.photo_camera_solid, CupertinoIcons.create_solid, CupertinoIcons.tags_solid];

  @override
  Widget build(BuildContext context) {
    return
      CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: Text("Verwaltung"),),
        child:

        ListView.builder(
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
        ),);
  }
}