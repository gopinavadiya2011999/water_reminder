
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:waterreminder/no_internet/connectivity_provider.dart';

import 'network_check.dart';

class CheckNetwork extends StatelessWidget {
  final Widget child;

  const CheckNetwork({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isOnline = Provider.of<ConnectivityProvider>(context).isOnline;
    // TODO: implement build

    return !isOnline ? const InternetConnectionCheck() : child;
  }
}