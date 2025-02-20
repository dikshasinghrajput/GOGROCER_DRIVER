import 'package:driver/baseurl/baseurlg.dart';

class OrderHistory {
  dynamic cartId;
  dynamic paymentMethod;
  dynamic paymentStatus;
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
  dynamic userName;
  dynamic userPhone;
  double? remainingPrice;
  dynamic deliveryBoyName;
  dynamic deliveryBoyPhone;
  dynamic deliveryDate;
  dynamic timeSlot;
  dynamic totalItems;
  List<ItemsDetails>? items;

  OrderHistory(
      {this.cartId,
      this.paymentMethod,
      this.paymentStatus,
      this.userAddress,
      this.orderStatus,
      this.storeName,
      this.storeLat,
      this.storeLng,
      this.storeAddress,
      this.userLat,
      this.userLng,
      this.dboyLat,
      this.dboyLng,
      this.userName,
      this.userPhone,
      this.remainingPrice,
      this.deliveryBoyName,
      this.deliveryBoyPhone,
      this.deliveryDate,
      this.timeSlot,
      this.totalItems,
      this.items});

  OrderHistory.fromJson(Map<String, dynamic> json) {
    cartId = json['cart_id'];
    paymentMethod = json['payment_method'];
    paymentStatus = json['payment_status'];
    userAddress = json['user_address'];
    orderStatus = '${json['order_status']}'.replaceAll('_', ' ');
    storeName = json['store_name'];
    storeLat = json['store_lat'];
    storeLng = json['store_lng'];
    storeAddress = json['store_address'];
    userLat = json['user_lat'];
    userLng = json['user_lng'];
    dboyLat = json['dboy_lat'];
    dboyLng = json['dboy_lng'];
    userName = json['user_name'];
    userPhone = json['user_phone'];
    remainingPrice = json['remaining_price'] != null && json['remaining_price'] != '' ? double.parse('${json['remaining_price']}') : 0;
    deliveryBoyName = json['delivery_boy_name'];
    deliveryBoyPhone = json['delivery_boy_phone'];
    deliveryDate = json['delivery_date'];
    timeSlot = json['time_slot'];
    totalItems = json['total_items'];
    if (json['items'] != null) {
      items = [];
      json['items'].forEach((v) {
        items!.add(ItemsDetails.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['cart_id'] = cartId;
    data['payment_method'] = paymentMethod;
    data['payment_status'] = paymentStatus;
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
    data['user_name'] = userName;
    data['user_phone'] = userPhone;
    data['remaining_price'] = remainingPrice;
    data['delivery_boy_name'] = deliveryBoyName;
    data['delivery_boy_phone'] = deliveryBoyPhone;
    data['delivery_date'] = deliveryDate;
    data['time_slot'] = timeSlot;
    data['total_items'] = totalItems;
    if (items != null) {
      data['items'] = items!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ItemsDetails {
  dynamic storeOrderId;
  dynamic productName;
  dynamic varientImage;
  dynamic quantity;
  dynamic unit;
  dynamic varientId;
  dynamic qty;
  int? price;
  dynamic totalMrp;
  dynamic orderCartId;
  dynamic orderDate;
  dynamic storeApproval;
  dynamic storeId;
  dynamic description;

  ItemsDetails({this.storeOrderId, this.productName, this.varientImage, this.quantity, this.unit, this.varientId, this.qty, this.price, this.totalMrp, this.orderCartId, this.orderDate, this.storeApproval, this.storeId, this.description});

  ItemsDetails.fromJson(Map<String, dynamic> json) {
    storeOrderId = json['store_order_id'];
    productName = json['product_name'];
    varientImage = '$imagebaseUrl${json['varient_image']}';
    quantity = json['quantity'];
    unit = json['unit'];
    varientId = json['varient_id'];
    qty = json['qty'];
    price = json['price'] != null && json['price'] != '' ? double.parse(json['price'].toString()).round() : 0;
    totalMrp = json['total_mrp'];
    orderCartId = json['order_cart_id'];
    orderDate = json['order_date'];
    storeApproval = json['store_approval'];
    storeId = json['store_id'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['store_order_id'] = storeOrderId;
    data['product_name'] = productName;
    data['varient_image'] = varientImage;
    data['quantity'] = quantity;
    data['unit'] = unit;
    data['varient_id'] = varientId;
    data['qty'] = qty;
    data['price'] = price;
    data['total_mrp'] = totalMrp;
    data['order_cart_id'] = orderCartId;
    data['order_date'] = orderDate;
    data['store_approval'] = storeApproval;
    data['store_id'] = storeId;
    data['description'] = description;
    return data;
  }
}
