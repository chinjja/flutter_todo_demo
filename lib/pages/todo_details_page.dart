import 'package:flutter_todo_demo/model/types.dart';
import 'package:flutter/material.dart';

class TodoDetailsPage extends StatelessWidget {
  static const routeName = '/todo_details';
  const TodoDetailsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final item = ModalRoute.of(context)!.settings.arguments as Todo;
    final title = TextEditingController(text: item.title);
    final memo = TextEditingController(text: item.memo);
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(
          context,
          item.copy(
            title: title.text,
            memo: memo.text,
          ),
        );
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          actions: [
            _delete(context),
          ],
        ),
        body: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 24,
          ),
          child: Column(
            children: [
              TextField(
                controller: title,
                decoration: const InputDecoration(
                  isDense: true,
                  contentPadding: EdgeInsets.all(0),
                  border: InputBorder.none,
                  hintText: 'Title',
                ),
                style: Theme.of(context).textTheme.headline5,
              ),
              const SizedBox(height: 28),
              Expanded(
                child: TextField(
                  maxLines: null,
                  autofocus: true,
                  controller: memo,
                  decoration: const InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.all(0),
                    border: InputBorder.none,
                    hintText: 'Memo',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _delete(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.delete),
      onPressed: () async {
        Navigator.pop(context);
      },
    );
  }
}
