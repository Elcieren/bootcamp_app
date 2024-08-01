import 'package:bootcamp_app/app/app.router.dart';
import 'package:bootcamp_app/app/app_base_view_model.dart';
import 'package:bootcamp_app/core/di/get_it.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class YemekApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        <DeviceOrientation>[DeviceOrientation.portraitUp]);
    return ViewModelBuilder<AppbaseViewModel>.reactive(
        viewModelBuilder: () => getIt<AppbaseViewModel>(),
        onViewModelReady: (viewModel) => viewModel.initialise(),
        builder: (context, viewModel, child) => MaterialApp(
              navigatorKey: StackedService.navigatorKey,
              onGenerateRoute: StackedRouter().onGenerateRoute,
              navigatorObservers: [StackedService.routeObserver],
              title: "SOFRA",
              debugShowCheckedModeBanner: false,
            ));
  }
}
