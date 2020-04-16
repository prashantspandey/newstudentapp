class Direction {
  int id;
  String text;
  String picture;

  Direction({this.id, this.text, this.picture});

  factory Direction.fromJson(Map<String, dynamic> dirJson) {
    return Direction(
        picture: dirJson['picture'], id: dirJson['id'], text: dirJson['text']);
  }
  Map<String, dynamic> toJson() => {
        'id': id,
        'text': text,
        'picture': picture,
      };
}

class Subject {
  int id;
  String name;

  Subject({this.id, this.name});
  factory Subject.fromJson(Map<String, dynamic> subJson) {
    print('subjson ${subJson.toString()}');
    return Subject(id: subJson['id'], name: subJson['name']);
  }
  Map<String, dynamic> tojson() => {
        'id': id,
        'name': name,
      };
}

class Chapter {
  int id;
  String name;
  double code;

  Chapter({this.id, this.name, this.code});
  factory Chapter.fromJson(Map<String, dynamic> chapJson) {
    return Chapter(
        id: chapJson['id'], name: chapJson['name'], code: chapJson['code']);
  }
  Map<String, dynamic> tojson() => {
        'id': id,
        'name': name,
        'code': code,
      };
}

class Question {
  int id;
  var direction;
  double marks;
  double negativeMarks;
  String text;
  var subject;
  var chapter;
  String picture;
  String source;
  String language;
  List<Option> options;
  Question(
      {this.id,
      this.direction,
      this.marks,
      this.negativeMarks,
      this.text,
      this.subject,
      this.chapter,
      this.picture,
      this.source,
      this.language,
      this.options});

  factory Question.fromJson(Map<String, dynamic> questJson) {
    return Question(
      id: questJson['id'],
      direction: parseDirection(questJson['direction']),
      marks: questJson['marks'],
      negativeMarks: questJson['negativeMarks'],
      text: questJson['text'],
      subject: parseSubject(questJson['subject']),
      chapter: parseChapter(questJson['chapter']),
      picture: questJson['picture'],
      source: questJson['source'],
      language: questJson['language'],
      options: parseOptions(questJson['options']),
    );
  }
  static parseDirection(directionJson) {
    var direction = {};
    direction['id'] = directionJson['id'];
    direction['text'] = directionJson['text'];
    direction['picture'] = directionJson['picture'];

    return direction;
  }

  static parseSubject(subjectJson) {
    print('subject json ${subjectJson.toString()}');
    var subject = {};
    subject['id'] = subjectJson['id'];
    subject['name'] = subjectJson['name'];

    return subject;
  }

  static parseChapter(chapterJson) {
    print('chapter json ${chapterJson.toString()}');
    var chapter = {};
    chapter['id'] = chapterJson['id'];
    chapter['name'] = chapterJson['name'];

    return chapter;
  }

  static List<Option> parseOptions(optionJson) {
    var option_list = optionJson as List;
    List<Option> optionList =
        option_list.map((data) => Option.fromJson(data)).toList();
    return optionList;
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'comprehension': direction,
        'max_marks': marks,
        'negative_marks': negativeMarks,
        'text': text,
        'subject': subject,
        'chapter': chapter,
        'picture': picture,
        'source': source,
        'language': language,
        'option': options,
      };
}

class Option {
  int id;
  String text;
  String picture;
  String explanation;
  String explanationPicture;
  bool predicament;

  Option(
      {this.id,
      this.text,
      this.picture,
      this.explanation,
      this.explanationPicture,
      this.predicament});

  factory Option.fromJson(Map<String, dynamic> optionJson) {
    return Option(
      id: optionJson['id'],
      text: optionJson['text'],
      picture: optionJson['picture'],
      explanation: optionJson['explanation'],
      explanationPicture: optionJson['explanationPicture'],
      predicament: optionJson['predicament'],
    );
  }
  Map<String, dynamic> toJson() => {
        'id': id,
        'text': text,
        'picture': picture,
        'explanation': explanation,
        'explanationPicture': explanationPicture,
        'predicament': predicament
      };
}

class Test {
  String name;
  int id;
  var time;
  double totalMarks;
  String published;
  int totalTime;
  List<Subject> subjects;
  List<Chapter> chapters;
  List<Question> questions;

  Test(
      {this.name,
      this.id,
      this.time,
      this.totalMarks,
      this.published,
      this.subjects,
      this.chapters,
      this.totalTime,
      this.questions});

  factory Test.fromJson(Map<String, dynamic> json) {
    return Test(
        id: json['id'],
        name: json['name'],
        time: json['time'],
        totalMarks: json['totalMarks'],
        published: json['published'],
        subjects: parseSubjects(json['subjects']),
        chapters: parseChapters(json['chapters']),
        totalTime: json['time'],
        questions: parseQuestions(json['questions']));
  }
  static List<Question> parseQuestions(question_json) {
    var question_list = question_json as List;
    List<Question> questionList =
        question_list.map((data) => Question.fromJson(data)).toList();
    return questionList;
  }

  static List<Subject> parseSubjects(subjectJson) {
    var subject_list = subjectJson as List;
    List<Subject> subjectList =
        subject_list.map((data) => Subject.fromJson(data)).toList();
    return subjectList;
  }

  static List<Chapter> parseChapters(chapterJson) {
    var chapter_list = chapterJson as List;
    List<Chapter> chapterList =
        chapter_list.map((data) => Chapter.fromJson(data)).toList();
    return chapterList;
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'time':time,
        'totalMarks': totalMarks,
        'published': published,
        'subjects': subjects,
        'chapters': chapters,
        'totalTime': totalTime,
        'questions': questions,
      };
}

class TestSubmitData {
  var performance;

  TestSubmitData({this.performance});
  factory TestSubmitData.fromJson(Map<String, dynamic> json) {
    return TestSubmitData(
      performance: json['marks'],
    );
  }

  Map<String, dynamic> toJson() => {
        'performance': performance,
      };
}