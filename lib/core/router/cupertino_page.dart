import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';

Page<T> buildCupertinoPage<T extends Object?>(
  GoRouterState state,
  Widget child, {
  bool fullscreenDialog = false,
}) {
  return CupertinoPage<T>(
    key: state.pageKey,
    name: state.name ?? state.path,
    restorationId: state.pageKey.value,
    fullscreenDialog: fullscreenDialog,
    child: child,
  );
}
