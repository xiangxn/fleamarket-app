import 'package:bitsflea/common/constant.dart';
import 'package:bitsflea/common/location_data.dart';
import 'package:bitsflea/models/district.dart';
import 'package:bitsflea/routes/base.dart';
import 'package:bitsflea/states/base.dart';
import 'package:bitsflea/states/theme.dart';
import 'package:bitsflea/widgets/line_button_item.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart' as sysper;
import 'package:provider/provider.dart';

import 'line_button_group.dart';

class AddressSelector extends StatelessWidget {
  final String title;
  final LocationData locationData;

  AddressSelector({Key key, this.title, this.locationData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseRoute<AddressSelectorProvider>(
      listen: true,
      provider: AddressSelectorProvider(context, locationData),
      builder: (_, provider, __) {
        final style = Provider.of<ThemeModel>(context, listen: false).theme;
        return Scaffold(
          appBar: AppBar(
            title: Text(this.title),
            backgroundColor: style.headerBackgroundColor,
            brightness: Brightness.light,
            textTheme: style.headerTextTheme,
            iconTheme: style.headerIconTheme,
            leading: IconButton(icon: Icon(provider.isTop ? Icons.close : Icons.arrow_back_ios), onPressed: provider.back),
          ),
          body: SingleChildScrollView(
            controller: provider.controller,
            physics: ClampingScrollPhysics(),
            child: Column(children: <Widget>[
              Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.all(16),
                child: Text(provider.translate('address_selector.cur_address')),
              ),
              Container(
                color: Colors.white,
                child: LineButtonItem(
                  text: provider.location,
                  onTap: provider.selectCurrent,
                ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.all(16),
                child: Text(provider.translate('address_selector.change_address')),
              ),
              LineButtonGroup(
                children: provider.district.districts.map((district) {
                  return LineButtonItem(
                    text: district.name,
                    onTap: () => provider.selectAddress(district),
                  );
                }).toList(),
              )
            ]),
          ),
        );
      },
    );
  }
}

class AddressSelectorProvider extends BaseProvider implements WidgetsBindingObserver {
  LocationData _locationData;
  String _location;
  District _district;
  List<District> _districtLevel = [];
  ScrollController _controller = ScrollController();

  String get location => _location;
  District get district => _district;
  bool get isTop => _districtLevel.length == 0;
  ScrollController get controller => _controller;

  bool _disposed = false;

  AddressSelectorProvider(BuildContext context, LocationData locationData) : super(context) {
    WidgetsBinding.instance.addObserver(this);
    _locationData = locationData;
    initCurLocation();
  }

  initCurLocation() async {
    if (_locationData.locationAdcode == null || _locationData.locationAdcode.isEmpty) {
      await _locationData.updateLocation();
      await _locationData.fetchDistricts();
    }

    _location = _locationData.getAddress()?.toString() ?? translate('address_selector.no_permission');
    _district = _locationData.district;
    notifyListeners();
  }

  animateToTop() {
    _controller.animateTo(0, duration: Duration(milliseconds: 10), curve: Curves.easeIn);
  }

  selectCurrent() async {
    if (!busy) {
      String adcode = _locationData.locationAdcode;
      if (adcode == null) {
        // Map<PermissionGroup, PermissionStatus> status = await PermissionHandler().requestPermissions([PermissionGroup.locationWhenInUse]);
        // if (status[PermissionGroup.locationWhenInUse] != PermissionStatus.granted) {
        Map<sysper.Permission, sysper.PermissionStatus> status = await [sysper.Permission.locationWhenInUse].request();
        if (status[sysper.Permission.locationWhenInUse] != sysper.PermissionStatus.granted) {
          bool res = await confirm(translate('permission.location'));
          if (res) {
            // bool canOpen = await PermissionHandler().openAppSettings();
            await sysper.openAppSettings();
          }
        }
      } else {
        pop(_locationData.getAddress(adcode));
      }
    }
  }

  selectAddress(District district) {
    if (district.level == DISTRICT_LV) {
      pop(_locationData.getAddress(district.adcode));
    } else {
      _districtLevel.add(district);
      _district = district;
      animateToTop();
      notifyListeners();
    }
  }

  back() {
    if (_districtLevel.length == 0) {
      pop();
    } else {
      _districtLevel.removeLast();
      if (_districtLevel.length == 0) {
        _district = _locationData.district;
      } else {
        _district = _districtLevel.last;
      }
      animateToTop();
      notifyListeners();
    }
  }

  void onResumed() async {
    setBusy();
    await _locationData.updateLocation();
    initCurLocation();
    notifyListeners();
    setBusy();
  }

  @override
  void didChangeAccessibilityFeatures() {}

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.inactive:
        onInactive();
        break;
      case AppLifecycleState.paused:
        onPaused();
        break;
      case AppLifecycleState.resumed:
        onResumed();
        break;
      case AppLifecycleState.detached:
        onDetached();
        break;
      default:
    }
  }

  @override
  void didChangeLocales(List<Locale> locale) {}

  @override
  void didChangeMetrics() {}

  @override
  void didChangePlatformBrightness() {}

  @override
  void didChangeTextScaleFactor() {}

  @override
  void didHaveMemoryPressure() {}

  @override
  Future<bool> didPopRoute() {
    return null;
  }

  @override
  Future<bool> didPushRoute(String route) {
    return null;
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _disposed = true;
    super.dispose();
  }

  @override
  void notifyListeners() {
    if (!_disposed) {
      super.notifyListeners();
    }
  }

  void onInactive() {}

  void onPaused() {}

  void onDetached() {}

  @override
  Future<bool> didPushRouteInformation(RouteInformation routeInformation) {
    return Future<bool>.value(false);
  }
}
