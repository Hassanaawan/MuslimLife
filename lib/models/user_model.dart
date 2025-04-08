class UserModel {
  String? id;
  String? fullName;
  String? email;
  String? oneSignalId;
  String? timestamp;
  // String? totalDonation;
  String? created_at;
  String? updated_at;
  String? originalUrl;
  String? thumbnailUrl;

  UserModel({
    this.id,
    this.fullName,
    this.email,
    this.oneSignalId,
    this.timestamp,
    // this.totalDonation,
    this.created_at,
    this.updated_at,
    this.originalUrl,
    this.thumbnailUrl,
  });

  UserModel.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    fullName = json['fullName'];
    email = json['email'];
    oneSignalId = json['oneSignalId'];
    timestamp = json['timestamp'];
    // totalDonation = json['totalDonation'];
    created_at = json['created_at'];
    updated_at = json['updated_at'];
    originalUrl = json['originalUrl'];
    thumbnailUrl = json['thumbnailUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['fullName'] = fullName;
    data['email'] = email;
    data['oneSignalId'] = oneSignalId;
    data['timestamp'] = timestamp;
    // data['totalDonation'] = totalDonation;
    data['created_at'] = created_at;
    data['updated_at'] = updated_at;
    data['originalUrl'] = originalUrl;
    data['thumbnailUrl'] = thumbnailUrl;
    return data;
  }
}