import 'package:flutter/cupertino.dart';

import 'PDF/pdf.dart';
import 'Profile/profile.dart';
import 'Serach/Searchpage.dart';
import 'dashboard/dashboard.dart';

class BottomnavbarModelPage extends ChangeNotifier {
  int _bottombarzindex = 0;
  int get bottombarzindex => _bottombarzindex;

  final List _bottombarScreens = [
    const dashboard(),
    pdfpage(),
    Searchpage(showBack: false),
    const Profilepage(),
  ];

  List get bottombarScreens => _bottombarScreens;

  toggle(context, index) async {
    print('Toggle print index ${index.runtimeType}');
    if (index == 4) {
    } else {
      _bottombarzindex = index;
      notifyListeners();
    }
  }

  togglebottomindexreset() {
    _bottombarzindex = 0;
    notifyListeners();
  }
}
