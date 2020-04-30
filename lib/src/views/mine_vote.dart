import 'package:fleamarket/src/common/style.dart';
import 'package:fleamarket/src/models/ext_locale.dart';
import 'package:fleamarket/src/view_models/mine_vote_view_model.dart';
import 'package:fleamarket/src/views/base_view.dart';
import 'package:fleamarket/src/widgets/ext_circle_avatar.dart';
import 'package:flutter/material.dart';

class MineVote extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return BaseView<MineVoteViewModel>(
      listen: true,
      model: MineVoteViewModel(context),
      builder: (_, model, loading){
        ExtLocale locale = model.locale;
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            centerTitle: true,
            title: Text(locale.translation('title.mine_vote')),
            backgroundColor: Style.headerBackgroundColor,
            brightness: Brightness.light,
            textTheme: Style.headerTextTheme,
            iconTheme: Style.headerIconTheme,
          ),
          body: model.busy ? loading : 
          ListView.separated(
            physics: ClampingScrollPhysics(),
            itemCount: model.list.length,
            itemBuilder: (_, i){
              var item = model.list[i];
              return Padding(
                padding: EdgeInsets.all(8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        ExtCircleAvatar(item['head'], 40, strokeWidth: 0),
                        Padding(
                          padding: EdgeInsets.only(left: 16),
                          child: Column(
                            children: <Widget>[
                              Text(item['name']),
                              Text(locale.translation('combo_text.user_score', [item['score'].toString()]),
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey[700]
                                )
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Container(
                            width: 70,
                            child: Text(locale.translation('combo_text.vote_count', [item['vote'].toString()]),
                              style: TextStyle(
                                fontSize: 15
                              ),
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.thumb_down,
                              color: item['hasAgainst'] ? Colors.grey : Colors.red,
                            ),
                            onPressed: item['hasAgainst'] ? null : () => model.against(i),
                          ),
                          IconButton(
                            icon: Icon(Icons.thumb_up,
                              color: item['hasSupport'] ? Colors.grey : Colors.green,
                            ),
                            onPressed: item['hasSupport'] ? null : () => model.support(i),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              );
            }, 
            separatorBuilder: (_, i) => Divider(color: Colors.grey[300], height: 1), 
            
          )
        );
      },
    );
  }
}