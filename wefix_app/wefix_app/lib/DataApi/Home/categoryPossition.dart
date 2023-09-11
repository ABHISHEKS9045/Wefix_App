import 'package:get/get.dart';
import 'package:service/Http%20Request%20Helper/http_request_helper.dart';

import '../constant_apiUrl.dart';

class CategoryPossController extends GetxController {
  RxString brand = ''.obs;
  RxString thumbnail_image  = ''.obs;
  RxString product_name = ''.obs;
  RxString product_description = ''.obs;
  RxList CategoryPossList = [].obs;
  RxList ProductPossList = [].obs;
  RxString message = ''.obs;
  RxString first_name = ''.obs;
  RxString title = ''.obs;
  RxString id = ''.obs;
  RxList NamePossList = [].obs;

  // Venders

  Future<dynamic> GetCategoryPoss() async {
    NetworkData networkData = NetworkData(AllproductUrl);
    var CategoryPoss = await networkData.getData();
    var finaldata = CategoryPoss['data'];
   // print(finaldata);

    for (int i = 0; i < finaldata.length; i++) {
      brand.value = CategoryPoss['data'][i]['brand'].toString();
      thumbnail_image.value = CategoryPoss['data'][i]['thumbnail_image'].toString();
      product_description.value = CategoryPoss['data'][i]['product_description'].toString();
      id.value = CategoryPoss['data'][i]['id'].toString();


      CategoryPossList.value
          .add([brand.value, thumbnail_image.value, product_description.value,id.value]
              // brand.value,

              );
      update();
    }

   // print("Customerlist >>>>>>>>>>>$CategoryPoss");
    //print("Customerlist >>>>${CategoryPoss.length}");
  }

  Future<dynamic> Getvendorname() async {
    NetworkData networkData = NetworkData(UsernametUrl);
    var NamePoss = await networkData.getData();

    for (int i = 0; i < 1; i++) {
      message.value = NamePoss['data'][i]['message'];
      title.value = NamePoss['data'][i]['title'];
      first_name.value = NamePoss['data'][i]['first_name'];

      NamePossList.value.add([message.value, title.value, first_name.value]
          // brand.value,

          );
      update();
    }

  //  print("namelist >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>$NamePossList");
    // print("Customerlist >>>>${NamePoss.length}");
  }
}
