import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


/// Workaround for https://github.com/flutter/flutter/issues/20130
class TinyPageWrapper<T> extends PageRouteBuilder<T> {

  @override
  final Duration transitionDuration;

  @override
  bool opaque;

  TinyPageWrapper({
    @required WidgetBuilder builder,
    RouteSettings settings,
    String title,
    bool maintainState = true,
    bool fullscreenDialog = false,
    this.opaque = false,
    this.transitionDuration,
  }) : super(
//            title: title,
            pageBuilder: (context, anim1, anim2) => builder(context),
            maintainState: maintainState,
            settings: settings,
//            fullscreenDialog: fullscreenDialog
  );
}
