import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:background_location/background_location.dart' as back;
import 'package:driver/Locale/locales.dart';
import 'package:driver/Pages/drawer.dart';
import 'package:driver/Pages/orderpage/todayorder.dart';
import 'package:driver/Pages/orderpage/tomorroworder.dart';
import 'package:driver/baseurl/baseurlg.dart';
import 'package:driver/beanmodel/appinfo.dart';
import 'package:driver/beanmodel/driverstatus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

FirebaseMessaging messaging = FirebaseMessaging.instance;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin, WidgetsBindingObserver {
  static const LatLng _center = LatLng(90.0, 90.0);
  CameraPosition kGooglePlex = const CameraPosition(
    target: _center,
    zoom: 25.151926,
  );

  final Completer<GoogleMapController> _controller = Completer();
  late GoogleMapController mapController;
  Set<Marker> markers = {};
  dynamic lat;
  dynamic lng;
  bool isOffline = true;
  bool enteredFirst = false;
  bool _isInForeGround = true;
  var http = Client();
  int totalOrder = 0;
  double totalIncentives = 0.0;
  dynamic appCurrency;
  Location location = Location();
  late bool _serviceEnabled;
  PermissionStatus? _permissionGranted;
  LocationData? _locationData;
  var isRun = false;

  void updateStatus(int status) async {
    setState(() {
      isRun = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    http.post(updateStatusUri, body: {'dboy_id': '${prefs.getInt('db_id')}', 'status': '$status'}).then((value) {
      var js = jsonDecode(value.body);
      if ('${js['status']}' == '1') {
        prefs.setInt('online_status', status);
        if (status == 0) {
          setState(() {
            isOffline = true;
            isRun = false;
          });
        } else {
          setState(() {
            isOffline = false;
            isRun = false;
          });
        }
      }
    }).catchError((e) {
      debugPrint(e);
    });
  }

  @override
  void initState() {
    super.initState();
    _init();

    WidgetsBinding.instance.addObserver(this);
    setFirebase();
    getDrierStatus();
    hitAppInfo();
  }

  _init() async {
    try {
      await WakelockPlus.enable();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String lat1 = prefs.getString('lat')!;
      String lng1 = prefs.getString('lng')!;
      lat = double.parse(lat1);
      lng = double.parse(lng1);

      await _updateMarker(lat, lng);
    } catch (e) {
      debugPrint('MAP Exception - locationScreen.dart - _init():$e');
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    _isInForeGround = state == AppLifecycleState.resumed;
  }

  void setFirebase() async {
    messaging = FirebaseMessaging.instance;
    iosPermission(messaging);

    messaging.getToken().then((value) {
      debugPrint('token: $value');
    });

    messaging.getInitialMessage().then((RemoteMessage? message) {
      debugPrint('message done');
      if (message != null) {
        RemoteNotification? notification = message.notification;
        if (notification != null && _isInForeGround) {
          _showNotification(notification.title, notification.body, notification.android!.imageUrl);
        }
      }
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint('message done');
      RemoteNotification? notification = message.notification;
      if (notification != null && _isInForeGround) {
        _showNotification(notification.title, notification.body, notification.android!.imageUrl);
      }
    });
  }

  void hitAppInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var http = Client();
    http.post(appInfoUri, body: {'user_id': ''}).then((value) {
      if (value.statusCode == 200) {
        AppInfoModel data1 = AppInfoModel.fromJson(jsonDecode(value.body));
        debugPrint('data - ${data1.toString()}');
        if (data1.status == "1" || data1.status == 1) {
          setState(() {
            prefs.setString('app_currency', '${data1.currencySign}');
            prefs.setString('app_referaltext', '${data1.refertext}');
            prefs.setString('numberlimit', '${data1.phoneNumberLength}');
            prefs.setString('imagebaseurl', '${data1.imageUrl}');
            getImageBaseUrl();
          });
        }
      }
    }).catchError((e) {
      debugPrint(e);
    });
  }

  void getDrierStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isRun = true;
      appCurrency = prefs.getString('app_currency');
    });
    if (prefs.containsKey('online_status')) {
      if (prefs.getInt('online_status') == 1) {
        setState(() {
          isOffline = false;
        });
      } else {
        setState(() {
          isOffline = true;
        });
      }
    } else {
      setState(() {
        isOffline = true;
      });
    }
    http.post(driverStatusUri, body: {'dboy_id': '${prefs.getInt('db_id')}'}).then((value) {
      if (value.statusCode == 200) {
        DriverStatus dstatus = DriverStatus.fromJson(jsonDecode(value.body));
        if ('${dstatus.status}' == '1') {
          int onoff = int.parse('${dstatus.onlineStatus}');
          prefs.setInt('online_status', onoff);
          if (onoff == 1) {
            setState(() {
              isOffline = false;
            });
          } else {
            setState(() {
              isOffline = true;
            });
          }
          totalOrder = int.parse('${dstatus.totalOrders}');
          totalIncentives = double.parse('${dstatus.totalIncentive}');
        }
      }
      setState(() {
        isRun = false;
      });
    }).catchError((e) {
      setState(() {
        isRun = false;
      });
      debugPrint(e);
    });
  }

  Future<bool> _updateMarker(lat, lng) async {
    try {
      String startCoordinatesString = '($lat, $lng)';
      Marker startMarker = Marker(
          markerId: MarkerId(startCoordinatesString),
          position: LatLng(lat, lng),
          icon: BitmapDescriptor.defaultMarkerWithHue(0),
          onTap: () async {
            mapController.animateCamera(
              CameraUpdate.newCameraPosition(
                CameraPosition(
                  target: LatLng(lat, lng),
                  tilt: 50.0,
                  bearing: 45.0,
                  zoom: 20.0,
                ),
              ),
            );
          });
      mapController = await _controller.future;
      markers.add(startMarker);

      return true;
    } catch (e) {
      debugPrint('MAP Exception - locationScreen.dart - _updateMarker():$e');
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    var locale = AppLocalizations.of(context)!;
    var theme = Theme.of(context);
    if (!enteredFirst) {
      setState(() {
        enteredFirst = true;
      });
      _getLocation(locale, context);
    }
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80.0),
        child: Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: AppBar(
            foregroundColor: theme.colorScheme.secondary,
            title: Text(
              isOffline ? locale.youReOffline!.toUpperCase() : locale.youReOnline!.toUpperCase(),
              style: Theme.of(context).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.w600, fontSize: 18),
            ),
            actions: <Widget>[
              isRun
                  ? const CupertinoActivityIndicator(
                      radius: 15,
                    )
                  : Container(),
              Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: InkWell(
                    onTap: () {
                      if (isOffline) {
                        updateStatus(1);
                      } else {
                        updateStatus(0);
                      }
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      width: 104,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: isOffline ? theme.colorScheme.primaryContainer : theme.colorScheme.errorContainer,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Text(
                        isOffline ? locale.goOnline!.toUpperCase() : locale.goOffline!.toUpperCase(),
                        textAlign: TextAlign.center,
                        style: TextStyle(color: isOffline ? theme.colorScheme.onPrimaryContainer : theme.colorScheme.onErrorContainer),
                      ),
                    ),
                  )),
            ],
          ),
        ),
      ),
      drawer: const AccountDrawer(),
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            GoogleMap(
              mapType: MapType.normal,
              markers: markers,
              initialCameraPosition: kGooglePlex,
              zoomControlsEnabled: false,
              myLocationButtonEnabled: false,
              compassEnabled: false,
              mapToolbarEnabled: false,
              buildingsEnabled: false,
              onMapCreated: (GoogleMapController controller) {
                if (!_controller.isCompleted) {
                  _controller.complete(controller);
                }
              },
            ),
            Positioned(
                bottom: 5,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) {
                                return const TodayOrder();
                              }));
                            },
                            behavior: HitTestBehavior.opaque,
                            child: Card(
                              color: theme.colorScheme.secondaryContainer,
                              elevation: 3,
                              child: Container(
                                width: MediaQuery.of(context).size.width / 2,
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                                child: Text(
                                  'Today Order',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 16, color: theme.colorScheme.onSecondaryContainer),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) {
                                return const TomorrowOrder();
                              }));
                            },
                            behavior: HitTestBehavior.opaque,
                            child: Card(
                              color: theme.colorScheme.secondaryContainer,
                              elevation: 3,
                              child: Container(
                                width: MediaQuery.of(context).size.width / 2,
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                                child: Text(
                                  'Nextday Order',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 16, color: theme.colorScheme.onSecondaryContainer),
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      padding: const EdgeInsets.all(16.0),
                      margin: const EdgeInsets.symmetric(horizontal: 20.0),
                      decoration: BoxDecoration(color: theme.scaffoldBackgroundColor, boxShadow: const [
                        BoxShadow(
                          color: Colors.grey,
                          offset: Offset(0.0, 2.0), //(x,y)
                          blurRadius: 6.0,
                        ),
                      ]),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          buildRowChild(theme, '$totalOrder', locale.orders!),
                          buildRowChild(theme, '$appCurrency $totalIncentives', locale.earnings!),
                        ],
                      ),
                    ),
                  ],
                )),
          ],
        ),
      ),
    );
  }

  void _getLocation(AppLocalizations locale, BuildContext context) async {
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (_serviceEnabled) {
        _permissionGranted = await location.hasPermission();
        if (_permissionGranted == PermissionStatus.denied) {
          _permissionGranted = await location.requestPermission();
          if (_permissionGranted == PermissionStatus.granted && context.mounted) {
            getLatLng(context, locale);
            await _backLocationFetch();
            await _updateMarker(lat, lng);
          }
        } else if (_permissionGranted == PermissionStatus.granted || _permissionGranted == PermissionStatus.grantedLimited) {
          if(!context.mounted) return;
          getLatLng(context, locale);
          await _backLocationFetch();
          await _updateMarker(lat, lng);
        }
      }
    } else {
      _permissionGranted = await location.hasPermission();
      if (_permissionGranted == PermissionStatus.denied) {
        _permissionGranted = await location.requestPermission();
        if (_permissionGranted == PermissionStatus.granted) {
          debugPrint('this one');
          if(!context.mounted) return;
          getLatLng(context, locale);
          await _backLocationFetch();
          await _updateMarker(lat, lng);
        }
      } else if (_permissionGranted == PermissionStatus.granted || _permissionGranted == PermissionStatus.grantedLimited) {
        debugPrint('this one 2');
        if(!context.mounted) return;
        getLatLng(context, locale);
        await _backLocationFetch();
        await _updateMarker(lat, lng);
      }
    }
  }

  Future _backLocationFetch() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await back.BackgroundLocation.startLocationService(distanceFilter: 20);
      back.BackgroundLocation.getLocationUpdates((location) async {
        await back.BackgroundLocation.setAndroidNotification(
          title: 'Background service is running',
          message: '${lat.toString()} ${lng.toString()}',
          icon: '@mipmap/ic_launcher',
        );

        lat = location.latitude;
        lng = location.longitude;

        http.post(
          updatelatlng,
          body: {
            'dboy_id': '${prefs.getInt('db_id')}',
            'lat': lat.toString(),
            'lng': lng.toString(),
          },
        ).then((value) {
          debugPrint('dvd - ${value.body}');
          if (value.statusCode == 200) {
            debugPrint('success');
            prefs.setString('lat', lat.toString());
            prefs.setString('lng', lng.toString());
          }
        }).catchError((e) {
          debugPrint(e);
        });
      });
    } catch (e) {
      debugPrint("Exceptioin - accepted_order.dart - _backLocationFetch():$e");
    }
  }

  void getLatLng(BuildContext context, AppLocalizations locale) async {
    _locationData = await location.getLocation();
    if (_locationData != null) {
      double latt = _locationData!.latitude!;
      double lngt = _locationData!.longitude!;
      GoogleMapController controller = await _controller.future;
      setState(() {
        lat = latt;
        lng = lngt;
      });
      kGooglePlex = CameraPosition(
        target: LatLng(latt, lngt),
        zoom: 20.151926,
      );
      controller.animateCamera(CameraUpdate.newCameraPosition(kGooglePlex));
    }
  }

  Future onDidReceiveLocalNotification(int id, String title, String body, String payload) async {
    // var message = jsonDecode('${payload}');
  }

  Future selectNotification(String payload) async {}

  void iosPermission(FirebaseMessaging firebaseMessaging) {
    if (Platform.isIOS) {
      firebaseMessaging.setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );
    }
  }
}

