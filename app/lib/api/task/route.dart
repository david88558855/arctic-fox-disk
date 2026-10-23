import 'package:flutter/material.dart';

import 'package:arctic_fox_disk/app/router.dart';

import "pages/task_list.dart";

Future<void> init(CustomRouter router) async {
  router.registerMany({
    '/task/list': (context) {
      return TaskListScreen.fromRoute(ModalRoute.of(context));
    },
  });
}
