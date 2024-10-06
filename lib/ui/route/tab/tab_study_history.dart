
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TabStudyHistory extends ConsumerStatefulWidget {
  const TabStudyHistory({super.key});

  @override
  ConsumerState<TabStudyHistory> createState() => _TabBookState();
}

class _TabBookState extends ConsumerState<TabStudyHistory> {

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GestureDetector(
        child: Container(
          color: Colors.transparent,
          child: Text('tab0'),
        ),
      ),
    );
  }
}