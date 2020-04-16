class StudentUser {
  String key;
  String username;
  String name;
  String institute;
  bool showCourse;
  StudentUser({this.key, this.username, this.name, this.institute,this.showCourse});
  factory StudentUser.fromJson(Map<String, dynamic> json) {
    return StudentUser(
        key: json['key'],
        institute: json['institute'],
        username: json['username'],
        name: json['name'],
        showCourse: json['showCourseUI']);
  }
  Map<String, dynamic> toJson() => {
        'key': key,
        'username': username,
        'name': name,
        'institute': institute,
        'showCourse': showCourse,
      };
}
