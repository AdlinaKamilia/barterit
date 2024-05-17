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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['email'] = email;
    data['name'] = name;
    data['phone'] = phone;
    data['password'] = password;
    data['otp'] = otp;
    data['datereg'] = datereg;
    data['cid'] = cid;
    data['user_credit'] = userCredit;
    data['user_creditH'] = userCreditH;
    return data;
  }
}
