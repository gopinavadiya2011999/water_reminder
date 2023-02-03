import 'package:provider/single_child_widget.dart';
import 'package:provider/provider.dart';
import 'package:waterreminder/no_internet/connectivity_provider.dart';

List<SingleChildWidget> providers = [
  //...independentServices,
  //...dependentServices,
  ...uiConsumableProviders,
];

List<SingleChildWidget> uiConsumableProviders = [
  ChangeNotifierProvider(create: (_) => ConnectivityProvider()),
];
