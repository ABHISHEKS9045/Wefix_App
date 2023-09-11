import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:service/Http%20Request%20Helper/http_request_helper.dart';

import '../constant_apiUrl.dart';

class HistoryPossController extends GetxController {
  RxString vendor_id = ''.obs;
  RxString vendor_name = ''.obs;
  RxString schedule = ''.obs;
  RxString image = ''.obs;
  RxString description =''.obs;
  RxList HistoryPossList = [].obs;

  // Venders

  Future<dynamic> GetHistoryPoss() async {
    NetworkData networkData = NetworkData(Historylist);
    var HistoryPoss = await networkData.getData();
    var finaldata = HistoryPoss['data'];
   //  print(finaldata);


    for (int i = 0; i <= finaldata.length -1; i++) {
      vendor_name.value = HistoryPoss['data'][i]['vendor_name'];
      description.value = HistoryPoss['data'][i]['description'];
      schedule.value = HistoryPoss['data'][i]['schedule'];

      image.value = HistoryPoss['data'][i]['image'];

      HistoryPossList.value.add([
        vendor_name.value,
        schedule.value,
        image.value,description.value
      ]
          // brand.value,

          );
      update();
    }

 // print("Historylist >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>$HistoryPossList>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");

    // print("Historylist >>>>${HistoryPoss.length}");
  }
}
