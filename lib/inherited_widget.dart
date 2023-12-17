import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

// using this counter inherited widget all widget can access the counter variable
class CounterInheritedWidget extends InheritedWidget {
  final int counter;
  final _UpdateCounterState updateCounterState;

  const CounterInheritedWidget({
    Key? key,
    required Widget child,
    required this.counter,
    required this.updateCounterState,
  }) : super(key: key, child: child);

  // of method is used to access the counter from the context of widget type CounterInheritedWidget
  static _UpdateCounterState? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<CounterInheritedWidget>()?.updateCounterState;
  }

// everytime our state changes we return true (then UI is updated)  else false, compare the old data to the new data
  @override
  bool updateShouldNotify(CounterInheritedWidget oldWidget) => oldWidget.counter != counter;
}

class UpdateCounterState extends StatefulWidget {
  final Widget child;
  const UpdateCounterState({required this.child, super.key});

  @override
  State<UpdateCounterState> createState() => _UpdateCounterState();
}

class _UpdateCounterState extends State<UpdateCounterState> {
  int counter = 0;

  void incrementCounter() {
    // call set state to update the UI
    setState(() {
      counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // The inherited widget is wrapped around the UpdateCounterState widget which is resposible for doing the update
    // The IW is immutable and can't change its state but the stateful widget can
    return CounterInheritedWidget(
      counter: counter,
      updateCounterState: this,
      child: widget.child,
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  final String title = 'Inherited Widget';

  @override
  Widget build(BuildContext context) {
    return UpdateCounterState(
      // all wigets below this can now access the inherited widget by simply calling it.
      // The state is located at the top in one location
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: title,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: MyHomePage(title: title),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String title;
  const MyHomePage({required this.title, super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    final counter = CounterInheritedWidget.of(context)?.counter; // accessing the state from another class
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }

  void incrementCounter() {
    final increment = CounterInheritedWidget.of(context);
    increment?.incrementCounter();
  }
}
