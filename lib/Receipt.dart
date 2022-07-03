
class Receipt {
  int id = new DateTime.now().millisecondsSinceEpoch;
  String name;
  String date;
  String charge;
  String image;
  String address;

  Receipt(this.name,this.address,this.date,this.charge,this.image);

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'address': address,
      'date': date,
      'charge': charge,
      "image": image,
    };
  }

  setID(int num){
    this.id = num;
  }


}
