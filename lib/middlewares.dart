import 'package:redux/redux.dart';
import 'package:leancloud_feedback/leancloud_feedback.dart';

import 'actions.dart';
import 'model.dart';

List<Middleware<AppState>> createListMiddleware() {
  return [
    TypedMiddleware<AppState, LoadListAction>(fetchListFromNetwork()),
    TypedMiddleware<AppState, LoadDetailAction>(fetchDetailFromNetwork()),
    TypedMiddleware<AppState, DevAppendTextAction>(devAppendText()),
  ];
}

Middleware<AppState> devAppendText() {
  return (Store<AppState> store, action, next) async {
    var response = await devAppendMessage(action.threadId, action.text);
    //LeanCloud use user's (not dev's) update time as [updatedAt] field.
    //Send a user message to update [updatedAt] field as a workaround.
    await userAppendMessage(action.threadId, 'user');

    if (response != null) {
      store.dispatch(
        DetailLoadedAction(
          List.from(store.state.messages)
            ..add(
              Message(content: action.text, type: 'dev'),
            ),
        ),
      );
    }
  };
}

Middleware<AppState> fetchDetailFromNetwork() {
  return (Store<AppState> store, action, next) {
    next(action);

    if (!action.isLoadingDetail) return;

    fetchMessages(action.threadId).then((value) {
      store.dispatch(LoadDetailAction(action.threadId, false));
      var detailList =
          value.where((element) => element.content != 'user').toList();
      store.dispatch(
        DetailLoadedAction(detailList),
      );
    });
  };
}

Middleware<AppState> fetchListFromNetwork() {
  return (Store<AppState> store, action, next) {
    next(action);

    if (!action.isLoadingList) return;

    fetchAllThreads().then((response) {
      store.dispatch(LoadListAction(false));

      //Change UTC time to Local time.
      response.forEach((element) {
        element.createdAt = DateTime.parse(element.createdAt)
            .add(DateTime.now().timeZoneOffset)
            .toString();

        element.updatedAt = DateTime.parse(element.updatedAt)
            .add(DateTime.now().timeZoneOffset)
            .toString();
      });

      //Reverse list to sort by the lastest time.
      store.dispatch(
        ListLoadedAction(response.reversed.toList()),
      );
    });
  };
}
