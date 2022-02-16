import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({Key? key}) : super(key: key);

  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  static const dayInMillis = 24 * 60 * 60 * 1000;
  static const _rowHeight = 100.0;
  final _controller = ScrollController(
    initialScrollOffset:
        DateTime.now().millisecondsSinceEpoch / dayInMillis / 7 * _rowHeight,
  );
  var current = DateTime.now();
  late final _localizations = MaterialLocalizations.of(context);

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      DateTime dt = getDateByOffset(_controller.offset);
      if (dt != current) {
        setState(() {
          current = dt;
        });
      }
    });
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      _today();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final yoils = _yoil();
    return Scaffold(
      appBar: AppBar(
        title: Text(DateFormat.yMMMM().format(current)),
        elevation: 0,
        actions: [
          IconButton(
            onPressed: _today,
            icon: const Icon(Icons.today),
          ),
          IconButton(
            onPressed: _goto,
            icon: const Icon(Icons.date_range),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            height: 26,
            decoration: const BoxDecoration(
              color: Colors.blue,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: yoils
                  .map((e) => Expanded(
                          child: Text(
                        e,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                      )))
                  .toList(),
            ),
          ),
          Expanded(
            child: GridView.builder(
              controller: _controller,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: yoils.length,
                mainAxisExtent: _rowHeight,
              ),
              itemBuilder: (context, index) {
                return Item(
                  index: index,
                  activeDate: current,
                  date: getDateByIndex(index),
                  now: now,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  List<String> _yoil() {
    final offset = _localizations.firstDayOfWeekIndex;
    const yoils = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
    final list = <String>[];
    for (int i = 0; i < 7; i++) {
      list.add(yoils[(i + offset) % 7]);
    }
    return list;
  }

  void _today() {
    _scrollTo(DateTime.now());
  }

  void _goto() async {
    final dt = await showDatePicker(
      context: context,
      initialDate: current,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (dt != null) {
      _scrollTo(dt);
    }
  }

  void _scrollTo(DateTime to, [bool animate = true]) {
    // final firstDayOffset =
    // DateUtils.firstDayOffset(to.year, to.month, _localizations);
    // to = DateTime(to.year, to.month, 1).subtract(
    // Duration(days: firstDayOffset),
    // );

    final index = to.millisecondsSinceEpoch ~/ dayInMillis;
    final offset = index * _rowHeight / 7;
    if (animate) {
      _controller.animateTo(
        offset,
        duration: const Duration(milliseconds: 250),
        curve: Curves.ease,
      );
    } else {
      _controller.jumpTo(offset);
    }
  }

  DateTime? getDateByIndex(int index) {
    final firstDayOffset = DateUtils.firstDayOffset(1970, 1, _localizations);
    DateTime? dt;
    if (index >= firstDayOffset) {
      dt = DateUtils.dateOnly(DateTime.fromMillisecondsSinceEpoch(
        (index - firstDayOffset) * dayInMillis,
      ));
    }
    return dt;
  }

  DateTime getDateByOffset(double offset) {
    final days = (offset) / _rowHeight * 7;
    final dt = DateTime.fromMillisecondsSinceEpoch(
      (dayInMillis * days).toInt(),
    );
    return DateUtils.dateOnly(dt);
  }
}

class Item extends StatelessWidget {
  const Item({
    Key? key,
    required this.index,
    required this.activeDate,
    required this.date,
    required this.now,
  }) : super(key: key);
  final int index;
  final DateTime? date;
  final DateTime activeDate;
  final DateTime now;

  @override
  Widget build(BuildContext context) {
    Color? color;
    if (!DateUtils.isSameMonth(activeDate, date)) {
      color = Colors.grey[300];
    }
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: color,
        border: Border(
          bottom: const BorderSide(color: Colors.grey),
          right: index % 7 == 6
              ? BorderSide.none
              : const BorderSide(color: Colors.grey),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            alignment: Alignment.topRight,
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: DateUtils.isSameDay(now, date) ? Colors.blue : null,
            ),
            child: Text(
              DateFormat.Md().format(date ?? now),
            ),
          ),
        ],
      ),
    );
  }
}
