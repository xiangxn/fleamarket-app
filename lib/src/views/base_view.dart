import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BaseView<T extends ChangeNotifier> extends StatelessWidget{

  final Widget Function(BuildContext context, T model, Widget child) builder;

  final T model;

  final Widget child;

  final bool listen;

  BaseView({Key key, this.builder, this.model, this.child, this.listen}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<T>(
      create: (_) => model,
      child: Selector<T, T>(
        shouldRebuild: (pre, next) => listen ?? pre.hashCode != next.hashCode,
        selector: (context, provider) => provider,
        builder: builder,
        child: child ?? Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }

}