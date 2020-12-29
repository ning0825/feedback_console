import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:leancloud_feedback/leancloud_feedback.dart';
import 'package:redux/redux.dart';

import '../actions.dart';
import '../model.dart';

class DetailView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
        builder: (context, vm) {
          if (vm.isLoadingDetail) {
            return Text('loading');
          } else {
            return ConversationWidget(
              messages: vm.details,
              onSendText: vm.onSendText,
              role: 'dev',
            );
          }
        },
        converter: _ViewModel.fromStore);
  }
}

class _ViewModel {
  _ViewModel(this.details, this.isLoadingDetail, this.onSendText);

  final List<Message> details;
  final bool isLoadingDetail;
  final void Function(String text) onSendText;

  static _ViewModel fromStore(Store<AppState> store) {
    return _ViewModel(store.state.messages, store.state.isLoadingDetail,
        (text) {
      store.dispatch(DevAppendTextAction(text, store.state.currentThreadId));
    });
  }
}
