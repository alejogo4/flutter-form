class Polls {
  Polls({
    required this.id,
    required this.date,
    required this.email,
    required this.qualification,
    required this.theBest,
    required this.theWorst,
    required this.remarks,
  });
  late final int id;
  late final String date;
  late final String email;
  late final int qualification;
  late final String theBest;
  late final String theWorst;
  late final String remarks;

  Polls.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    date = json['date'];
    email = json['email'];
    qualification = json['qualification'];
    theBest = json['theBest'];
    theWorst = json['theWorst'];
    remarks = json['remarks'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['date'] = date;
    _data['email'] = email;
    _data['qualification'] = qualification;
    _data['theBest'] = theBest;
    _data['theWorst'] = theWorst;
    _data['remarks'] = remarks;
    return _data;
  }
}
