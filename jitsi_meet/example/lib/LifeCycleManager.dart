import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LifeCycleManager extends StatefulWidget {
  final Widget child;

  LifeCycleManager({required this.child});
  _LifeCycleManagerState createState() => _LifeCycleManagerState();
}

class _LifeCycleManagerState extends State<LifeCycleManager>
    with WidgetsBindingObserver {
  bool val = false;
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  static const platform = const MethodChannel('pip/fullscreen');

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
    getShareprefVal();
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance!.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    print('LifeCycleState= $state');
    if (state == AppLifecycleState.paused) {
      // SystemNavigator.pop();
    }
    if (state == AppLifecycleState.resumed) {
      // send to full screen of meeting
      getShareprefVal();
    }
  }

  Future<bool> getBoolPreference() async {
    bool op = false;
    await SharedPreferences.getInstance()
        .then((value) => {op = value.getBool('checkmeet')!});
    return op;
    // SharedPreferences prefs = await _prefs;
    // bool? op = prefs.getBool('checkmeet');
    // if (op == null) {
    //   op = false;
    // }
    // return op;
  }

  getShareprefVal() async {
    bool stateVal = await getBoolPreference();
    setState(() {
      val = stateVal;
      print('SharedPref from lifecycle: $val');
    });
    if (val) {
      //redirect to full screen or meeting
      print('meeting is already going on.');
      await platform.invokeMethod('fullscreen');
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
