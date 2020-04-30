import 'package:fleamarket/src/common/profile.dart';
import 'package:fleamarket/src/common/style.dart';
import 'package:fleamarket/src/models/ext_locale.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class SearchWidget extends StatefulWidget {
  SearchWidget({
    Key key,
    this.isBtn,
    this.onSubmit,
    this.onFocus,
    this.controller
  }) : super(key: key);

  final bool isBtn;
  final Function(String val) onSubmit;
  final Function(bool hasFocus) onFocus;
  final TextEditingController controller;

  @override
  _SearchWidget createState() => new _SearchWidget();
}

class _SearchWidget extends State<SearchWidget> {
  final OutlineInputBorder _otb = OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(style: BorderStyle.none),
                  gapPadding: 0.0
                );
  bool _clear = false;
  FocusNode _focusNode = FocusNode();
  TextEditingController _controller;
  ExtLocale _locale ;

  @override
  void initState() {
    super.initState();
    _locale = Provider.of<ExtLocale>(context, listen: false);
    _focusNode.addListener(_handleFocus);
    _controller = widget.controller ?? TextEditingController();
    _controller.addListener(_handleChange);
  }

  void _searchTap() {
    if (widget.isBtn) {
      FocusScope.of(context).requestFocus(FocusNode());
      Navigator.of(context).pushNamed(SEARCH_ROUTE);
    }
    
  }

  void _handleFocus(){
    if(widget.onFocus != null){
      widget.onFocus(_focusNode.hasFocus);
    }
  }

  void _handleChange() {
    setState(() {
      _clear = _controller.text.isNotEmpty;
    });
  }

  void _handleSubmit(String v) {
    if(widget.onSubmit != null){
      widget.onSubmit(v);
    }
  }

  void _handleClear(){
    /// 在未获取文本焦点的时候（软键盘关闭），清空操作同时触发了获取文本焦点，在这一帧里，
    /// 读取了原本文本长度，之后文本又被清空，所以会出现TextSelection选择越界的错误
    /// 第一种解决办法是，点击清空按钮，取消获取焦点，这种看上去并不自然
    /// 第二种方式是可以设置延时清空，这样看上去还不错，但是这类代码看上去并不严谨
    /// 第三种是在绑定一个下一帧的单次回调，注册的回调帧必定会跟在后面一帧执行，将问题的两步分开
    WidgetsBinding.instance.addPostFrameCallback( (_) => _controller.clear());
  }

  @override
  void dispose() {
    super.dispose();
    _controller.removeListener(_handleChange);
    _focusNode.removeListener(_handleFocus);
    _controller?.dispose();
    _focusNode?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'searchBar',
      child: Material(
        color: Style.backgroundColor,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: 50,
          ),
          child: TextField(
            textInputAction: TextInputAction.search,
            controller: _controller,
            focusNode: _focusNode,
            decoration: InputDecoration(
                hintText: _locale.translation('search.hint'),
                filled: true,
                fillColor: Colors.grey[200],
                contentPadding: EdgeInsets.all(0),
                focusedBorder: _otb,
                enabledBorder: _otb,
                prefixIcon: Icon(Icons.search, color: Colors.grey),
                suffixIcon: _clear
                    ? IconButton(
                        icon: Icon(
                          FontAwesomeIcons.solidTimesCircle, 
                          color: Colors.grey,
                          size: 18,
                        ),
                        onPressed: _handleClear,
                      )
                    : null),
            onTap: _searchTap,
            onSubmitted: _handleSubmit
          ),
        )
      )
    );
  }
}
