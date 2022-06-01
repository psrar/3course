import 'dart:convert';
import 'dart:io';

import 'package:archive/archive.dart';
import 'package:diary/models.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:spreadsheet_decoder/spreadsheet_decoder.dart';

import 'package:tuple/tuple.dart';
import 'package:xml/xml.dart';

//первый хэшмап - группы, второй - список распознанных предметов, 3 - учителя, 4 - аудитории, 5 - расписания
Tuple2<List<Map<int, String>>, List<Map<String, dynamic>>> sheduleDomain(
    SpreadsheetDecoder decoder) {
  var table = decoder.tables.values.first;

  var result = [
    <int, String>{},
    <int, String>{},
    <int, String>{},
    <int, String>{},
  ];

  String? findRoomForCell(int row, int column) {
    String? element;
    for (var i = column; i < column + 4; i++) {
      if (table.rows[2][i] == 'ауд') {
        element = table.rows[row][i].toString();
        if (element == 'null') {
          return null;
        }
        if (!result[3].values.contains(element)) {
          result[3].addAll({result[3].length: element});
        }
        return element;
      }
    }
    element = 'r$row-c$column?';
    if (!result[3].values.contains(element)) {
      result[3].addAll({result[3].length: element});
    }

    return element;
  }

  Map<int, String>? resolveTeacher(String? teacher) {
    if (teacher == null) {
      return null;
    }

    for (var i = 0; i < result[2].length; i++) {
      var name = result[2][i]!.replaceAll(' ', '');
      var surname = result[2][i]!.split(' ').first;

      var name2 = teacher.replaceAll(' ', '');
      var surname2 = teacher.split(' ').first;
      if (name == name2) {
        // Проверка на отсутствие пробелов
        if (result[2][i]!.length > teacher.length) {
          return {i: result[2][i]!};
        } else {
          result[2][i] = teacher;
          return {i: teacher};
        }
      } else if (name.length != name2.length && surname == surname2) {
        // Проверка на пропущенные инициалы
        if (result[2][i]!.length > teacher.length) {
          return {i: result[2][i]!};
        } else {
          result[2][i] = teacher;
          return {i: teacher};
        }
      }
    }

    var res = {result[2].length: teacher};
    if (!result[2].values.contains(res.values.single)) {
      result[2].addAll(res);
      return res;
    }
  }

  Tuple2<Map<int, String>?, Map<int, String>?>? findLessonAndTeacher(
      int row, int column) {
    var element = table.rows[row][column];
    if (element == null) {
      return null;
    } else {
      var strs = element.toString().split('\n');
      Map<int, String>? lesson;
      Map<int, String>? teacher;
      String lessonName = '';

      for (var name in strs) {
        if (name.contains(RegExp(
            r'(([а-яА-Я]+ [а-яА-Я]\. [а-яА-Я]\.)|([а-яА-Я]+ [а-яА-Я]\.[а-яА-Я]\.))'))) {
          name = name.replaceAll(RegExp(r'((, )|,)'), '');
          if (teacher == null) {
            teacher = resolveTeacher(name);
          } else {
            teacher = null;
            resolveTeacher(name);
          }
        } else {
          if (strs.last.contains(RegExp(r'([А-Я][а-я]+, [А-Я][а-я]+)'))) {
            for (var name in strs.last.split(', ')) {
              resolveTeacher(name);
              teacher = null;
            }
          } else {
            lessonName += name;
          }
        }
      }

      for (var les in result[1].entries) {
        if (les.value == lessonName) {
          lesson = {les.key: les.value};
        }
      }

      if (lesson == null) {
        lesson = {result[1].length: lessonName};
        result[1].addAll(lesson);
      }

      return Tuple2(lesson, teacher);
    }
  }

  // Tuple3<int, List<Map<String, dynamic>>, List<Map<String, dynamic>>>
  //     shedule;
  List<Map<String, dynamic>> weekShedule = [];
  int weekSheduleid = 0;
  int lessonid = 0;
  int groupnum;

  // ПАРСИНГ СИЛА
  for (var i = 0; i < table.rows[2].length; i++) {
    var element = table.rows[2][i];
    if (element != null &&
        element != 'время' &&
        element != 'ауд' &&
        !result[0].values.contains(element)) {
      groupnum = result[0].length;
      var group = {groupnum: element};
      result[0].addAll({group.keys.single: element});
      weekShedule.add({
        'id': weekSheduleid++,
        'group': group,
        'upweek': <int, dynamic>{},
        'downweek': <int, dynamic>{}
      });

      //Цикл для всей недели для одной группы
      for (var d = 0; d < 6; d++) {
        var upDayShedule = <String, dynamic>{
          'id': d + groupnum * 12,
          'daynum': null,
          'monthnum': null,
          'timeshedule': null,
          'weekday': d + 1,
          'lessons': List<Map<String, dynamic>>
        };
        var downDayShedule = <String, dynamic>{
          'id': d + 6 + groupnum * 12,
          'daynum': null,
          'monthnum': null,
          'timeshedule': null,
          'weekday': d + 1,
          'lessons': List<Map<String, dynamic>>
        };

        List<Map<String, dynamic>> lessons = [];
        //Цикл для верхней недели, на день
        for (var r = 0; r < 6; r++) {
          var rr = 3 + 12 * d + r * 2;
          var cell = findLessonAndTeacher(rr, i);

          if (cell == null) {
            lessons.add({
              'id': lessonid++,
              'queue': r + 1,
              'subject': null,
              'teacher': null,
              'room': null
            });
          } else {
            lessons.add({
              'id': lessonid++,
              'queue': r + 1,
              'subject': cell.item1,
              'teacher': cell.item2,
              'room': findRoomForCell(rr, i)
            });
          }
        }
        upDayShedule['lessons'] = lessons;
        (weekShedule.last['upweek'] as Map<int, dynamic>)
            .addAll({d + 1: upDayShedule});

        lessons = [];
        //Цикл для нижней недели
        for (var r = 0; r < 6; r++) {
          var rr = 4 + 12 * d + r * 2;
          var cell = findLessonAndTeacher(rr, i);

          if (cell == null) {
            lessons.add({
              'id': lessonid++,
              'queue': r + 1,
              'subject': null,
              'teacher': null,
              'room': null
            });
          } else {
            lessons.add({
              'id': lessonid++,
              'queue': r + 1,
              'subject': cell.item1,
              'teacher': cell.item2,
              'room': findRoomForCell(rr, i)
            });
          }
        }
        downDayShedule['lessons'] = lessons;
        (weekShedule.last['downweek'] as Map<int, dynamic>)
            .addAll({d + 1: downDayShedule});
      }
    }
  }

// Нахождение похожих предметов
//   var regExp = RegExp(r'([А-Я]+.\d\d.\d\d )');
//   for (var i = 0; i < result[1].length; i++) {
//     var name = result[1][i];

//     for (var k = i + 1; k < result[1].length; k++) {
//       var name2 = result[1][k];
//       var a = regExp.stringMatch(name);
//       if (a != null &&
//           a == regExp.stringMatch(name2) &&
//           levenshtein(name, name2) < 2) {
//         print("'$name' [$i] похоже на '$name2' [$k]");
//       }
//     }
//   }

  return Tuple2(result, weekShedule);
}

