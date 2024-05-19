import 'package:client_tools/client_tools.dart';
import 'package:flutter/material.dart';

class Loader extends StatefulWidget {
  const Loader({required this.onPresented, super.key});

  final void Function() onPresented;

  @override
  State<Loader> createState() => _LoaderState();
}

class _LoaderState extends State<Loader> {
  @override
  void initState() {
    super.initState();
    widget.onPresented();
  }

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(Spacing.l),
      child: Center(child: CircularProgressIndicator()),
    );
  }
}
