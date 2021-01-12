import 'package:bitsflea/common/constant.dart';
import 'package:bitsflea/routes/base.dart';
import 'package:bitsflea/states/base.dart';
import 'package:bitsflea/states/theme.dart';
import 'package:bitsflea/states/user.dart';
import 'package:bitsflea/widgets/confirm_password.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:eosdart_ecc/eosdart_ecc.dart';

class UserKeysRoute extends StatelessWidget {
  Widget _buildCard(UserKeysProvider provider, String keyName) {
    final um = Provider.of<UserModel>(provider.context, listen: false);
    final style = Provider.of<ThemeModel>(provider.context, listen: false).theme;
    EOSPrivateKey priKey;
    switch (keyName) {
      case KEY_NAME_OWNER:
        priKey = um.keys[0];
        break;
      case KEY_NAME_ACTIVE:
        priKey = um.keys[1];
        break;
      case KEY_NAME_AUTH:
        priKey = um.keys[2];
        break;
      default:
        priKey = null;
        break;
    }
    String pubKey = priKey.toEOSPublicKey().toString();
    String title = provider.translate("user_keys.$keyName");
    return InkWell(
      onTap: () {
        Clipboard.setData(ClipboardData(text: pubKey));
        provider.showToast(provider.translate("controller.copy_pubkey", translationParams: {"value": title}));
      },
      child: Card(
        elevation: 0,
        margin: EdgeInsets.only(left: 16, top: 16, right: 16),
        child: Slidable(
          actionPane: SlidableDrawerActionPane(),
          actions: [
            IconSlideAction(
              caption: provider.translate("user_keys.act_copy_key"),
              color: style.primarySwatch,
              icon: Icons.copy,
              onTap: () => provider.copyPrivateKey(keyName, priKey),
            )
          ],
          child: Container(
            padding: EdgeInsets.all(8),
            color: Colors.white,
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(title),
                Text(
                  pubKey,
                  style: TextStyle(color: Colors.grey[700], fontSize: 13),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final style = Provider.of<ThemeModel>(context, listen: false).theme;
    return BaseRoute<UserKeysProvider>(
        provider: UserKeysProvider(context),
        builder: (context, provider, _) {
          return Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: Text(provider.translate('user_keys.title')),
              backgroundColor: style.headerBackgroundColor,
              brightness: Brightness.light,
              textTheme: style.headerTextTheme,
              iconTheme: style.headerIconTheme,
            ),
            body: Column(
              children: <Widget>[
                _buildCard(provider, KEY_NAME_OWNER),
                _buildCard(provider, KEY_NAME_ACTIVE),
                _buildCard(provider, KEY_NAME_AUTH),
              ],
            ),
          );
        });
  }
}

class UserKeysProvider extends BaseProvider {
  UserKeysProvider(BuildContext context) : super(context);

  Future<void> copyPrivateKey(String keyName, EOSPrivateKey priKey) async {
    final auth = await showModalBottomSheet<String>(context: context, builder: (_) => ConfirmPassword());
    if (auth != null && auth.isNotEmpty) {
      Clipboard.setData(ClipboardData(text: priKey.toString()));
      this.showToast(this.translate("controller.copy_pubkey", translationParams: {"value": keyName}));
    }
  }
}