Column buildRowChild(ThemeData theme, String text1, String text2, {CrossAxisAlignment? alignment}) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: alignment ?? CrossAxisAlignment.center,
    children: <Widget>[
      Text(
        text1,
        style: theme.textTheme.titleLarge!.copyWith(color: theme.colorScheme.primary),
      ),
      const SizedBox(
        height: 8.0,
      ),
      Text(
        text2,
        style: theme.textTheme.titleSmall,
      ),
    ],
  );
}

Future<void> _showNotification(dynamic title, dynamic body, dynamic imageUrl) async {
  AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
    if (!isAllowed) {
      AwesomeNotifications().requestPermissionToSendNotifications();
    } else {
      if (imageUrl != null && '$imageUrl'.toUpperCase() != 'NUll' && '$imageUrl'.toUpperCase() != 'N/A') {
        AwesomeNotifications().createNotification(
            content: NotificationContent(
          id: 10,
          channelKey: 'basic_channel',
          title: '$title',
          body: '$body',
          icon: 'resource://drawable/icon',
          bigPicture: '$imageUrl',
          largeIcon: '$imageUrl',
          notificationLayout: NotificationLayout.BigPicture,
        ));
      } else {
        AwesomeNotifications().createNotification(content: NotificationContent(id: 10, channelKey: 'basic_channel', title: '$title', body: '$body', icon: 'resource://drawable/icon'));
      }
    }
  });
}
