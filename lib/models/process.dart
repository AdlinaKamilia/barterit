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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['barter_id'] = this.barterId;
    data['seller_id'] = this.sellerId;
    data['buyer_id'] = this.buyerId;
    data['seller_item_id'] = this.sellerItemId;
    data['buyer_item_id'] = this.buyerItemId;
    data['status'] = this.status;
    data['insert_time'] = this.insertTime;
    data['buyer_item_name'] = this.buyerItemName;
    data['buyer_item_description'] = this.buyerItemDescription;
    data['buyer_item_price'] = this.buyerItemPrice;
    data['buyer_item_qty'] = this.buyerItemQty;
    data['buyer_item_type'] = this.buyerItemType;
    data['buyer_item_lat'] = this.buyerItemLat;
    data['buyer_item_long'] = this.buyerItemLong;
    data['buyer_item_state'] = this.buyerItemState;
    data['buyer_item_local'] = this.buyerItemLocal;
    data['buyer_item_date'] = this.buyerItemDate;
    data['seller_item_name'] = this.sellerItemName;
    data['seller_item_description'] = this.sellerItemDescription;
    data['seller_item_price'] = this.sellerItemPrice;
    data['seller_item_qty'] = this.sellerItemQty;
    data['seller_item_type'] = this.sellerItemType;
    data['seller_item_lat'] = this.sellerItemLat;
    data['seller_item_long'] = this.sellerItemLong;
    data['seller_item_state'] = this.sellerItemState;
    data['seller_item_local'] = this.sellerItemLocal;
    data['seller_item_date'] = this.sellerItemDate;
    return data;
  }
}
