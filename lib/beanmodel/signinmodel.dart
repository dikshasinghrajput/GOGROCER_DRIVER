class DeliveryBoyLogin {
  dynamic status;
  dynamic message;
  DeliveryBoyLoginData? data;

  DeliveryBoyLogin({this.status, this.message, this.data});

  DeliveryBoyLogin.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    var jsD = json['data'] as List?;
    if (jsD != null && jsD.isNotEmpty) {
      data = DeliveryBoyLoginData.fromJson(json['data'][0]);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data;
    }
    return data;
  }
}

class DeliveryBoyLoginData {
  dynamic dboyId;
  dynamic boyName;
  dynamic boyPhone;
  dynamic boyCity;
  dynamic password;
  dynamic deviceId;
  dynamic boyLoc;
  dynamic lat;
  dynamic lng;
  dynamic status;
  dynamic storeId;
  dynamic storeDboyId;
  dynamic addedBy;

  DeliveryBoyLoginData(
      {this.dboyId,
        this.boyName,
        this.boyPhone,
        this.boyCity,
        this.password,
        this.deviceId,
        this.boyLoc,
        this.lat,
        this.lng,
        this.status,
        this.storeId,
        this.storeDboyId,
        this.addedBy});

  DeliveryBoyLoginData.fromJson(Map<String, dynamic> json) {
    dboyId = json['dboy_id'];
    boyName = json['boy_name'];
    boyPhone = json['boy_phone'];
    boyCity = json['boy_city'];
    password = json['password'];
    deviceId = json['device_id'];
    boyLoc = json['boy_loc'];
    lat = json['lat'];
    lng = json['lng'];
    status = json['status'];
    storeId = json['store_id'];
    storeDboyId = json['store_dboy_id'];
    addedBy = json['added_by'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['dboy_id'] = dboyId;
    data['boy_name'] = boyName;
    data['boy_phone'] = boyPhone;
    data['boy_city'] = boyCity;
    data['password'] = password;
    data['device_id'] = deviceId;
    data['boy_loc'] = boyLoc;
    data['lat'] = lat;
    data['lng'] = lng;
    data['status'] = status;
    data['store_id'] = storeId;
    data['store_dboy_id'] = storeDboyId;
    data['added_by'] = addedBy;
    return data;
  }
}
