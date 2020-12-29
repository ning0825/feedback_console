import 'package:leancloud_feedback/leancloud_feedback.dart';

class AppState {
  AppState(
      {this.threads = const [],
      this.messages = const [],
      this.isLoadingList = false,
      this.isLoadingDetail = false,
      this.currentThreadId = ''});

  final bool isLoadingList;
  final bool isLoadingDetail;
  final List<Thread> threads;
  final List<Message> messages;
  final String currentThreadId;
}
