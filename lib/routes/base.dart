import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BaseRoute<T extends ChangeNotifier> extends StatelessWidget {
  final Widget Function(BuildContext context, T provider, Widget child) builder;

  final T provider;

  final Widget child;

  final bool listen;

  BaseRoute({Key key, this.builder, this.provider, this.child, this.listen = false}) : super(key: key);

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

class BaseWidget<T extends ChangeNotifier> extends StatefulWidget {
  final Widget Function(BuildContext context, T model, Widget child) builder;
  final T model;
  final Widget child;

  BaseWidget({
    Key key,
    this.builder,
    this.model,
    this.child,
  }) : super(key: key);

  _BaseWidgetState<T> createState() => _BaseWidgetState<T>();
}

class _BaseWidgetState<T extends ChangeNotifier> extends State<BaseWidget<T>> {
  T model;

  @override
  void initState() {
    model = widget.model;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<T>(
      create: (BuildContext context) => model,
      child: Consumer<T>(
        builder: widget.builder,
        child: widget.child,
      ),
    );
  }
}

class BaseWidget2<T extends ChangeNotifier, S> extends StatefulWidget {
  final Widget Function(BuildContext context, T model, S sModel, Widget child) builder;

  final T model;

  final Widget child;

  final S Function(T) getSmallModel;

  BaseWidget2({Key key, @required this.builder, @required this.model, @required this.getSmallModel, this.child})
      : assert(builder != null),
        assert(model != null),
        assert(getSmallModel != null),
        super(key: key);

  bool shouldRebuild(S prev, S next) {
    return prev.hashCode != next.hashCode;
  }

  @override
  _BaseWidgetState2<T, S> createState() => _BaseWidgetState2<T, S>();
}

class _BaseWidgetState2<T extends ChangeNotifier, S> extends State<BaseWidget2<T, S>> {
  T model;

  @override
  void initState() {
    model = widget.model;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<T>.value(
      value: model,
      child: Selector<T, S>(
        shouldRebuild: (prev, next) => this.widget.shouldRebuild(prev, next),
        selector: (BuildContext context, T model) => this.widget.getSmallModel(model),
        builder: (BuildContext context, S sModel, Widget child) {
          return this.widget.builder(context, this.model, sModel, child);
        },
        child: this.widget.child ?? Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
