import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:paperflavor/generated/i18n.dart';
import 'package:paperflavor/util/base_util.dart';
import 'package:paperflavor/util/tiny_state.dart';

typedef Null ItemSelectedCallback(int value);

class ControlLeftListWidget extends StatefulWidget {

  final TinyState controlState;
  final ItemSelectedCallback onItemSelected;

  ControlLeftListWidget( this.onItemSelected, this.controlState );

  @override
  _ListWidgetState createState() => _ListWidgetState();
}

class _ListWidgetState extends State<ControlLeftListWidget> {
  String versionText = "";
  List items;

  var icons = const [
    CupertinoIcons.person_solid,
    CupertinoIcons.collections_solid,
    CupertinoIcons.photo_camera_solid,
    CupertinoIcons.shopping_cart
  ];

  bool _isSelected(int pos) {
    return BaseUtil.isLargeScreen(context) && pos == widget.controlState.selectedControlItem;
  }

  List _getItems(context) {
    return [S.of(context).item_people, S.of(context).item_preset, S.of(context).item_reception, S.of(context).subscription];
  }

  Widget _buildListItem(context, position) {
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
  }

   List _buildList(context) {
    var widgets = List<Widget>();

    for (var i = 0; i < items.length; i++) {
      widgets.add(_buildListItem(context, i));
    }

    return widgets;
  }

  List _getControlWidgets(context) {
    var widgets = _buildList(context);
    widgets.add(Text(versionText, style: TextStyle(color: CupertinoColors.inactiveGray),),);
    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    items = _getItems(context);
    BaseUtil.getVersionString().then((str) => setState(() => versionText = str));

    widget.controlState.inControlWidget = true;
    return
      CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          heroTag: 'control',
          transitionBetweenRoutes: false,
          middle: Text(S.of(context).control),
        ),
        child:
        SafeArea(
          child: Column(
            key: Key("control_list"),
            children: _getControlWidgets(context)
          ),
        ),);
  }
}
