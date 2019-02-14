import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tiny_release/util/BaseUtil.dart';
import 'package:tiny_release/util/tiny_state.dart';

typedef Null ItemSelectedCallback(int value);

class ControlLeftListWidget extends StatefulWidget {

  final TinyState controlState;
  final ItemSelectedCallback onItemSelected;

  ControlLeftListWidget( this.onItemSelected, this.controlState );

  @override
  _ListWidgetState createState() => _ListWidgetState();
}

class _ListWidgetState extends State<ControlLeftListWidget> {

  var items = const ["People", "Vorlagen", "Aufnahmebereiche", "Layouts", "Wording"];
  var icons = const [CupertinoIcons.person_solid, CupertinoIcons.collections_solid, CupertinoIcons.photo_camera_solid, CupertinoIcons.create_solid, CupertinoIcons.tags_solid];

  bool _isSelected(int pos) {
    return BaseUtil.isLargeScreen(context) && pos == widget.controlState.selectedControlItem;
  }

  @override
  Widget build(BuildContext context) {
    return
      CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: Text("Verwaltung"),
        ),
        child:
        ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          itemCount: items.length,
          itemBuilder: (context, position) {
            return Container(
              decoration: new BoxDecoration (
                  color: _isSelected(position)
                      ? Colors.lightBlue
                      : Colors.transparent,
              ),
              child: ListTile(
                onTap: () {
                  widget.onItemSelected(position);
                },
                leading: Icon(icons[position]),
                title: Text(items[position],
                  style: TextStyle(
                    color: _isSelected(position)
                        ? Colors.white
                        : Colors.black,
                  ),),
              ),);
          },
        ),);
  }
}