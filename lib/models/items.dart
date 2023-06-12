class Item {
  String? itemId;
  String? userId;
  String? itemName;
  String? itemDescription;
  String? itemPrice;
  String? itemQuantity;
  String? itemType;
  String? latitude;
  String? longitude;
  String? state;
  String? locality;
  String? date;

  Item(
      {this.itemId,
      this.userId,
      this.itemName,
      this.itemDescription,
      this.itemPrice,
      this.itemQuantity,
      this.itemType,
      this.latitude,
      this.longitude,
      this.state,
      this.locality,
      this.date});

  Item.fromJson(Map<String, dynamic> json) {
    itemId = json['item_id'];
    userId = json['user_id'];
    itemName = json['item_name'];
    itemDescription = json['item_description'];
    itemPrice = json['item_price'];
    itemQuantity = json['item_quantity'];
    itemType = json['item_type'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    state = json['state'];
    locality = json['locality'];
    date = json['date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['item_id'] = itemId;
    data['user_id'] = userId;
    data['item_name'] = itemName;
    data['item_description'] = itemDescription;
    data['item_price'] = itemPrice;
    data['item_quantity'] = itemQuantity;
    data['item_type'] = itemType;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['state'] = state;
    data['locality'] = locality;
    data['date'] = date;
    return data;
  }
}
