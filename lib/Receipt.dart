import 'package:image_picker/image_picker.dart';

class Receipt {
  int id = new DateTime.now().millisecondsSinceEpoch;
  String name;
  String date;
  String charge;
  XFile? image;
  String address;

  Receipt(this.name,this.address,this.date,this.charge,this.image);

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'address': address,
      'date': date,
      'charge': charge,
    };
  }

  setID(int num){
    this.id = num;
  }


}
