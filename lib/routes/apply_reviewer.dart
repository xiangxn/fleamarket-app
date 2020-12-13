import 'package:bitsflea/common/funs.dart';
import 'package:bitsflea/common/global.dart';
import 'package:bitsflea/routes/base.dart';
import 'package:bitsflea/states/base.dart';
import 'package:bitsflea/states/theme.dart';
import 'package:bitsflea/states/user.dart';
import 'package:bitsflea/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_html/flutter_html.dart';

class ApplyReviewerRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BaseRoute<ApplyReviewerProvider>(
      listen: true,
      provider: ApplyReviewerProvider(context),
      builder: (_, model, loading) {
        final style = Provider.of<ThemeModel>(context, listen: false).theme;
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            centerTitle: true,
            title: Text(model.translate('apply_reviewer.title')),
            backgroundColor: style.headerBackgroundColor,
            brightness: Brightness.light,
            textTheme: style.headerTextTheme,
            iconTheme: style.headerIconTheme,
          ),
          body: model.busy
              ? loading
              : Column(
                  children: <Widget>[
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(left: 10, top: 10, right: 10),
                        child: SingleChildScrollView(physics: ClampingScrollPhysics(), child: Html(data: model.terms)),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Checkbox(value: model.isAgree, onChanged: model.agree),
                        Text(model.translate('apply_reviewer.agree_terms'), style: TextStyle(color: Colors.grey[800]))
                      ],
                    ),
                    Container(
                      width: double.infinity,
                      child: CustomButton(
                          onTap: model.submit,
                          margin: EdgeInsets.only(left: 10, bottom: 10, right: 10),
                          padding: EdgeInsets.all(16),
                          text: model.translate('controller.apply_reviewer')),
                    )
                  ],
                ),
        );
      },
    );
  }
}

const CACHE_KEY_CONVENTION = "Convention";

class ApplyReviewerProvider extends BaseProvider {
  ApplyReviewerProvider(BuildContext context) : super(context) {
    fetchTerms();
  }

  String _terms = "<html></html>";
  bool _isAgree = false;

  String get terms => _terms;
  bool get isAgree => _isAgree;

  agree(bool val) {
    _isAgree = val;
    notifyListeners();
  }

  fetchTerms() async {
    _terms = Global.getCache(CACHE_KEY_CONVENTION, minutes: 1440);
    if (_terms == null || _terms.isEmpty) {
      _terms = await api.getConvention();
      if (_terms != null && _terms.isNotEmpty) {
        Global.setCache(CACHE_KEY_CONVENTION, _terms, dt: DateTime.now());
      }
    }
    notifyListeners();
  }

  submit() async {
    if (!_isAgree) {
      showToast(translate('message.agree_terms'));
    } else {
      final um = Provider.of<UserModel>(context, listen: false);
      if (um.user.isReviewer) return;
      showLoading();
      final res = await api.appReviewer(um.keys[1], um.user.userid, um.user.eosid);
      closeLoading();
      if (res.code == 0) {
        pop();
      } else if (res.code == 500) {
        showToast(getErrorMessage(res.msg));
      } else {
        showToast(this.translate("message.request_error"));
      }
    }
  }
}
