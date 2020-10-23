import 'package:bitsflea/common/location_data.dart';
import 'package:bitsflea/grpc/bitsflea.pb.dart';
import 'package:bitsflea/routes/base.dart';
import 'package:bitsflea/states/base.dart';
import 'package:bitsflea/states/theme.dart';
import 'package:bitsflea/states/user.dart';
import 'package:bitsflea/widgets/address_selector.dart';
import 'package:bitsflea/widgets/line_button_group.dart';
import 'package:bitsflea/widgets/line_button_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class UserAddressEditRoute extends StatelessWidget {
  UserAddressEditRoute({Key key, @required this.address}) : super(key: key);
  final ReceiptAddress address;

  Widget _buildLine({String text, String hint, TextInputType inputType, int maxLength, TextEditingController controller, Function onTap}) {
    List<TextInputFormatter> formatters = [];
    if (maxLength != null && maxLength > 0) {
      formatters.add(LengthLimitingTextInputFormatter(maxLength));
    }
    return LineButtonItem(
      text: text,
      suffix: Container(
        child: TextField(
          keyboardType: inputType,
          enableSuggestions: false,
          controller: controller,
          autocorrect: false,
          inputFormatters: formatters,
          textAlign: TextAlign.right,
          maxLines: 1,
          decoration: InputDecoration(isDense: true, hintText: hint, contentPadding: EdgeInsets.symmetric(vertical: 0), border: InputBorder.none),
          onTap: onTap,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BaseRoute<UserAddressEditProvider>(
      listen: true,
      provider: UserAddressEditProvider(context, address),
      builder: (_, model, __) {
        final style = Provider.of<ThemeModel>(context, listen: false).theme;
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text(model.translate(address == null ? 'user_address.add_address' : 'user_address.edit_address')),
            backgroundColor: style.headerBackgroundColor,
            brightness: Brightness.light,
            textTheme: style.headerTextTheme,
            iconTheme: style.headerIconTheme,
            actions: <Widget>[
              FlatButton(
                child: Text(model.translate('controller.complete')),
                onPressed: model.submit,
              )
            ],
          ),
          body: GestureDetector(
            onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
            child: Wrap(
              children: <Widget>[
                LineButtonGroup(children: <Widget>[
                  _buildLine(
                      text: model.translate('user_address.consignee'),
                      hint: model.translate('user_address.hint_consignee'),
                      controller: model.consigneeController),
                  _buildLine(
                    text: model.translate('user_address.contact'),
                    hint: model.translate('user_address.hint_contact'),
                    inputType: TextInputType.numberWithOptions(),
                    maxLength: 11,
                    controller: model.phoneController,
                  ),
                  _buildLine(
                      text: model.translate('user_address.location'),
                      hint: model.translate('user_address.hint_location'),
                      controller: model.positionController,
                      onTap: model.showAddressSelector),
                  _buildLine(
                      text: model.translate('user_address.address'), hint: model.translate('user_address.hint_address'), controller: model.detailController),
                  _buildLine(
                      text: model.translate('user_address.postcode'),
                      hint: model.translate('user_address.hint_postcode'),
                      inputType: TextInputType.numberWithOptions(),
                      maxLength: 8,
                      controller: model.postcodeController),
                ])
              ],
            ),
          ),
        );
      },
    );
  }
}

class UserAddressEditProvider extends BaseProvider {
  UserAddressEditProvider(BuildContext context, ReceiptAddress address) : super(context) {
    _address = address;
    _locationData = LocationData(api);
    if (_address == null) {
      _address = ReceiptAddress();
      // _position = _locationData.getAddress();
    }
    _consigneeController.text = _address.name ?? '';
    _phoneController.text = _address.phone ?? '';
    _positionController.text = address == null ? "" : "${_address.province} ${_address.city} ${_address.district}";
    _detailController.text = _address.address ?? '';
    _postcodeController.text = _address.postcode ?? '';
  }

  ReceiptAddress _address;
  Address _position;
  TextEditingController _consigneeController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _positionController = TextEditingController();
  TextEditingController _detailController = TextEditingController();
  TextEditingController _postcodeController = TextEditingController();
  LocationData _locationData;

  ReceiptAddress get address => _address;
  TextEditingController get consigneeController => _consigneeController;
  TextEditingController get phoneController => _phoneController;
  TextEditingController get positionController => _positionController;
  TextEditingController get detailController => _detailController;
  TextEditingController get postcodeController => _postcodeController;

  @override
  void dispose() {
    super.dispose();
    _consigneeController?.dispose();
    _phoneController?.dispose();
    _positionController?.dispose();
    _detailController?.dispose();
    _postcodeController?.dispose();
  }

  bool validate() {
    String phone = _phoneController.text;
    RegExp reg = RegExp(r'^[1](([3][0-9])|([4][5-9])|([5][0-3,5-9])|([6][5,6])|([7][0-8])|([8][0-9])|([9][1,8,9]))[0-9]{8}$');
    bool flag = false;
    if (_consigneeController.text.isEmpty) {
      showToast(translate('message.consignee_empty'));
    } else if (_positionController.text.isEmpty) {
      showToast(translate('message.position_empty'));
    } else if (phone.isEmpty) {
      showToast(translate('message.contact_empty'));
    } else if (!reg.hasMatch(phone)) {
      showToast(translate('message.phone_invalid'));
    } else {
      flag = true;
    }
    return flag;
  }

  showAddressSelector() async {
    FocusScope.of(context).requestFocus(FocusNode());
    Widget screen = AddressSelector(
      title: translate('publish.address_selector'),
      locationData: _locationData,
    );
    _position = await this.showDialog(screen);
    _positionController.text = _position.toString();
    notifyListeners();
  }

  submit() async {
    FocusScope.of(context).requestFocus(FocusNode());
    final user = Provider.of<UserModel>(context, listen: false).user;
    print(user);
    var res = false;
    AddressRequest address = AddressRequest();
    if (validate()) {
      address.rid = _address.rid;
      address.userid = user.userid;
      address.name = _consigneeController.text;
      address.phone = _phoneController.text;
      // _position = _positionController.text;
      address.province = _position == null ? _address.province : _position.privonce?.name;
      address.city = _position == null ? _address.city : _position.city?.name;
      address.district = _position == null ? _address.district : _position.district?.name;
      address.address = _detailController.text;
      address.postcode = _postcodeController.text.isEmpty ? '000000' : _postcodeController.text;
      address.isDefault = _address.isDefault;
      showLoading();
      if (_address.rid > 0) {
        res = await api.updateRecAddr(address);
      } else {
        res = await api.addRecAddr(address);
      }
      closeLoading();
      pop(res);
    }
  }
}
