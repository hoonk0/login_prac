
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TabBook extends ConsumerStatefulWidget {
  const TabBook({super.key});

  @override
  ConsumerState<TabBook> createState() => _TabBookState();
}

class _TabBookState extends ConsumerState<TabBook> {

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