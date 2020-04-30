import 'package:fleamarket/src/common/style.dart';
import 'package:fleamarket/src/models/ext_locale.dart';
import 'package:fleamarket/src/view_models/try_reviewer_view_model.dart';
import 'package:fleamarket/src/views/base_view.dart';
import 'package:fleamarket/src/widgets/custom_button.dart';
import 'package:flutter/material.dart';

class TryReviewer extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return BaseView<TryReviewerViewModel>(
      listen: true,
      model: TryReviewerViewModel(context),
      builder: (_, model, loading){
        ExtLocale locale = model.locale;
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            centerTitle: true,
            title: Text(locale.translation('title.try_reviewer')),
            backgroundColor: Style.headerBackgroundColor,
            brightness: Brightness.light,
            textTheme: Style.headerTextTheme,
            iconTheme: Style.headerIconTheme,
          ),
          body: model.busy ? loading : 
          Column(
            children: <Widget>[
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(left: 10, top: 10, right: 10),
                  child: SingleChildScrollView(
                    physics: ClampingScrollPhysics(),
                    child: Text(model.terms, 
                      style: TextStyle(
                        color: Colors.grey[800],
                        fontSize: 16
                      )
                    )
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Checkbox(
                    value: model.isAgree, 
                    onChanged: model.agree
                  ),
                  Text(locale.translation('text.agree_terms'), 
                    style: TextStyle(
                      color: Colors.grey[800]
                    )
                  )
                ],
              ),
              Container(
                width: double.infinity,
                child: CustomButton(
                  onTap: model.submit, 
                  margin: EdgeInsets.only(left: 10, bottom: 10, right: 10),
                  padding: EdgeInsets.all(16),
                  text: locale.translation('controller.try_reviewer')
                ),
              )
            ],
          ),
        );
      },
    );
  }

}