import 'package:fleamarket/src/common/type_defs.dart';
import 'package:fleamarket/src/common/utils.dart';
import 'package:fleamarket/src/models/ext_page.dart';
import 'package:fleamarket/src/models/user.dart';
import 'package:fleamarket/src/view_models/user_card_group_view_model.dart';
import 'package:fleamarket/src/views/base_view.dart';
import 'package:fleamarket/src/widgets/user_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'custom_refresh_indicator.dart';

class UserCardGroup extends StatefulWidget{
  UserCardGroup({
    Key key,
    this.refresh,
    this.controller
  }): super(key: key);
  final RefreshPageCallback refresh;
  final ScrollController controller;
  @override
  State<StatefulWidget> createState() => _UserCardGroup();

}

class _UserCardGroup extends State<UserCardGroup> with AutomaticKeepAliveClientMixin{
  @override
  Widget build(BuildContext context) {
    super.build(context);
    print('build user card group');
    return BaseView<UserCardGroupViewModel>(
      model: UserCardGroupViewModel(context, widget.refresh),
      builder: (_, model, loading){
        return Selector<UserCardGroupViewModel, ExtPage<User>>(
          selector: (_, __) => model.page,
          builder: (_, page, __){
            return model.busy ? loading : CustomRefreshIndicator(
              onRefresh: () => model.fetch(isRefresh: true),
              onLoad: page.hasMore() ? model.fetch : null,
              child: ListView.builder(
                controller: widget.controller,
                physics: ClampingScrollPhysics(),
                itemCount: page.data.length,
                itemBuilder: (_, i) => Selector<UserCardGroupViewModel, User>(
                  selector: (_, __) => page.data[i],
                  builder: (_, user, __){
                    return UserCard(
                      key: Utils.randomKey(),
                      user: user,
                      updateUser: model.updateUser,
                    );     
                  },
                )
              ),
            );
          }
        );
      }
    );
  }

  @override
  bool get wantKeepAlive => true;

}