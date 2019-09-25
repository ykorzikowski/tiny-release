import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:paperflavor/dialogs/allow_reporting_dialog.dart';
import 'package:paperflavor/generated/i18n.dart';
import 'package:paperflavor/util/base_util.dart';
import 'package:paperflavor/util/prefs.dart';
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
  String errorReportingText = "";
  List items;

  var icons = const [
    CupertinoIcons.person_solid,
    CupertinoIcons.collections_solid,
    CupertinoIcons.photo_camera_solid,
    CupertinoIcons.shopping_cart,
    CupertinoIcons.clear_circled_solid,
    CupertinoIcons.book_solid,
    CupertinoIcons.eye_solid
  ];

  bool _isSelected(int pos) {
    return BaseUtil.isLargeScreen(context) && pos == widget.controlState.selectedControlItem;
  }

  List _getItems(context) {
    return [S.of(context).item_people, S.of(context).item_preset, S.of(context).item_reception, S.of(context).subscription, S.of(context).error_reporting, S.of(context).show_license_info, "Provocate Error"];
  }

  Widget _buildListItem(context, position, onTap) {
    return Container(
      decoration: new BoxDecoration (
        color: _isSelected(position)
            ? Colors.lightBlue
            : Colors.transparent,
      ),
      child: ListTile(
        key: Key("control_$position"),
        onTap: () => onTap(context, position),
        leading: Icon(icons[position]),
        title: Text(items[position],
          style: TextStyle(
            color: _isSelected(position)
                ? Colors.white
                : Colors.black,
          ),),
      ),);
  }

  _onItemSelectedCallback(context, pos) {
    widget.onItemSelected(pos);
  }

  _provocateError(context, pos) {
    throw Exception("Provocated Exception for Testing!");
  }

  _openTrackingPopup(context, pos) {
    showCupertinoModalPopup(context: context, builder: AllowReportingDialog().buildDialog);
  }

  _openAboutDialog(context, pos) {
    BaseUtil.getVersionString().then((versionStr) {
      showAboutDialog(
          context: context,
          applicationLegalese: "(c) 2019 Yannik Korzikowski",
          applicationVersion: versionStr,
          applicationIcon: Image.asset('assets/icon/icon.png', height: 48.0,));
    });

  }

   List _buildList(context) {
    var widgets = List<Widget>();

    widgets.add(_buildListItem(context, 0, _onItemSelectedCallback));
    widgets.add(_buildListItem(context, 1, _onItemSelectedCallback));
    widgets.add(_buildListItem(context, 2, _onItemSelectedCallback));
    widgets.add(_buildListItem(context, 3, _onItemSelectedCallback));
    widgets.add(_buildListItem(context, 4, _openTrackingPopup));
    widgets.add(_buildListItem(context, 5, _openAboutDialog));
    if(Prefs.isInDebugMode) widgets.add(_buildListItem(context, 6, _provocateError));

    return widgets;
  }

  List _getControlWidgets(context) {
    var widgets = _buildList(context);
    widgets.add(Text("current version is $versionText", style: TextStyle(color: CupertinoColors.inactiveGray),),);
    widgets.add(Text("error reporting is $errorReportingText", style: TextStyle(color: CupertinoColors.inactiveGray),),);
    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    items = _getItems(context);
    BaseUtil.getVersionString().then((str) => setState(() => versionText = str));
    Prefs.errorReportingIsAllowed.then((allowed) => allowed ? errorReportingText = "allowed" : errorReportingText = "not allowed");

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
