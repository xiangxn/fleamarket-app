import 'package:bitsflea/common/constant.dart';
import 'package:bitsflea/common/global.dart';
import 'package:bitsflea/routes/base.dart';
import 'package:bitsflea/states/base.dart';
import 'package:bitsflea/states/locale.dart';
import 'package:bitsflea/states/theme.dart';
import 'package:bitsflea/widgets/dialog_selector.dart';
import 'package:bitsflea/widgets/line_button_group.dart';
import 'package:bitsflea/widgets/line_button_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BaseRoute<SettingProvider>(
        // listen: true,
        provider: SettingProvider(context),
        builder: (ctx, provider, _) {
          final style = Provider.of<ThemeModel>(context, listen: false).theme;
          return Scaffold(
              appBar: AppBar(
                centerTitle: true,
                title: Text(provider.translate('setting.title')),
                backgroundColor: style.headerBackgroundColor,
                brightness: Brightness.light,
                textTheme: style.headerTextTheme,
                iconTheme: style.headerIconTheme,
              ),
              body: Column(children: <Widget>[
                LineButtonGroup(
                  margin: EdgeInsets.only(top: 10),
                  children: [
                    LineButtonItem(text: provider.translate('setting.version'), subText: provider.version, prefixIcon: Icons.info),
                    LineButtonItem(
                        text: provider.translate('setting.language'),
                        subText: provider.translate("setting.${provider.language}"),
                        prefixIcon: Icons.language,
                        onTap: () => provider.onSelectLang()),
                    LineButtonItem(
                        text: provider.translate('setting.theme'),
                        suffix: Icon(Icons.style, color: provider.style),
                        prefixIcon: Icons.style,
                        onTap: () => provider.onSelectStyle()),
                    // LineButtonItem(text: provider.translate('setting.about'), prefixIcon: Icons.insert_emoticon, onTap: () => provider.pushNamed(ROUTE_ABOUT))
                  ],
                )
              ]));
        });
  }
}

class SettingProvider extends BaseProvider {
  String _language;
  MaterialColor _style;

  SettingProvider(BuildContext context) : super(context) {
    final local = Provider.of<LocaleModel>(context);
    final theme = Provider.of<ThemeModel>(context, listen: false).theme;
    _language = local.locale;
    _style = theme.primarySwatch;
  }

  String get version => Global.appInfo.version;
  String get language => _language;
  MaterialColor get style => _style;

  onSelectLang() async {
    final lm = Provider.of<LocaleModel>(context, listen: false);
    Widget screen = DialogSelector(
      title: translate('setting.select_local'),
      data: [
        {translate("setting.null"): null},
        {translate("setting.zh_CN"): "zh_CN"},
        {translate("setting.en_US"): "en_US"}
      ],
    );
    Map lang = await this.showDialog(screen);
    if (lang != null) {
      _language = lang[lang.keys.first];
      await lm.setLocale(context, _language);
      // await FlutterI18n.refresh(context, lm.getLocale());
    }
  }

  onSelectStyle() async {
    final tm = Provider.of<ThemeModel>(context, listen: false);
    final screen = DialogSelector(title: translate("setting.select_theme"), data: [
      {translate("setting.red"): Colors.red},
      {translate("setting.green"): Colors.green}
    ]);
    Map styles = await this.showDialog(screen);
    if (styles != null) {
      _style = styles[styles.keys.first];
      tm.setTheme(_style[500].value);
    }
  }
}
