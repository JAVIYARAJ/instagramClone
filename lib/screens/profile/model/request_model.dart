class RequestModel {
  String? id;
  String? followId;
  String? status;
  String? createdAt;
  String? updatedAt;

  RequestModel(
      {this.id,
        this.followId,
        this.status,
        this.createdAt,
        this.updatedAt});

  RequestModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    followId = json['followId'];
    status = json['status'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['followId'] = followId;
    data['status'] = status;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}
