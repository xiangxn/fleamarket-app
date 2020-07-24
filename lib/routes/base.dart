import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BaseRoute<T extends ChangeNotifier> extends StatelessWidget {
  final Widget Function(BuildContext context, T provider, Widget child) builder;

  final T provider;

  final Widget child;

  final bool listen;

  BaseRoute({Key key, this.builder, this.provider, this.child, this.listen}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<T>(
      create: (_) => this.provider,
      child: Selector<T, T>(
        shouldRebuild: (pre, next) => listen ?? pre.hashCode != next.hashCode,
        selector: (context, provider) => provider,
        builder: builder,
        child: child ??
            Center(
              child: CircularProgressIndicator(),
            ),
      ),
    );
  }
}
