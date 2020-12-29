import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:leancloud_feedback/leancloud_feedback.dart';

import 'actions.dart';
import 'widgets/conversation.dart';
import 'widgets/feedback_listview.dart';
import 'widgets/refresh_button.dart';
import 'middlewares.dart';
import 'model.dart';
import 'reducers.dart';
import 'screen_util.dart';

main() {
  WidgetsFlutterBinding.ensureInitialized();

  //Initialize LCFBUtil.
  initLCFeedback(
      appID: 'Cxnu5I4C5XslUk8gONphiicP-gzGzoHsz',
      appKey: 'YeyF6FxUjRx2Wp4f5maUfsEf',
      serverUrl: 'https://cxnu5i4c.lc-cn-n1-shared.com/1.1');

  runApp(MainApp(
    store: Store<AppState>(
      appReducer,
      initialState: AppState(),
      middleware: createListMiddleware(),
    ),
  ));
}

class MainApp extends StatelessWidget {
  MainApp({@required this.store});

  final Store<AppState> store;

  @override
  Widget build(BuildContext context) {
    return StoreProvider<AppState>(
      store: store,
      child: MaterialApp(
        routes: {
          '/': (context) {
            return MainPage(
              onInit: () => StoreProvider.of<AppState>(context).dispatch(
                LoadListAction(true),
              ),
            );
          },
          '/detail': (context) {
            return Scaffold(
              appBar: AppBar(
                automaticallyImplyLeading: true,
              ),
              body: DetailPage(),
            );
          }
        },
      ),
    );
  }
}

class MainPage extends StatefulWidget {
  MainPage({@required this.onInit});

  final void Function() onInit;

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final appBar = AppBar(
    title: Text('Feedback console'),
    backgroundColor: Colors.white,
    textTheme: TextTheme(
      headline6: TextStyle(color: Colors.black),
    ),
  );

  double width = 400;

  @override
  void initState() {
    super.initState();
    widget.onInit();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      body: isPortrait(context) ? ListPage() : _buildWideLayout(),
    );
  }

  _buildWideLayout() {
    return Row(
      children: [
        LayoutBuilder(
          builder: (context, constraints) {
            return Container(
              width: width,
              height: constraints.maxWidth,
              child: ListPage(),
            );
          },
        ),
        MouseRegion(
          cursor: SystemMouseCursors.resizeColumn,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onHorizontalDragUpdate: (details) {
              setState(() {
                width += details.delta.dx;
              });
            },
            child: Container(
              child: SizedBox(
                width: 10,
                height: double.maxFinite,
              ),
            ),
          ),
        ),
        Expanded(
          child: DetailPage(),
        ),
      ],
    );
  }
}

class ListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        RefreshButton(),
        Expanded(child: FeedbackListView()),
      ],
    );
  }
}

class DetailPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DetailView();
  }
}
