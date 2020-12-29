import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import '../actions.dart';
import '../model.dart';

class RefreshButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
        builder: (_, vm) => IconButton(
              icon: Icon(Icons.refresh),
              onPressed: vm.onRequestRefresh,
            ),
        converter: _ViewModel.fromStore);
  }
}

class _ViewModel {
  _ViewModel({@required this.onRequestRefresh});

  final void Function() onRequestRefresh;

  static _ViewModel fromStore(Store<AppState> store) {
    return _ViewModel(
      onRequestRefresh: () {
        store.dispatch(LoadListAction(true));
      },
    );
  }
}
