import 'package:flutter/material.dart';

import 'package:attendances/blocs/bloc_provider/bloc_base.dart';

class BlocProvider<T extends BlocBase> extends StatefulWidget {
  final T bloc;
  final Widget child;

  BlocProvider({
    Key key,
    @required this.bloc,
    @required this.child
  }): super(key: key);

  @override
  State<StatefulWidget> createState() => _BlocProviderState();

  static T of<T extends BlocBase>(BuildContext context) {
    final type = _typeOf<BlocProvider<T>>();
    BlocProvider<T> provider = context.ancestorWidgetOfExactType(type);
    return provider.bloc;
  }

  static _typeOf<T>() => T;

}

class _BlocProviderState extends State<BlocProvider<BlocBase>> {
  @override
  Widget build(BuildContext context) {
    return widget.child;
  }


  @override
  void initState() {
    super.initState();
    widget.bloc.initState();
  }

  @override
  void dispose() {
    widget.bloc.dispose();
    super.dispose();
  }

}