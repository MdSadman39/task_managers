import 'package:flutter/material.dart';
import 'package:task_managers/data/model/task_count_by_status_model.dart';
import 'package:task_managers/data/model/task_count_model.dart';
import 'package:task_managers/data/model/task_list_by_status_model.dart';
import 'package:task_managers/data/services/network_caller.dart';
import 'package:task_managers/ui/widgets/circular_progress_indicator.dart';
import 'package:task_managers/ui/widgets/snack_bar_message.dart';
import '../../data/utils/urls.dart';
import '../widgets/screen_background.dart';
import '../widgets/task_status_summary_counter_widget.dart';
import '../widgets/tasks_item_widget.dart';
import '../widgets/tm_app_bar.dart';
import 'add_new_task_list_screen.dart';

class NewTaskListScreen extends StatefulWidget {
  const NewTaskListScreen({super.key});

  @override
  State<NewTaskListScreen> createState() => _NewTaskListScreenState();
}

class _NewTaskListScreenState extends State<NewTaskListScreen> {
  bool _getTaskCountStatusInProgress = false;
  bool _getNewTaskListInProgress = false;

  TaskCountByStatusModel? taskCountByStatusModel;
  TaskListByStatusModel? newTaskListModel;

  @override
  void initState() {
    super.initState();
    _getTaskCountByStatus();
    _getNewTaskList();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: const TMAppBar(),
      body: ScreenBackground(
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildTasksStatusSummaryByStatus(),
              Visibility(
                visible: _getNewTaskListInProgress == false,
                replacement: const CenteredCircularProgressIndicator(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: _buildListViewBuilder(),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, AddNewTaskListScreen.name);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildListViewBuilder() {
    return ListView.builder(
      shrinkWrap: true,
      primary: false,
      itemCount: newTaskListModel?.taskList?.length ?? 0,
      itemBuilder: (context, index) {
        return TaskItemWidget(taskModel: newTaskListModel!.taskList![index]);
      },
    );
  }

  Widget _buildTasksStatusSummaryByStatus() {
    return Visibility(
      visible: _getTaskCountStatusInProgress == false,
      replacement: const CenteredCircularProgressIndicator(),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          height: 100,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: taskCountByStatusModel?.taskByStatusList?.length ?? 0,
            itemBuilder: (context, index) {
              final TaskCountModel model =
                  taskCountByStatusModel!.taskByStatusList![index];
              return TaskStatusSummaryCounterWidget(
                title: model.sId ?? '',
                count: model.sum.toString(),
              );
            },
          ),
        ),
      ),
    );
  }

  Future<void> _getTaskCountByStatus() async {
    _getTaskCountStatusInProgress = true;
    setState(() {});
    final NetworkResponse response = await NetworkCaller.getRequest(
      url: Urls.taskCountByStatusUrl,
    );
    if (response.isSuccess) {
      taskCountByStatusModel = TaskCountByStatusModel.fromJson(
        response.responseData!,
      );
    } else {
      showSnackBarMessage(context, response.errorMessage);
    }
    _getTaskCountStatusInProgress = false;
    setState(() {});
  }

  Future<void> _getNewTaskList() async {
    _getNewTaskListInProgress = true;
    setState(() {});
    final NetworkResponse response = await NetworkCaller.getRequest(
      url: Urls.taskListByStatusUrl('New'),
    );
    _getNewTaskListInProgress = false;
    if (response.isSuccess) {
      newTaskListModel = TaskListByStatusModel.fromJson(response.responseData!);
    } else {
      showSnackBarMessage(context, response.errorMessage);
    }
    _getNewTaskListInProgress = false;
    setState(() {});
  }
}
