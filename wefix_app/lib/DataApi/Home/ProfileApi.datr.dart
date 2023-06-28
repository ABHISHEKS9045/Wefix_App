import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:service/Http%20Request%20Helper/http_request_helper.dart';

import '../constant_apiUrl.dart';

class ProfilePossController extends GetxController {
  RxString email = ''.obs;
  RxString password = ''.obs;
  RxString roleid = ''.obs;
  RxString first_name = ''.obs;
  RxString last_name =''.obs;
  RxString address =''.obs;
  RxString image_name =''.obs;
  RxString image =''.obs;
  RxList ProfilePossList = [].obs;

  // Venders

  Future<dynamic> GetProfilePoss() async {
    NetworkData networkData = NetworkData(GetProfileUrl);
    var ProfilePoss = await networkData.getData();
    var finaldata = ProfilePoss['data'];
    //  print(finaldata);


    for (int i = 0; i <= finaldata.length -1; i++) {
      email.value = ProfilePoss['data'][i]['email'];
      password.value = ProfilePoss['data'][i]['password'];
      roleid.value = ProfilePoss['data'][i]['roleid'];
      first_name.value = ProfilePoss['data'][i]['first_name'];
      last_name.value = ProfilePoss['data'][i]['last_name'];
      address.value = ProfilePoss['data'][i]['address'];
      image_name.value = ProfilePoss['data'][i]['image_name'];

      image.value = ProfilePoss['data'][i]['image'];

      ProfilePossList.value.add([
        email.value,
        password.value,
        roleid.value,
        first_name.value,
        last_name.value,
        address.value,
        image.value, image_name.value
      ]
        // brand.value,

      );
      update();
    }

     print("Profilelist >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>$ProfilePoss>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");

    // print("Historylist >>>>${HistoryPoss.length}");
  }
}
