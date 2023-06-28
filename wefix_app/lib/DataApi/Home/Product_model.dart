import 'package:get/get.dart';
import 'package:service/Http Request Helper/http_request_helper.dart';

import '../constant_apiUrl.dart';

class ProductPossController extends GetxController {
  RxString brand = ''.obs;
  RxString thumbnail_image = ''.obs;
  RxString product_name = ''.obs;
  RxString product_description = ''.obs;
  RxString id = ''.obs;

  RxList ProductPossList = [].obs;

  // Venders

  Future<dynamic> GetProductPoss() async {
    NetworkData networkData = NetworkData(Productlist);
    var ProductPoss = await networkData.getData();

    for (int i = 0; i < ProductPoss.length ; i++) {
      brand.value = ProductPoss['data'][i]['id'];
      id.value = ProductPoss['data'][i]['brand'];
      thumbnail_image.value = ProductPoss['data'][i]['thumbnail_image'];
      product_description.value = ProductPoss['data'][i]['product_description'];

      ProductPossList.value.add([
        brand.value,
        thumbnail_image.value,
        product_description.value,
        id.value
      ]
          // brand.value,

          );
      update();
    }

    // print("productlist >>>>$ProductPossList");
    // print("productlist >>>>${ProductPoss.length}");
  }
}
