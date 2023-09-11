import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:service/DataApi/constant_apiUrl.dart';
import 'package:service/Http%20Request%20Helper/http_request_helper.dart';

class VendorsPossController extends GetxController {
  RxInt id = 0.obs;
  RxString roleid = ''.obs;
  RxString first_name = ''.obs;
  RxString last_name = ''.obs;
  RxString image = ''.obs;

  RxList VendorsPossList = [].obs;

  // Venders

  Future<dynamic> GetVendorsPoss() async {
    NetworkData networkData = NetworkData(Vendorslist);
    var VendorsPoss = await networkData.getData();
    var finaldata = VendorsPoss['data'];
   // print(finaldata);


    for (int i = 0; i < finaldata.length; i++) {
      first_name.value = VendorsPoss['data'][i]['first_name'];
      last_name.value = VendorsPoss['data'][i]['last_name'];
      image.value = VendorsPoss['data'][i]['image'];
      id.value = VendorsPoss['data'][i]['id'];

      VendorsPossList.value
          .add([first_name.value, last_name.value, image.value, id.value]
        // brand.value,

      );
      update();
    }
    //
    //print(
     //   "vendorsslist11 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>$VendorsPoss");
    // print("vendorslist >>>>${VendorsPoss.length}");
  }
}
