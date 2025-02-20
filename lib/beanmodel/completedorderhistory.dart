class OrderHistoryCompleted {
  dynamic userAddress;
  dynamic orderStatus;
  dynamic storeName;
  dynamic storeLat;
  dynamic storeLng;
  dynamic storeAddress;
  dynamic userLat;
  dynamic userLng;
  dynamic dboyLat;
  dynamic dboyLng;
  dynamic cartId;
  dynamic userName;
  dynamic userPhone;
  double? remainingPrice;
  dynamic deliveryBoyName;
  dynamic deliveryBoyPhone;
  dynamic deliveryDate;
  dynamic timeSlot;
  dynamic orderDetails;

  OrderHistoryCompleted(
      {this.userAddress,
        this.orderStatus,
        this.storeName,
        this.storeLat,
        this.storeLng,
        this.storeAddress,
        this.userLat,
        this.userLng,
        this.dboyLat,
        this.dboyLng,
        this.cartId,
        this.userName,
        this.userPhone,
        this.remainingPrice,
        this.deliveryBoyName,
        this.deliveryBoyPhone,
        this.deliveryDate,
        this.timeSlot,
        this.orderDetails});

  OrderHistoryCompleted.fromJson(Map<String, dynamic> json) {
    userAddress = json['user_address'];
    orderStatus = json['order_status'];
    storeName = json['store_name'];
    storeLat = json['store_lat'];
    storeLng = json['store_lng'];
    storeAddress = json['store_address'];
    userLat = json['user_lat'];
    userLng = json['user_lng'];
    dboyLat = json['dboy_lat'];
    dboyLng = json['dboy_lng'];
    cartId = json['cart_id'];
    userName = json['user_name'];
    userPhone = json['user_phone'];
    remainingPrice = json['remaining_price'] != null && json['remaining_price'] !=''? double.parse('${json['remaining_price']}') : 0;
    deliveryBoyName = json['delivery_boy_name'];
    deliveryBoyPhone = json['delivery_boy_phone'];
    deliveryDate = json['delivery_date'];
    timeSlot = json['time_slot'];
    orderDetails = json['order_details'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_address'] = userAddress;
    data['order_status'] = orderStatus;
    data['store_name'] = storeName;
    data['store_lat'] = storeLat;
    data['store_lng'] = storeLng;
    data['store_address'] = storeAddress;
    data['user_lat'] = userLat;
    data['user_lng'] = userLng;
    data['dboy_lat'] = dboyLat;
    data['dboy_lng'] = dboyLng;
    data['cart_id'] = cartId;
    data['user_name'] = userName;
    data['user_phone'] = userPhone;
    data['remaining_price'] = remainingPrice;
    data['delivery_boy_name'] = deliveryBoyName;
    data['delivery_boy_phone'] = deliveryBoyPhone;
    data['delivery_date'] = deliveryDate;
    data['time_slot'] = timeSlot;
    data['order_details'] = orderDetails;
    return data;
  }
}