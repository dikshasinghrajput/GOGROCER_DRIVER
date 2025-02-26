class DriverProfilePeople {
  dynamic status;
  dynamic message;
  dynamic totalIncentive;
  dynamic receivedIncentive;
  dynamic remainingIncentive;
  DriverData? driverData;
  dynamic bankDetails;

  DriverProfilePeople(
      {this.status,
        this.message,
        this.totalIncentive,
        this.receivedIncentive,
        this.remainingIncentive,
        this.driverData,
        this.bankDetails});

  DriverProfilePeople.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    totalIncentive = json['total_incentive'];
    receivedIncentive = json['received_incentive'];
    remainingIncentive = json['remaining_incentive'];
    driverData = json['driver_data'] != null
        ? DriverData.fromJson(json['driver_data'])
        : null;
    bankDetails = json['bank_details'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    data['total_incentive'] = totalIncentive;
    data['received_incentive'] = receivedIncentive;
    data['remaining_incentive'] = remainingIncentive;
    if (driverData != null) {
      data['driver_data'] = driverData!.toJson();
    }
    data['bank_details'] = bankDetails;
    return data;
  }
}

class DriverData {
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

  DriverData(
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

  DriverData.fromJson(Map<String, dynamic> json) {
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