Tuple2<SimpleDate, List<Tuple2<String, List<Tuple2<String, String?>?>>>>
    parseReplacements(FilePickerResult result) {
  List<Tuple2<String, List<Tuple2<String, String?>?>>> replacements = [];

  late List<int> fileBytes;
  if (!kIsWeb && Platform.isAndroid) {
    fileBytes = File(result.files.first.path!).readAsBytesSync();
  } else {
    fileBytes = List.from(result.files.first.bytes!);
  }
  final archive = ZipDecoder().decodeBytes(fileBytes);
  for (final file in archive) {
    if (file.name == 'word/document.xml') {
      file.decompress();
      final xml = XmlDocument.parse(utf8.decode(file.content as List<int>));

      for (var table in xml.findAllElements('w:tbl')) {
        var row = table.findAllElements('w:tr').first;
        var columns = row
            .findAllElements('w:tc')
            .map((e) => e.findAllElements('w:t').map((e) => e.text).join())
            .toList();

        for (var i = 0; i < columns.length; i++) {
          var group = RegExp(r'([а-яА-Я]+-[1-9]+)').stringMatch(columns[i]);
          if (group != null) {
            List<Tuple2<String, String?>?> lessons = [];
            var rows = table.findAllElements('w:tr').toList();
            for (var k = 1; k < rows.length; k += 2) {
              var val = rows[k]
                  .findAllElements('w:tc')
                  .map((e) =>
                      e.findAllElements('w:t').map((e) => e.text).join(' '))
                  .toList()[i];
              var lval = val.toLowerCase();
              if (lval.isEmpty ||
                  lval.replaceAll(' ', '') == 'группаотпущена') {
                lessons.add(null);
              } else if (lval.contains(
                  RegExp(r'(пп)|(практика)|(производственная практика)'))) {
                var room = RegExp(r'([0-9]+|вц)').allMatches(lval);
                val = 'Практика';
                if (room.length != 1) {
                  lessons.add(Tuple2(val, null));
                  lessons.add(Tuple2(val, null));
                  lessons.add(Tuple2(val, null));
                  k += 2;
                } else {
                  lessons.add(Tuple2(val, room.single[0]));
                  lessons.add(Tuple2(val, room.single[0]));
                  lessons.add(Tuple2(val, room.single[0]));
                  k += 2;
                }
              } else {
                var room = rows[k + 1]
                    .findAllElements('w:tc')
                    .map((e) =>
                        e.findAllElements('w:t').map((e) => e.text).join(' '))
                    .toList()[i];
                lessons.add(Tuple2(val, room));
              }
            }
            replacements.add(Tuple2(group, lessons));
          }
        }
      }

      break;
    }
  }

  var date =
      RegExp(r'([0-9]+_[0-9]+)').stringMatch(result.names.first!)!.split('_');
  return Tuple2(
      SimpleDate(int.parse(date.first), Month.all[int.parse(date.last) - 1]),
      replacements);
}
