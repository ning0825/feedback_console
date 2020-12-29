import 'package:leancloud_feedback/leancloud_feedback.dart';

class LoadListAction {
  LoadListAction(this.isLoadingList);

  final bool isLoadingList;
}

class ListLoadedAction {
  ListLoadedAction(this.feedbacks);

  final List<Thread> feedbacks;
}

class LoadDetailAction {
  LoadDetailAction(this.threadId, this.isLoadingDetail);

  final String threadId;
  final bool isLoadingDetail;
}

class DetailLoadedAction {
  DetailLoadedAction(this.details);

  final List<Message> details;
}

class DevAppendTextAction {
  DevAppendTextAction(this.text, this.threadId);

  final String text;
  final String threadId;
}
