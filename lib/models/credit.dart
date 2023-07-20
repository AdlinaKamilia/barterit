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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['creditId'] = this.creditId;
    data['userId'] = this.userId;
    data['creditAdd'] = this.creditAdd;
    data['creditHold'] = this.creditHold;
    data['creditTime'] = this.creditTime;
    return data;
  }
}
