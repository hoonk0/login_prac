
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TabProfile extends ConsumerStatefulWidget {
  const TabProfile({super.key});

  @override
  ConsumerState<TabProfile> createState() => _TabBookState();
}

class _TabBookState extends ConsumerState<TabProfile> {

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