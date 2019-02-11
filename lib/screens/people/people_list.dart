import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:tiny_release/data/repo/tiny_contact_repo.dart';
import 'package:tiny_release/screens/control/control_helper.dart';
import 'package:tiny_release/util/ControlState.dart';
import 'package:flutter_pagewise/flutter_pagewise.dart';
import 'package:http/http.dart' as http;
import 'package:tiny_release/screens/people/people_preview.dart';
import 'package:tiny_release/util/BaseUtil.dart';

typedef Null ItemSelectedCallback(int value);

class PeopleListWidget extends StatefulWidget {

  final ControlScreenState _controlState;

  PeopleListWidget(this._controlState);

  @override
  _ListWidgetState createState() => _ListWidgetState(_controlState);
}

class _ListWidgetState extends State<PeopleListWidget> {
  static const int PAGE_SIZE = 10;
  final TinyContactRepo contactRepository = new TinyContactRepo();
  final ControlScreenState _controlState;
  PagewiseLoadController pageLoadController;

  _ListWidgetState(this._controlState);

  @override
  Widget build(BuildContext context) {
    pageLoadController = PagewiseLoadController(
        pageSize: PAGE_SIZE,
        pageFuture: (pageIndex) =>
            contactRepository.getAll( pageIndex * PAGE_SIZE, PAGE_SIZE )
    );

    return Scaffold(
        appBar: !BaseUtil.isLargeScreen(context) ? AppBar(
          title: Text("Verwaltung"),
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
            contactRepository.delete(entry);

            Scaffold
                .of(context)
                .showSnackBar(SnackBar(content: Text(entry.displayName + " dismissed")));
          },
          child:  ListTile(
            leading: Icon(
              Icons.person,
              color: Colors.brown[200],
            ),
            title: Text(entry.displayName),
            onTap: () {
              openPeopleDetailView( entry, context );
            },
          ),),
        Divider()
      ],
    );
  }

  void openPeopleDetailView(item, context) {
    _controlState.setToolbarButtonsOnPreview();
    _controlState.curDBO = item;

    Navigator.push(context, MaterialPageRoute(
        builder: (context) {
          return PeoplePreviewWidget( _controlState );
        }
    )
    );
    // todo
  }
}
//    return PagewiseListView(
//        pageSize: 10,
//        padding: EdgeInsets.all(15.0),
//        itemBuilder: (context, entry, index) {
//          return Column(
//            children: <Widget>[
//              ListTile(
//                leading: Icon(
//                  Icons.person,
//                  color: Colors.brown[200],
//                ),
//                title: Text(entry.title),
//                subtitle: Text(entry.body),
//              ),
//              Divider()
//            ],
//          );
////          return ListTile(
//////                title: Text(entry.displayName),
////            title: Text("BLIJAD"),
////          );
//          // return a widget that displays the entry's data
//        },
//        pageFuture: (pageIndex) {
//          BackendService.getPosts(pageIndex * 10, 10);
////          return contactRepository.getContacts(type, pageIndex);
//          // return a Future that resolves to a list containing the page's data
//        },
//        noItemsFoundBuilder: (context) {
//          return Text('No Items Found');
//        }
//    );
//  }

class BackendService {
  static Future<List<PostModel>> getPosts(offset, limit) async {
    final responseBody = (await http.get(
        'http://jsonplaceholder.typicode.com/posts?_start=$offset&_limit=$limit'))
        .body;

    // The response body is an array of items
    return PostModel.fromJsonList(json.decode(responseBody));
  }

  static Future<List<ImageModel>> getImages(offset, limit) async {
    final responseBody = (await http.get(
        'http://jsonplaceholder.typicode.com/photos?_start=$offset&_limit=$limit'))
        .body;

    // The response body is an array of items.
    return ImageModel.fromJsonList(json.decode(responseBody));
  }
}
class PostModel {
  String title;
  String body;

  PostModel.fromJson(obj) {
    this.title = obj['title'];
    this.body = obj['body'];
  }

  static List<PostModel> fromJsonList(jsonList) {
    return jsonList.map<PostModel>((obj) => PostModel.fromJson(obj)).toList();
  }
}

class ImageModel {
  String title;
  String id;
  String thumbnailUrl;

  ImageModel.fromJson(obj) {
    this.title = obj['title'];
    this.id = obj['id'].toString();
    this.thumbnailUrl = obj['thumbnailUrl'];
  }

  static List<ImageModel> fromJsonList(jsonList) {
    return jsonList.map<ImageModel>((obj) => ImageModel.fromJson(obj)).toList();
  }
}