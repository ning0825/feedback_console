import 'package:feedback_console/actions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:leancloud_feedback/leancloud_feedback.dart';

import '../model.dart';
import '../screen_util.dart';

class FeedbackListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
        builder: (_, vm) {
          if (vm.isLoading) {
            return Text('loading');
          } else {
            var p = isPortrait(context);
            return ListView.builder(
                itemCount: vm.threads.length,
                itemBuilder: (_, index) {
                  return ListTile(
                    onTap: () =>
                        vm.onSelect(vm.threads[index].objectId, p, context),
                    hoverColor: Color(0xAADFDCDB),
                    tileColor:
                        vm.threads[index].objectId == vm.currentThreadId && !p
                            ? const Color(0xAAC6C6C6)
                            : Colors.transparent,
                    title: Text(vm.threads[index].content ?? ''),
                    subtitle: Text(vm.threads[index].updatedAt ?? ''),
                  );
                });
          }
        },
        converter: _ViewModel.fromStore);
  }
}

class _ViewModel {
  final List<Thread> threads;
  final bool isLoading;
  final void Function(String threadId, bool isPortrait, BuildContext context)
      onSelect;
  final String currentThreadId;

  _ViewModel(
      {@required this.threads,
      @required this.isLoading,
      @required this.onSelect,
      this.currentThreadId});

  static _ViewModel fromStore(Store<AppState> store) {
    return _ViewModel(
      threads: store.state.threads,
      isLoading: store.state.isLoadingList,
      onSelect: (threadId, isPortrait, context) {
        store.dispatch(
          LoadDetailAction(threadId, true),
        );

        if (isPortrait) Navigator.of(context).pushNamed('/detail');
      },
      currentThreadId: store.state.currentThreadId,
    );
  }
}
