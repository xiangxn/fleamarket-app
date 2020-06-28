import 'package:fleamarket/src/common/profile.dart';
import 'package:fleamarket/src/common/style.dart';
import 'package:fleamarket/src/common/utils.dart';
import 'package:fleamarket/src/models/ext_locale.dart';
import 'package:fleamarket/src/view_models/personal_view_model.dart';
import 'package:fleamarket/src/views/base_view.dart';
import 'package:fleamarket/src/widgets/custom_button.dart';
import 'package:fleamarket/src/widgets/custom_refresh_indicator.dart';
import 'package:fleamarket/src/widgets/ext_circle_avatar.dart';
import 'package:fleamarket/src/widgets/line_button_group.dart';
import 'package:fleamarket/src/widgets/line_button_item.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class Personal extends StatelessWidget {
  final PersonalViewModel model;

  Personal({Key key, @required this.model}) : super(key: key);

  Widget _buildChunk(String mark, int count, Function onTap) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: <Widget>[
          Text(count.toString(), style: TextStyle(fontSize: 16, color: Colors.grey[900])),
          Text(
            mark,
            style: TextStyle(color: Colors.grey[600]),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BaseView<PersonalViewModel>(
      model: model,
      builder: (_, model, __) {
        return Selector<PersonalViewModel, dynamic>(
          selector: (_, provider) => provider.currentUser,
          builder: (_, user, __) {
            ExtLocale locale = model.locale;
            return CustomRefreshIndicator(
                onRefresh: model.refreshUser,
                child: SingleChildScrollView(
                  controller: model.controller,
                  physics: ClampingScrollPhysics(),
                  child: Column(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.only(top: 20, left: 10, right: 10, bottom: 0),
                        color: Style.backgroundColor,
                        child: Row(
                          children: <Widget>[
                            GestureDetector(
                              child: ExtCircleAvatar(URL_IPFS_GATEWAY+Utils.getUserAttr(user, 'head'), 80, strokeWidth: 0),
                              onTap: model.toEdit,
                            ),
                            Expanded(
                              child: Container(
                                margin: EdgeInsets.only(left: 10),
                                alignment: Alignment.centerLeft,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text(
                                      Utils.getUserAttr(user,'nickname') ?? '-',
                                      style: TextStyle(color: Colors.grey[900], fontWeight: FontWeight.bold, fontSize: 15),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(vertical: 8),
                                      child: Row(
                                        children: <Widget>[
                                          Icon(
                                            Utils.getUserAttr(user,'isReviewer') == 0 ? FontAwesomeIcons.solidUser : FontAwesomeIcons.userTie,
                                            color: Colors.grey[700],
                                            size: 16,
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(left: 10),
                                            child: Text(
                                                Utils.getUserAttr(user,'isReviewer') == 0
                                                    ? locale.translation('personal.user_normal')
                                                    : locale.translation('personal.user_reviewer'),
                                                style: TextStyle(color: Colors.grey[900])),
                                          )
                                        ],
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: model.copy,
                                      child: RichText(
                                        text: TextSpan(
                                            text: locale.translation('personal.recommended'),
                                            style: TextStyle(color: Colors.grey[700]),
                                            children: <TextSpan>[
                                              TextSpan(
                                                text: Utils.getUserAttr(user,'eosid') ?? '0',
                                                style: TextStyle(color: Colors.black),
                                              )
                                            ]),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              alignment: Alignment.topLeft,
                              height: 80,
                              width: 30,
                              child: IconButton(
                                icon: Icon(FontAwesomeIcons.userEdit, size: 20, color: Colors.grey[700]),
                                onPressed: model.toEdit,
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                        color: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 10),
                        margin: EdgeInsets.only(bottom: 10, top: 20),
                        child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: <Widget>[
                          _buildChunk(locale.translation('personal.favorite'), Utils.getUserAttr(user,'followTotal') ?? 0, () => model.pushNamed(MINE_FAVORITE_ROUTE)),
                          _buildChunk(locale.translation('personal.focus'), Utils.getUserAttr(user,'favoriteTotal') ?? 0, () => model.pushNamed(MINE_FOCUS_ROUTE)),
                          _buildChunk(locale.translation('personal.fans'), Utils.getUserAttr(user,'fansTotal') ?? 0, () => model.pushNamed(MINE_FANS_ROUTE)),
                        ]),
                      ),
                      LineButtonGroup(children: [
                        LineButtonItem(
                            text: locale.translation('personal.mine_publish'),
                            subText: (Utils.getUserAttr(user,'postsTotal') ?? 0).toString(),
                            prefixIcon: Icons.shop,
                            onTap: () => model.pushNamed(MINE_PUBLISH_ROUTE)),
                        LineButtonItem(
                          text: locale.translation('personal.mine_buy'),
                          subText: (Utils.getUserAttr(user,'buyTotal') ?? 0).toString(),
                          prefixIcon: Icons.archive,
                          onTap: () => model.pushNamed(MINE_BUY_ROUTE),
                        ),
                        LineButtonItem(
                          text: locale.translation('personal.mine_sell'),
                          subText: (Utils.getUserAttr(user,'sellTotal') ?? 0).toString(),
                          prefixIcon: Icons.unarchive,
                          onTap: () => model.pushNamed(MINE_SELL_ROUTE),
                        ),
                        LineButtonItem(
                          text: locale.translation('personal.mine_recommended'),
                          subText: (Utils.getUserAttr(user,'referralTotal') ?? 0).toString(),
                          prefixIcon: Icons.account_box,
                          onTap: () => model.pushNamed(MINE_INVITE_ROUTE),
                        ),
                      ]),
                      LineButtonGroup(margin: EdgeInsets.only(top: 10), children: [
                        LineButtonItem(
                            text: locale.translation('personal.mine_balances'),
                            prefixIcon: Icons.monetization_on,
                            onTap: () => model.pushNamed(MINE_BALANCES_ROUTE)),
                        LineButtonItem(
                            text: locale.translation('personal.mine_keys'), prefixIcon: Icons.vpn_key, onTap: () => model.pushNamed(MINE_KEYS_ROUTE)),
                        LineButtonItem(
                          text: locale.translation('personal.mine_address'),
                          prefixIcon: Icons.location_on,
                          onTap: () => model.pushNamed(MINE_ADDRESS_ROUTE),
                        ),
                        LineButtonItem(
                          text: locale.translation('personal.mine_withdrawal'),
                          prefixIcon: Icons.call_to_action,
                          onTap: () => model.pushNamed(MINE_WITHDRAWAL_ROUTE),
                        ),
                      ]),
                      LineButtonGroup(
                        margin: EdgeInsets.only(top: 10),
                        children: <Widget>[
                          LineButtonItem(
                            text: locale.translation('title.mine_vote'),
                            prefixIcon: Icons.account_balance,
                            onTap: () => model.pushNamed(MINE_VOTE_ROUTE),
                          ),
                          Utils.getUserAttr(user,'isReviewer') == 0
                              ? LineButtonItem(
                                  text: locale.translation('personal.try_reviewer'),
                                  prefixIcon: Icons.assignment_ind,
                                  onTap: () => model.pushNamed(TRY_REVIEWER_ROUTE),
                                )
                              : LineButtonItem(
                                  text: locale.translation('personal.audit_goods'),
                                  prefixIcon: Icons.assignment,
                                  onTap: () => model.pushNamed(AUDIT_GOODS_ROUTE),
                                )
                        ],
                      ),
                      LineButtonGroup(
                        margin: EdgeInsets.only(top: 10),
                        children: [
                          LineButtonItem(text: locale.translation('personal.version'), subText: model.extSystem.version, prefixIcon: Icons.info),
                          LineButtonItem(
                              text: locale.translation('personal.about'), prefixIcon: Icons.insert_emoticon, onTap: () => model.pushNamed(ABOUT_ROUTE))
                        ],
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(10, 10, 10, 30),
                        width: double.infinity,
                        child: CustomButton(
                          text: locale.translation('personal.logout'),
                          color: Colors.red,
                          onTap: model.logout,
                          padding: EdgeInsets.symmetric(vertical: 16),
                        ),
                      )
                    ],
                  ),
                ));
          },
        );
      },
    );
  }
}
