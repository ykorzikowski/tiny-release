import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tiny_release/generated/i18n.dart';
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

  var icons = const [CupertinoIcons.person_solid, CupertinoIcons.collections_solid, CupertinoIcons.photo_camera_solid, CupertinoIcons.create_solid, CupertinoIcons.tags_solid, CupertinoIcons.settings_solid];

  bool _isSelected(int pos) {
    return BaseUtil.isLargeScreen(context) && pos == widget.controlState.selectedControlItem;
  }

  @override
  Widget build(BuildContext context) {
    var items =  [S.of(context).item_people, S.of(context).item_preset, S.of(context).item_reception, S.of(context).item_layout, S.of(context).item_wording, S.of(context).item_settings];

    widget.controlState.inControlWidget = true;
    return
      CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          heroTag: 'control',
          transitionBetweenRoutes: false,
          middle: Text(S.of(context).control),
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
                key: Key("control_$position"),
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