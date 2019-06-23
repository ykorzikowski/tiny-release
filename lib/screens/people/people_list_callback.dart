import 'package:flutter/cupertino.dart';
import 'package:paperflavor/data/repo/tiny_people_repo.dart';
import 'package:paperflavor/data/tiny_people.dart';
import 'package:paperflavor/screens/people/people_list.dart';
import 'package:paperflavor/util/nav_routes.dart';
import 'package:paperflavor/util/tiny_state.dart';

class PeopleListCallback {

  final TinyState _controlState;
  final TinyPeopleRepo _tinyPeopleRepo = new TinyPeopleRepo();

  PeopleListCallback( this._controlState );

  /// called by list to get people
  /// getPeople(pageIndex)
  Future<List<TinyPeople>> getPeople(pageIndex) async {
    return _tinyPeopleRepo.getAll(
        pageIndex * PeopleListWidget.PAGE_SIZE,
        PeopleListWidget.PAGE_SIZE);
  }

  void onPeopleTap(item, context) {
    _controlState.curDBO = item;

    Navigator.of(context).pushNamed(NavRoutes.PEOPLE_PREVIEW);
  }
}
