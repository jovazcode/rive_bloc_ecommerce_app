import 'package:flutter/material.dart';
import 'package:ecommerce_app/src/app_bootstrap_fakes.dart';
import 'package:ecommerce_app/src/app_bootstrap.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// ignore:depend_on_referenced_packages
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:ecommerce_app/src/exceptions/async_error_logger.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // turn off the # in the URLs on the web
  usePathUrlStrategy();
  // create an app bootstrap instance
  final appBootstrap = AppBootstrap();
  // Set BlocObserver to log errors
  Bloc.observer = AsyncErrorLogger();
  // create a list with all the "fake" repositories
  final fakeProviders = await createFakeProvidersList();
  // use the container above to create the root widget
  final root = appBootstrap.createRootWidget(overrides: fakeProviders);
  // start the app
  runApp(root);
}
