class DataModel {
  String? id;
  String? temp;
  String? location;

  DataModel({this.id, this.temp, this.location});

  DataModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    temp = json['temp'];
    location = json['location'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['temp'] = this.temp;
    data['location'] = this.location;
    return data;
  }
}