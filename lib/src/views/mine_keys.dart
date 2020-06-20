import 'package:eosdart_ecc/eosdart_ecc.dart';
import 'package:fleamarket/src/common/ext_dialog.dart';
import 'package:fleamarket/src/common/profile.dart';
import 'package:fleamarket/src/common/style.dart';
import 'package:fleamarket/src/models/ext_locale.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class MineKeys extends StatelessWidget{

  Widget _buildCard(BuildContext context, ExtLocale locale, String title, String keyName){
    EOSPrivateKey key = EOSPrivateKey.fromRandom();
    String pubKey = key.toEOSPublicKey().toString();
    return InkWell(
      onTap: (){
        Clipboard.setData(ClipboardData(text: pubKey));
        ExtDialog.toast(context, locale.translation('controller.copy_pubkey', [title]));
      },
      child: Card(
        elevation: 0,
        margin: EdgeInsets.only(left: 16, top: 16, right: 16),
        child: Container(
          padding: EdgeInsets.all(8),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(title),
              Text(
                pubKey,
                style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 13
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ExtLocale locale = Provider.of<ExtLocale>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(locale.translation('title.my_keys')),
        backgroundColor: Style.headerBackgroundColor,
        brightness: Brightness.light,
        textTheme: Style.headerTextTheme,
        iconTheme: Style.headerIconTheme,
      ),
      body: Column(
        children: <Widget>[
          _buildCard(context, locale, 'Owner Public Key', KEY_OWNER),
          _buildCard(context, locale, 'Active Public Key', KEY_ACTIVE),
          _buildCard(context, locale, 'Auth Public Key', KEY_AUTH),
        ],
      ),
    );
  }

}