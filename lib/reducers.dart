import 'package:leancloud_feedback/leancloud_feedback.dart';
import 'package:redux/redux.dart';

import 'actions.dart';
import 'model.dart';

AppState appReducer(AppState appState, action) {
  return AppState(
      threads: listReducer(appState.threads, action),
      messages: detailReducer(appState.messages, action),
      isLoadingList: loadingListReducer(appState.isLoadingList, action),
      isLoadingDetail: loadingDetailReducer(appState.isLoadingDetail, action),
      currentThreadId: threadIdReducer(appState.currentThreadId, action));
}

final loadingListReducer = combineReducers<bool>([
  TypedReducer<bool, LoadListAction>(_loadList),
]);

final loadingDetailReducer = combineReducers<bool>([
  TypedReducer<bool, LoadDetailAction>(_loadDetail),
]);

bool _loadList(bool isLoadingList, LoadListAction action) {
  return action.isLoadingList;
}

bool _loadDetail(bool isLoadingDetail, LoadDetailAction action) {
  return action.isLoadingDetail;
}

final listReducer = combineReducers<List<Thread>>([
  TypedReducer<List<Thread>, ListLoadedAction>(_listLoaded),
]);

final detailReducer = combineReducers<List<Message>>([
  TypedReducer<List<Message>, DetailLoadedAction>(_detailLoaded),
]);

final threadIdReducer = combineReducers<String>([
  TypedReducer<String, LoadDetailAction>(_getThreadId),
]);

String _getThreadId(String state, LoadDetailAction action) {
  return action.threadId;
}

List<Thread> _listLoaded(List<Thread> state, ListLoadedAction action) {
  return action.feedbacks;
}

List<Message> _detailLoaded(List<Message> state, DetailLoadedAction action) {
  return action.details;
}
