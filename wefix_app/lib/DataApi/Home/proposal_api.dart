import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:service/Http%20Request%20Helper/http_request_helper.dart';

import '../constant_apiUrl.dart';

class ProposalController extends GetxController {
  RxString owner_id = ''.obs;
  RxString order_id = ''.obs;
  RxInt id = 0.obs;
  RxString title = ''.obs;
  RxString order_status = ''.obs;
  RxString vendor_image = ''.obs;
  // RxString image = ''.obs;
  RxString thumbnail_image = ''.obs;
  RxString description = ''.obs;
  RxString schedule = ''.obs;
  RxString vendor_name = ''.obs;
  //RxString order_image = ''.obs;
  RxString product_name = ''.obs;
   // RxString images = ''.obs;

  var ProposalPossList = [].obs;
  var ProposalpendingList = [].obs;

  Future<dynamic> GetProposal() async {
    NetworkData networkData = NetworkData(ProposalConfirmUrl);
    var Proposal = await networkData.getData();
    var finaldata = Proposal['data'];
    //print(finaldata);

    for (int i = 0; i <= finaldata.length-1; i++) {
      owner_id.value = Proposal['data'][i]['owner_id'];
      id.value= Proposal['data'][i]['id'];
      thumbnail_image.value = Proposal['data'][i]['thumbnail_image'];
      vendor_name.value = Proposal['data'][i]['vendor_name'];
      product_name.value = Proposal['data'][i]['product_name'];
      order_id.value = Proposal['data'][i]['order_id'];
      vendor_image.value = Proposal['data'][i]['vendor_image'];
      description.value = Proposal['data'][i]['description'];
      // print(description);

      // print(thumbnail_image);
      //order_amount.value = Proposal['data'][i]['order_amount'];

      ProposalPossList.add([
        vendor_name.value,
        thumbnail_image,
        product_name.value,
        order_id.value,
        vendor_image.value,
        id.value,
        description.value
        // order_amount.value
      ]);
    }

    print("Proposelist >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>$Proposal");

    //print('...............>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>..');
  }

  Future<dynamic> GetProposalPending() async {
    NetworkData networkData = NetworkData(ProposalPendingUrl);
    var Proposal1 = await networkData.getData();
    var finaldata = Proposal1['data'];


    for (int i = 0; i <=finaldata.length; i++) {
      owner_id.value = Proposal1['data'][i]['owner_id'];
      thumbnail_image.value = Proposal1['data'][i]['thumbnail_image'];
      vendor_name.value = Proposal1['data'][i]['vendor_name'];
      product_name.value = Proposal1['data'][i]['product_name'];
      order_id.value = Proposal1['data'][i]['order_id'];
      vendor_image.value = Proposal1['data'][i]['vendor_image'];
      description.value = Proposal1['data'][i]['description'];
      // images.value = Proposal1['data'][i]['images'];
      // images.value = Proposal1['data'][i]['images'];
   //  print(order_image);




      ProposalpendingList.add([
        vendor_name.value,
        thumbnail_image,
        product_name.value,
        order_id.value,
        vendor_image.value,
        description.value,
        // images.value,

      ]);

      // print("Proposelistpending >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>$Proposal1");
    }

    //print("Proposelist >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>$ProposalPossList");
  }
}
