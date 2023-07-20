class User {
  String? id;
  String? email;
  String? name;
  String? phone;
  String? password;
  String? otp;
  String? datereg;
  String? cid;
  String? userCredit;
  String? userCreditH;

  User(
      {this.id,
      this.email,
      this.name,
      this.phone,
      this.password,
      this.otp,
      this.datereg,
      this.cid,
      this.userCredit,
      this.userCreditH});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    email = json['email'];
    name = json['name'];
    phone = json['phone'];
    password = json['password'];
    otp = json['otp'];
    datereg = json['datereg'];
    cid = json['cid'];
    userCredit = json['user_credit'];
    userCreditH = json['user_creditH'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['email'] = this.email;
    data['name'] = this.name;
    data['phone'] = this.phone;
    data['password'] = this.password;
    data['otp'] = this.otp;
    data['datereg'] = this.datereg;
    data['cid'] = this.cid;
    data['user_credit'] = this.userCredit;
    data['user_creditH'] = this.userCreditH;
    return data;
  }
}
