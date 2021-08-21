import 'package:flutter_ion/flutter_ion.dart';
import 'package:uuid/uuid.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IonController extends GetxController {
  SharedPreferences? _prefs;
  late String _sid;
  late String _name;
  final String _uid = Uuid().v4();
  IonBaseConnector? _baseConnector;
  IonAppBiz? _biz;
  Client? _clientSFU;
  GRPCWebSignal? _signal;

  String get sid => _sid;

  String get uid => _uid;

  String get name => _name;

  IonAppBiz? get biz => _biz;

  Client? get sfu => _clientSFU;

  @override
  void onInit() async {
    super.onInit();
    print('IonController::onInit');
  }

  Future<SharedPreferences> prefs() async {
    if (_prefs == null) {
      _prefs = await SharedPreferences.getInstance();
    }
    return _prefs!;
  }

  setupBIZ(host) {
    _baseConnector = new IonBaseConnector(host);
    _biz = new IonAppBiz(_baseConnector!);
  }

  connectSFU(host) async {
    _signal = GRPCWebSignal(host);
    _clientSFU = await Client.create(sid: _sid, uid: _uid, signal: _signal!);
  }

  joinBIZ(String roomID, String displayName) async {
    _sid = roomID;
    _biz!.join(sid: roomID, uid: _uid, info: {'name': '$displayName'});
  }

  close() async {
    _biz?.leave(_uid);
    _biz?.close();
    _biz = null;
  }
}
