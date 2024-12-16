class Messages {
  Messages(
      {required this.msg,
        required this.read_by,
        required this.type,
        required this.fromId,
        required this.sent});
  late final String msg;
  late final String read_by;
  late final String fromId;
  late final String sent;
  late final String type;


  Messages.fromJson(Map<String, dynamic> json) {
    msg = json['msg'].toString();
    read_by = json['read_by'].toString();
    type = json['type'].toString() ;
    fromId = json['fromId'].toString();
    sent = json['sent'].toString();
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['msg'] = msg;
    data['read_by'] = read_by;
    data['type'] = type;
    data['fromId'] = fromId;
    data['sent'] = sent;
    return data;
  }
}