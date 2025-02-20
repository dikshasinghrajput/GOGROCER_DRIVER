class NotificationModel {
  dynamic status;
  dynamic message;
  late List<NotificationData> data;

  NotificationModel({this.status, this.message});

  NotificationModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data.add(NotificationData.fromJson(v));
      });
    }
  }

  Map<String, dynamic>? toJson() {
    return null;
  }
}

class NotificationData {
  dynamic status;
  dynamic message;
  int? notId;
  String? notTitle;
  String? notMessage;
  String? image;
  int? dBoyId;
  int? readByDriver;
  DateTime? createdAt;

  NotificationData({this.dBoyId, this.image, this.notId, this.notMessage, this.notTitle});

  NotificationData.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    notId = json['not_id'];
    dBoyId = json['dboy_id'];
    readByDriver = json['read_by_driver'];
    notTitle = json['not_title'];
    image = json['image'];
    notMessage = json['not_message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['dboy_id'] = dBoyId;
    data['not_id'] = notId;
    data['not_title'] = notTitle;
    data['not_message'] = notMessage;
    data['image'] = image;
    return data;
  }
}
