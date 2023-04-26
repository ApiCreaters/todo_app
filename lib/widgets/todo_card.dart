import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TodoCard extends StatelessWidget {
  final index;
  final item;
  final Function(Map) navigatEditPage;
  final Function(String) deleteById;
  const TodoCard({
    Key? key,
    required this.index,
    required this.item,
    required this.navigatEditPage,
    required this.deleteById
  }) ;

  @override
  Widget build(BuildContext context) {
    final id = item['_id'] as String;
    return  Card(child: ListTile(
      leading: CircleAvatar(child: Text('${index + 1}'),),
      title: Text(item['title']),
      subtitle: Text(item['description']),
      trailing: PopupMenuButton(
        onSelected: (value){
          if(value == 'Edit'){
            navigatEditPage(item);
          }else if (value == 'delete'){
            deleteById(id);
          }
        },
        itemBuilder: (context){
          return [
            PopupMenuItem(child: Text("Edit"),value: 'edit',),
            PopupMenuItem(child: Text("Delete"),value: 'delete'),
          ];
        },
      ),

    ));
  }
}
