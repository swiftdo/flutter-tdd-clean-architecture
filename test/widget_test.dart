import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:my_flutter_app/main.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that our counter starts at 0.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify that our counter has incremented.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });

  testWidgets('Find specific widget', (WidgetTester tester) async {
    // 创建测试环境
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Column(
            children: [
              Text('Hello, Flutter!'),
              ElevatedButton(onPressed: () {}, child: Text('Click me')),
            ],
          ),
        ),
      ),
    );

    // 查找文本 'Hello, Flutter!'
    final textFinder = find.text('Hello, Flutter!');

    // 查找 ElevatedButton
    final buttonFinder = find.byType(ElevatedButton);

    // 断言查找是否成功
    expect(textFinder, findsOneWidget);
    expect(buttonFinder, findsOneWidget);
  });

  testWidgets('Find widget by Key', (WidgetTester tester) async {
    const testKey = Key('test_button');

    // 创建测试环境
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ElevatedButton(
            key: testKey,
            onPressed: () {},
            child: Text('Click me'),
          ),
        ),
      ),
    );

    // 查找 Key 为 'test_button' 的 ElevatedButton
    final buttonFinder = find.byKey(testKey);

    // 断言查找是否成功
    expect(buttonFinder, findsOneWidget);
  });

  testWidgets('Find descendant widget', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Column(
            children: [
              Container(
                child: Text('Child Widget'),
              ),
            ],
          ),
        ),
      ),
    );

    // 定位 Container 的子级 Text
    final containerFinder = find.byType(Container);
    final textFinder = find.descendant(
      of: containerFinder,
      matching: find.text('Child Widget'),
    );

    expect(textFinder, findsOneWidget);
  });

  testWidgets('Find widget with specific conditions', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Column(
            children: [
              ElevatedButton(onPressed: () {}, child: Text('Click me')),
              ElevatedButton(onPressed: () {}, child: Text('Click me2')),
            ],
          ),
        ),
      ),
    );

    // 自定义条件查找 ElevatedButton
    final customFinder = find.byWidgetPredicate((Widget widget) {
      return widget is ElevatedButton && widget.child is Text;
    });

    expect(customFinder, findsNWidgets(2));
  });

  testWidgets('Tap button', (WidgetTester tester) async {
    bool pressed = false;

    await tester.pumpWidget(
      MaterialApp(
        home: ElevatedButton(
          onPressed: () {
            pressed = true;
          },
          child: Text('Tap me'),
        ),
      ),
    );

    // 定位按钮
    final buttonFinder = find.text('Tap me');

    // 模拟点击
    await tester.tap(buttonFinder);
    await tester.pump();

    // 检查点击效果
    expect(pressed, true);
  });


  testWidgets('Test vertical scrolling', (WidgetTester tester) async {
    // 创建包含大量列表项的 ListView
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ListView.builder(
            itemCount: 50,
            itemBuilder: (context, index) => ListTile(title: Text('Item $index')),
          ),
        ),
      ),
    );

    // 验证初始状态
    expect(find.text('Item 0'), findsOneWidget);
    expect(find.text('Item 49'), findsNothing);

    // 模拟向上滚动
    await tester.drag(find.byType(ListView), const Offset(0, -300));
    await tester.pump();

    // 验证滚动后的状态
    expect(find.text('Item 0'), findsNothing);
    expect(find.text('Item 10'), findsOneWidget);
  });

  testWidgets('Test fling scrolling', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ListView.builder(
            itemCount: 100,
            itemBuilder: (context, index) => ListTile(title: Text('Item $index')),
          ),
        ),
      ),
    );

    // 验证初始状态
    expect(find.text('Item 0'), findsOneWidget);
    expect(find.text('Item 99'), findsNothing);

    // 模拟快速向上滚动
    await tester.fling(find.byType(ListView), const Offset(0, -4000), 3000);
    await tester.pumpAndSettle(); // 等待滚动完成

    // 验证滚动结束后状态
    expect(find.text('Item 0'), findsNothing);
    expect(find.text('Item 99'), findsOneWidget);
  });

  testWidgets('Test Scrollbar visibility', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Scrollbar(
            child: ListView.builder(
              itemCount: 100,
              itemBuilder: (context, index) => ListTile(title: Text('Item $index')),
            ),
          ),
        ),
      ),
    );

    // 模拟滚动
    await tester.drag(find.byType(ListView), const Offset(0, -200));
    await tester.pump();

    // 验证滚动条是否显示
    expect(find.byType(Scrollbar), findsOneWidget);
  });

  testWidgets('Simulate network request', (WidgetTester tester) async {
    bool isLoading = true;
    String result = '';

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: FutureBuilder<String>(
            future: Future.delayed(Duration(seconds: 1), () => 'Data Loaded'),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshot.hasData) {
                result = snapshot.data!;
                isLoading = false;
                return Text(result);
              }
              return Container();
            },
          ),
        ),
      ),
    );

    // 验证加载状态
    expect(isLoading, true);

    // 等待 Future 完成
    await tester.pumpAndSettle();

    // 验证加载后的数据
    expect(result, 'Data Loaded');
  });





}
