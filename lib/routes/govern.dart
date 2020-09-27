import 'package:bitsflea/common/constant.dart';
import 'package:bitsflea/routes/base.dart';
import 'package:bitsflea/states/base.dart';
import 'package:bitsflea/states/theme.dart';
import 'package:bitsflea/widgets/line_button_group.dart';
import 'package:bitsflea/widgets/line_button_item.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class GovernRoute extends StatelessWidget {
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
              body: Column(children: <Widget>[
                LineButtonGroup(
                  margin: EdgeInsets.only(top: 10),
                  children: [
                    LineButtonItem(
                        text: provider.translate('govern.vote_reviewer'),
                        prefixIcon: FontAwesomeIcons.voteYea,
                        prefixIconSize: 18,
                        prefixPadding: 18,
                        onTap: () => provider.pushNamed(ROUTE_REVIEWER_LIST)),
                    LineButtonItem(
                        text: provider.translate('govern.audit_product'),
                        prefixIconSize: 20,
                        prefixPadding: 17,
                        prefixIcon: FontAwesomeIcons.bookReader,
                        onTap: () => null),
                    LineButtonItem(
                        text: provider.translate('govern.proposal'),
                        prefixIconSize: 20,
                        prefixPadding: 17,
                        prefixIcon: FontAwesomeIcons.listAlt,
                        onTap: () => null)
                  ],
                )
              ]));
        });
  }
}

class GovernProvider extends BaseProvider {
  GovernProvider(BuildContext context) : super(context);
}
