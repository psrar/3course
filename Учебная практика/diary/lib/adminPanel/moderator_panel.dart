import 'dart:developer';

import 'package:diary/adminPanel/subjects_view.dart';
import 'package:diary/adminPanel/teachers_view.dart';
import 'package:diary/database/database_interface.dart';
import 'package:diary/overview_page.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:spreadsheet_decoder/spreadsheet_decoder.dart';

import 'shedule_worker.dart';

class ModeratorPanel extends StatefulWidget {
  const ModeratorPanel({Key? key}) : super(key: key);

  @override
  State<ModeratorPanel> createState() => _ModeratorPanelState();
}

class _ModeratorPanelState extends State<ModeratorPanel> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Панель модератора',
          style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: IconButton(
                splashRadius: 18,
                onPressed: () {
                  DatabaseWorker.currentUserNotifier.value = null;
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const OverviewPage()),
                      (route) => false);
                },
                icon: const Icon(
                  Icons.logout_outlined,
                  color: Colors.orange,
                )),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ColoredTextButton(
                onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const TeachersView(),
                    )),
                text: 'Преподаватели',
                color: const Color(0xFF2ec4b6)),
            const SizedBox(height: 8),
            ColoredTextButton(
                onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const SubjectsView())),
                text: 'Предметы',
                color: Theme.of(context).primaryColorLight),
          ],
        ),
      ),
    );
  }
}

class ColoredTextButton extends StatelessWidget {
  final Function onPressed;
  final Color color;
  final String text;
  const ColoredTextButton(
      {Key? key,
      required this.onPressed,
      required this.text,
      required this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: () => onPressed.call(),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(text,
              style: const TextStyle(color: Colors.white, fontSize: 16)),
        ),
        style: TextButton.styleFrom(
            backgroundColor: color,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            primary: Colors.white));
  }
}
