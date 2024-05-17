class Process {
  String? barterId;
  String? sellerId;
  String? buyerId;
  String? sellerItemId;
  String? buyerItemId;
  String? status;
  String? insertTime;
  String? buyerItemName;
  String? buyerItemDescription;
  String? buyerItemPrice;
  String? buyerItemQty;
  String? buyerItemType;
  String? buyerItemLat;
  String? buyerItemLong;
  String? buyerItemState;
  String? buyerItemLocal;
  String? buyerItemDate;
  String? sellerItemName;
  String? sellerItemDescription;
  String? sellerItemPrice;
  String? sellerItemQty;
  String? sellerItemType;
  String? sellerItemLat;
  String? sellerItemLong;
  String? sellerItemState;
  String? sellerItemLocal;
  String? sellerItemDate;

  Process(
      {this.barterId,
      this.sellerId,
      this.buyerId,
      this.sellerItemId,
      this.buyerItemId,
      this.status,
      this.insertTime,
      this.buyerItemName,
      this.buyerItemDescription,
      this.buyerItemPrice,
      this.buyerItemQty,
      this.buyerItemType,
      this.buyerItemLat,
      this.buyerItemLong,
      this.buyerItemState,
      this.buyerItemLocal,
      this.buyerItemDate,
      this.sellerItemName,
      this.sellerItemDescription,
      this.sellerItemPrice,
      this.sellerItemQty,
      this.sellerItemType,
      this.sellerItemLat,
      this.sellerItemLong,
      this.sellerItemState,
      this.sellerItemLocal,
      this.sellerItemDate});

  Process.fromJson(Map<String, dynamic> json) {
    barterId = json['barter_id'];
    sellerId = json['seller_id'];
    buyerId = json['buyer_id'];
    sellerItemId = json['seller_item_id'];
    buyerItemId = json['buyer_item_id'];
    status = json['status'];
    insertTime = json['insert_time'];
    buyerItemName = json['buyer_item_name'];
    buyerItemDescription = json['buyer_item_description'];
    buyerItemPrice = json['buyer_item_price'];
    buyerItemQty = json['buyer_item_qty'];
    buyerItemType = json['buyer_item_type'];
    buyerItemLat = json['buyer_item_lat'];
    buyerItemLong = json['buyer_item_long'];
    buyerItemState = json['buyer_item_state'];
    buyerItemLocal = json['buyer_item_local'];
    buyerItemDate = json['buyer_item_date'];
    sellerItemName = json['seller_item_name'];
    sellerItemDescription = json['seller_item_description'];
    sellerItemPrice = json['seller_item_price'];
    sellerItemQty = json['seller_item_qty'];
    sellerItemType = json['seller_item_type'];
    sellerItemLat = json['seller_item_lat'];
    sellerItemLong = json['seller_item_long'];
    sellerItemState = json['seller_item_state'];
    sellerItemLocal = json['seller_item_local'];
    sellerItemDate = json['seller_item_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['barter_id'] = barterId;
    data['seller_id'] = sellerId;
    data['buyer_id'] = buyerId;
    data['seller_item_id'] = sellerItemId;
    data['buyer_item_id'] = buyerItemId;
    data['status'] = status;
    data['insert_time'] = insertTime;
    data['buyer_item_name'] = buyerItemName;
    data['buyer_item_description'] = buyerItemDescription;
    data['buyer_item_price'] = buyerItemPrice;
    data['buyer_item_qty'] = buyerItemQty;
    data['buyer_item_type'] = buyerItemType;
    data['buyer_item_lat'] = buyerItemLat;
    data['buyer_item_long'] = buyerItemLong;
    data['buyer_item_state'] = buyerItemState;
    data['buyer_item_local'] = buyerItemLocal;
    data['buyer_item_date'] = buyerItemDate;
    data['seller_item_name'] = sellerItemName;
    data['seller_item_description'] = sellerItemDescription;
    data['seller_item_price'] = sellerItemPrice;
    data['seller_item_qty'] = sellerItemQty;
    data['seller_item_type'] = sellerItemType;
    data['seller_item_lat'] = sellerItemLat;
    data['seller_item_long'] = sellerItemLong;
    data['seller_item_state'] = sellerItemState;
    data['seller_item_local'] = sellerItemLocal;
    data['seller_item_date'] = sellerItemDate;
    return data;
  }
}
