import 'package:flutter/material.dart';
import 'package:of9_task_manager/providers/auth_provider.dart';
import 'package:of9_task_manager/providers/network_provider.dart';
import 'package:of9_task_manager/providers/task_provider.dart';
import 'package:provider/provider.dart';

import 'app.dart';
import 'data/services/api_caller.dart';

void main() {

  final AuthProvider authProvider = AuthProvider();
  ApiCaller.init(tokenSource: authProvider);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>.value(value: authProvider),
        ChangeNotifierProvider(create: (_) => NetworkProvider()),
        ChangeNotifierProvider(create: (_) => TaskProvider()),
      ],
      child: const TaskManagerApp(),
    )
  );
}

