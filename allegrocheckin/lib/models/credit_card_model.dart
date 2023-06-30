class CreditCardModel {
  String cardNumber;
  String ownerName;
  String date;
  String cvc;
  int id;
  int idUser;
  String country;
  String city;
  String address;
  String zipCode;

  CreditCardModel(
      {this.cardNumber,
      this.ownerName,
      this.date,
      this.cvc,
      this.country,
      this.city,
      this.zipCode,
      this.address,
      this.id,
      this.idUser});

  CreditCardModel.fromJson(Map<String, dynamic> json) {
    cardNumber = json['cardNumber'];
    ownerName = json['ownerName'];
    date = json['date'];
    cvc = json['cvc'];
    country = json['country'];
    city = json['city'];
    zipCode = json['zipCode'];
    address = json['address'];
    id = json['id'];
    idUser = json['idUser'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cardNumber'] = this.cardNumber;
    data['ownerName'] = this.ownerName;
    data['date'] = this.date;
    data['cvc'] = this.cvc;
    data['country'] = this.country;
    data['city'] = this.city;
    data['zipCode'] = this.zipCode;
    data['address'] = this.address;
    data['id'] = this.id;
    data['idUser'] = this.idUser;
    return data;
  }
}
