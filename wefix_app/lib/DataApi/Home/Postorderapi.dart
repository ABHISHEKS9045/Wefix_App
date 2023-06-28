import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;


class PostOrderController extends GetxController{



  @override
  void init(){
    super.onInit() ;

  }


  Future<Album> createAlbum(ownerId,productId,description,vendrorId,vendorName,image) async {
    final http.Response response = await http.post(
      Uri.parse('http://209.97.156.170:7071/owner/add_order'),


      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'owner_id': ownerId,
        'product_id': productId,
        'description': description,
        'vendor_id': vendrorId,
        'vendor_name': vendorName,
        'images': image,
      }),
    );

    if (response.statusCode == 200) {


      return Album.fromJson(json.decode(response.body));



    } else {
      throw Exception('Failed to create album.');
    }
  }




}





class Album {

  final String ow_id;
  final String pr_id ;
  final String description ;
  final String vendor_id ;
  final String vendor_name;
  final String images;

  Album({
    required this.ow_id,
    required this.pr_id,
    required this.description,
    required this.vendor_id,
    required this.vendor_name,
    required this.images,

   });

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      ow_id: json['ow_id'],
      pr_id: json['pr_id'],
      description: json['description'],
      vendor_id: json['vendor_id'],
      vendor_name: json['vendor_name'],
      images: json['images'],
    );
  }
}
