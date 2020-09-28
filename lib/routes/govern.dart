import 'package:bitsflea/common/constant.dart';
import 'package:bitsflea/routes/base.dart';
import 'package:bitsflea/states/base.dart';
import 'package:bitsflea/states/theme.dart';
import 'package:bitsflea/states/user.dart';
import 'package:bitsflea/widgets/line_button_group.dart';
import 'package:bitsflea/widgets/line_button_item.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class GovernRoute extends StatelessWidget {
  List<Widget> _buildItems(GovernProvider provider) {
    List<Widget> items = <Widget>[
      LineButtonItem(
          text: provider.translate('govern.vote_reviewer'),
          prefixIcon: FontAwesomeIcons.voteYea,
          prefixIconSize: 18,
          prefixPadding: 18,
          onTap: () => provider.pushNamed(ROUTE_REVIEWER_LIST)),
      LineButtonItem(
          text: provider.translate('govern.proposal'), prefixIconSize: 20, prefixPadding: 17, prefixIcon: FontAwesomeIcons.listAlt, onTap: () => null)
    ];
    if (provider.isReviewer()) {
      items.add(LineButtonItem(
          text: provider.translate('govern.audit_product'),
          prefixIconSize: 20,
          prefixPadding: 17,
          prefixIcon: FontAwesomeIcons.bookReader,
          onTap: () => provider.pushNamed(ROUTE_PRODUCT_REVIEW_LIST)));
    }
    return items;
  }

  @override
  Widget build(BuildContext context) {
    return BaseRoute<GovernProvider>(
        // listen: true,
        provider: GovernProvider(context),
        builder: (ctx, provider, _) {
          final style = Provider.of<ThemeModel>(context, listen: false).theme;
          return Scaffold(
              appBar: AppBar(
                centerTitle: true,
                title: Text(provider.translate('govern.title')),
                backgroundColor: style.headerBackgroundColor,
                brightness: Brightness.light,
                textTheme: style.headerTextTheme,
                iconTheme: style.headerIconTheme,
              ),
              body: Column(children: <Widget>[LineButtonGroup(margin: EdgeInsets.only(top: 10), children: _buildItems(provider))]));
        });
  }
}

class GovernProvider extends BaseProvider {
  GovernProvider(BuildContext context) : super(context);

  bool isReviewer() {
    final user = Provider.of<UserModel>(context, listen: false).user;
    return user.isReviewer;
  }
}
