import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
  Get.put(TodoController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Scaffold(
        body: TodoAppWidget(),
      ),
    );
  }
}

class TodoAppWidget extends StatelessWidget {
  const TodoAppWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 56,
        ),
        TodoCard(group: Group.toDo, content: "To Do", isSelected: true),
        TodoCard(group: Group.toSchedule, content: "To Scedule", isSelected: false),
        TodoCard(group: Group.toDelete, content: "To Delegate", isSelected: false),
        TodoCard(group: Group.toDelegate, content: "To Delete", isSelected: false),
      ],
    );
  }
}

class TodoController extends GetxController {
  final list = <TodoCard>[].obs;

  void addItem(TodoCard todoCard) {
    list.add(todoCard);
  }

  void isSelected(TodoCard todoCard) {
    for(var i = 0; i < list.length; i++) {
      if(list[i].group == todoCard.group) {
        list[i].isSelected = true;
      } else {
        list[i].isSelected = false;
      }
    }
  }
}

enum Group { toDo, toSchedule, toDelegate, toDelete }

(Color, Color) getGroupColors(Group group) {
  switch (group) {
    case Group.toDo:
      return (
        Color.fromRGBO(255, 129, 129, 1),
        Color.fromRGBO(208, 244, 164, 1)
      );
    case Group.toSchedule:
      return (
        Color.fromRGBO(208, 244, 164, 1),
        Color.fromRGBO(102, 119, 187, 1)
      );
    case Group.toDelegate:
      return (
        Color.fromRGBO(234, 255, 208, 1),
        Color.fromRGBO(210, 151, 243, 1)
      );
    case Group.toDelete:
      return (
        Color.fromRGBO(149, 225, 211, 1),
        Color.fromRGBO(226, 124, 127, 1)
      );
  }
}

class TodoCard extends StatefulWidget {
  TodoCard({
    super.key,
    required this.group,
    required this.content,
    required this.isSelected,
  });

  final Group group;
  final String content;
  bool isSelected;



  @override
  State<TodoCard> createState() => _TodoCardState();
}

class _TodoCardState extends State<TodoCard> {
  final todoController = Get.put(TodoController());

  @override
  Widget build(BuildContext context) {
    final (bg, fg) = getGroupColors(widget.group);
    return GestureDetector(
      onTap: () {
        setState(() {
          widget.isSelected = !widget.isSelected;
        });
      },
      child: Row(
        children: [
          Flexible(
            flex: 1,
            child: Container(
              height: widget.isSelected ? 300 : 100,
              color: bg,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${widget.content}',
                        style: TextStyle(
                          color: fg,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Visibility(
                        visible: true,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AddPage(),
                                ));
                          },
                          child: Icon(
                            widget.isSelected ? Icons.add : null,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: Obx(
                      () => ListView(
                        children: [
                          for (var todo in todoController.list)
                            widget.group == Group.toDo
                                ? Text('${todo.content}')
                                : Text('')
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AddPage extends StatefulWidget {
  AddPage({super.key});
  final textController = TextEditingController();
  String content = "";

  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  final todoController = Get.put(TodoController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Text("What To Do ?"),
          TextField(
            controller: widget.textController,
            onChanged: (value) {
              widget.content = value;
            },
          ),
          TextButton(
            onPressed: () {
              print(widget.content);
              todoController.addItem(
                TodoCard(group: Group.toDo, content: widget.content, isSelected: false,),
              );
              Navigator.pop(context);
            },
            child: Text("Create"),
          ),
        ],
      ),
    );
  }
}
