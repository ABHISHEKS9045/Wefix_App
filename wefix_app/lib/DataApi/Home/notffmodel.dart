import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:service/Http%20Request%20Helper/http_request_helper.dart';

import '../constant_apiUrl.dart';

class NotificationController extends GetxController {
  RxString vendor_name = ''.obs;
  RxString image = ''.obs;
  RxString message = ''.obs;
  RxList NotyfiList = [].obs;

  // Venders

  Future<dynamic> GetNotyfi() async {
    NetworkData networkData = NetworkData(NotificationAll);
    var Notyfi = await networkData.getData();

    for (int i = 0; i < Notyfi.length; i++) {
      vendor_name.value = Notyfi['data'][i]['vendor_name'];
      image.value = Notyfi['data'][i]['image'];
      message.value = Notyfi['data'][i]['message'];
      //print(image);

      NotyfiList.add([vendor_name.value, image.value, message.value]);

      //print("Proposelist >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>$ProposalpendingList");
    }

    print("Notifylist >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>$NotyfiList");
    // print("Customerlist >>>>${CategoryPoss.length}");
  }
}
