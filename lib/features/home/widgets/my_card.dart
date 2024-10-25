import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../../../domain/models/task.dart';
import 'package:intl/intl.dart';

class MyCard extends StatefulWidget {
  final Task task;
  final Function(Task) deleteTask;
  final Function(Task) updateTask;
  const MyCard(this.task, this.updateTask, this.deleteTask, {super.key});

  @override
  State<MyCard> createState() => _MyCardState();
}

class _MyCardState extends State<MyCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () async {
        // update task
        await widget.updateTask(widget.task);
      },
      child: Stack(
        children: [
          Column(
            children: [
              const SizedBox(height: 5),
              Padding(
                padding: const EdgeInsets.only(
                  left: 30,
                  right: 25,
                  top: 25,
                ),
                child: Container(
                  height: 80,
                  decoration: BoxDecoration(
                    color: widget.task.color,
                    border: Border.all(color: Colors.black, width: 2),
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 25,
              right: 30,
              top: 25,
            ),
            child: Slidable(
              endActionPane: ActionPane(
                motion: const ScrollMotion(),
                children: [
                  SlidableAction(
                    onPressed: (context) async {
                      // delete task
                      await widget.deleteTask(widget.task);
                    },
                    icon: Icons.delete,
                    backgroundColor: Colors.transparent,
                  ),
                ],
              ),
              child: Container(
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.black, width: 2),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Center(
                  child: ListTile(
                    leading: Checkbox(
                      activeColor: widget.task.color,
                      onChanged: (value) async {
                        // press checkbox
                        widget.task.done = !widget.task.done;
                        await widget.updateTask(widget.task);
                      },
                      value: widget.task.done,
                    ),
                    title: Text(
                      widget.task.title,
                      style: TextStyle(
                        fontSize: 18,
                        decoration: widget.task.done
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                      ),
                    ),
                    trailing: Text(
                      DateFormat('kk:mm').format(widget.task.date!),
                      style: const TextStyle(
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
