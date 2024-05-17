class Credit {
  String? creditId;
  String? userId;
  String? creditAdd;
  String? creditHold;
  String? creditTime;

  Credit(
      {this.creditId,
      this.userId,
      this.creditAdd,
      this.creditHold,
      this.creditTime});

  Credit.fromJson(Map<String, dynamic> json) {
    creditId = json['creditId'];
    userId = json['userId'];
    creditAdd = json['creditAdd'];
    creditHold = json['creditHold'];
    creditTime = json['creditTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['creditId'] = creditId;
    data['userId'] = userId;
    data['creditAdd'] = creditAdd;
    data['creditHold'] = creditHold;
    data['creditTime'] = creditTime;
    return data;
  }
}
