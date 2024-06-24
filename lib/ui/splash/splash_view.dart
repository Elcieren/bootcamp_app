import 'package:bootcamp_app/ui/splash/splash_view_model.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class SplashView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SplashViewModel>.reactive(
        viewModelBuilder: () => SplashViewModel(),
        onViewModelReady: (viewModel) => viewModel.init(),
        builder: (context, viewModel, child) => Scaffold(
              backgroundColor: Colors.orange,
              body: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/food.png'),
                  Center(
                    child: Text(
                      "YemekBuradaa",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 48,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ));
  }
}
