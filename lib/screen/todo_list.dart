import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../service/todo_service.dart';
import '../utils/snakbar.dart';
import 'add_page.dart';

class TodoListPage extends StatefulWidget {
  const TodoListPage({Key? key}) : super(key: key);

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {

  List items = [];
  bool isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetch();
  }

  Future<void> navigateToAddPage() async{
    final route = MaterialPageRoute(builder: (context) => AddTodoPage());
    await Navigator.push(context, route);
    setState(() {
      isLoading = true;
    });
    fetch();
  }

  Future<void> navigateToEditPage(Map item) async {

    final route = MaterialPageRoute(
        builder: (context) => AddTodoPage( todo: item)
    );
    await Navigator.push(context, route);
    print("object11");                                          // Edit run program check
    setState(() {
      isLoading = true;
    });
    fetch();
  }

  Future<void> fetch() async{
    setState(() {
      isLoading = true;
    });
    final response = await TodoService.fetchTodos();
    if(response != null){
      setState(() {
        items = response;
      });
    }else{
      //   Error
      showSucc(context,message: 'Something wento wrong', col: Colors.redAccent);
    }
  }

  Future<void> deleteById(String id) async{
    final isSuccess = await TodoService.deleteById(id);
    if(isSuccess){
      final finalitems = items.where((element) => element['_id'] != id).toList();
      setState(() {
        items = finalitems;
      });

    }else {
      showSucc(context,message: "Deletion Failed",col: Colors.redAccent);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("TodoList"),
      ),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: navigateToAddPage,
          label: Icon(Icons.add),
      ),
      body:  Visibility(
        visible: isLoading,
        replacement: Center(child: CircularProgressIndicator()),
        child: RefreshIndicator(
          onRefresh: fetch,
          child: Visibility(
            visible: items.isNotEmpty,
            replacement: Center(child: Text("No Todo Items", style: Theme.of(context).textTheme.displaySmall)),
            child:  ListView.builder(
              padding: EdgeInsets.all(12),
                itemCount: items.length,
                itemBuilder: (context,index){
                  final item = items[index] as Map;
                  final id = item['_id'];
                  // return TodoCard(
                  //   index: index,
                  //   deleteById: deleteById,
                  //   navigatEditPage: navigateToEditPage,
                  //   item: item
                  // );
                  return Card(child: ListTile(
                    leading: CircleAvatar(child: Text('${index + 1}')),
                    title: Text(item['title']),
                    subtitle: Text(item['description']),
                    trailing: PopupMenuButton(
                      onSelected: (value){
                        if(value == 'edit'){
                            navigateToEditPage(item);
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
                }),
          )
        ),
      )
    );
  }



}
