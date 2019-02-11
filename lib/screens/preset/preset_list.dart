
import 'package:flutter/material.dart';
import 'package:tiny_release/data/repo/tiny_preset_repo.dart';
import 'package:tiny_release/screens/control/control_helper.dart';
import 'package:tiny_release/screens/preset/preset_preview.dart';
import 'package:tiny_release/util/ControlState.dart';
import 'package:flutter_pagewise/flutter_pagewise.dart';
import 'package:tiny_release/screens/people/people_preview.dart';
import 'package:tiny_release/util/BaseUtil.dart';

typedef Null ItemSelectedCallback(int value);

class PresetListWidget extends StatefulWidget {

  final ControlScreenState _controlState;

  PresetListWidget(this._controlState);

  @override
  _PresetListWidgetState createState() => _PresetListWidgetState(_controlState);
}

class _PresetListWidgetState extends State<PresetListWidget> {
  static const int PAGE_SIZE = 10;
  final TinyPresetRepo tinyPresetRepo = new TinyPresetRepo();
  final ControlScreenState _controlState;
  PagewiseLoadController pageLoadController;

  _PresetListWidgetState(this._controlState);

  @override
  Widget build(BuildContext context) {
    pageLoadController = PagewiseLoadController(
        pageSize: PAGE_SIZE,
        pageFuture: (pageIndex) =>
            tinyPresetRepo.getAll( pageIndex * PAGE_SIZE, PAGE_SIZE )
    );

    return Scaffold(
        appBar: !BaseUtil.isLargeScreen(context) ? AppBar(
          title: Text("Vorlagen"),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.add),
              tooltip: 'Add new',
              onPressed: () {
                ControlHelper.handleAddButton(_controlState, Navigator.of(context));
              },
            )
          ],
        ): null,
        body: PagewiseListView(
          itemBuilder: this._itemBuilder,
          pageLoadController: this.pageLoadController,
        ) );
  }

  Widget _itemBuilder(context, entry, _) {
    return Column(
      children: <Widget>[
        Dismissible(
            background: Container(color: Colors.red),
            key: Key(entry.displayName),
            onDismissed: (direction) {
              tinyPresetRepo.delete(entry);

              Scaffold
                  .of(context)
                  .showSnackBar(SnackBar(content: Text(entry.displayName + " dismissed")));
            },
            child: ListTile(
              leading: Icon(
                Icons.person,
                color: Colors.brown[200],
              ),
              title: Text(entry.displayName),
              onTap: () {
                openDetailView( entry, context );
              },
            ),),
        Divider()
      ],
    );
  }

  void openDetailView(item, context) {
    _controlState.setToolbarButtonsOnPreview();
    _controlState.curDBO = item;

    Navigator.push(context, MaterialPageRoute(
        builder: (context) {
          return PresetPreviewWidget( _controlState );
        }
    )
    );
    // todo
  }
}