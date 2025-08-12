import 'package:flutter/material.dart';

import '../widgets/screen_background.dart';
import '../widgets/tm_app_bar.dart';

class ProgressTaskListScreen extends StatefulWidget {
  const ProgressTaskListScreen({super.key});

  @override
  State<ProgressTaskListScreen> createState() => _ProgressTaskListScreenState();
}

class _ProgressTaskListScreenState extends State<ProgressTaskListScreen> {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: const TMAppBar(),
      body: ScreenBackground(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: _buildListViewBuilder(),
        ),
      ),
    );
  }

  Widget _buildListViewBuilder() {
    return ListView.builder(
      itemCount: 10,
      itemBuilder: (context, index) {
        //return TaskItemWidget();
      },
    );
  }
}
