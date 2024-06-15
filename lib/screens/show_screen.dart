import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_list/model/user_model.dart';
import 'package:todo_list/screens/add_screen.dart';
import 'package:todo_list/screens/update_screen.dart';

class ShowScreen extends StatefulWidget {
  const ShowScreen({super.key});

  @override
  State<ShowScreen> createState() => _ShowScreenState();
}

class _ShowScreenState extends State<ShowScreen> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        label: const Text('افزودن'),
        shape: OutlineInputBorder(borderRadius: BorderRadius.circular(50)),
        icon: const Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const AddScreen(),
            ),
          );
        },
      ),
      body: ValueListenableBuilder(
        valueListenable: Hive.box<UserModel>('userBox').listenable(),
        builder: (BuildContext context, Box<UserModel> box, Widget? child) {
          return box.isEmpty
              ? emptyWidget(width)
              : ListView.builder(
                  itemCount: box.length,
                  itemBuilder: (context, index) {
                    final helper = box.getAt(index) as UserModel;
                    return Dismissible(
                      key: ValueKey(helper.key),
                      confirmDismiss: (direction) {
                        if (direction == DismissDirection.startToEnd) {
                          return Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => UpdateScreen(
                                userModel: helper,
                                itemKey: helper.key,
                              ),
                            ),
                          );
                        }
                        return showModalBottomSheet(
                          context: context,
                          builder: (context) {
                            return Container(
                              height: 200,
                              padding: EdgeInsets.symmetric(
                                  horizontal: width * 0.04, vertical: 20),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'حذف ایتم؟!',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                        fontFamily: 'sahel'),
                                  ),
                                  const SizedBox(height: 10),
                                  const Text(
                                    'ایا اطمینان دارید؟',
                                    style: TextStyle(
                                        fontSize: 16, fontFamily: 'sahel'),
                                  ),
                                  const SizedBox(height: 20),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.grey,
                                          fixedSize: Size(width * 0.4, 45),
                                        ),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text(
                                          'انصراف',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      const SizedBox(width: 20),
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          fixedSize: Size(width * 0.4, 45),
                                        ),
                                        onPressed: () {
                                          box.delete(helper.key);
                                          Navigator.pop(context);
                                        },
                                        child: const Text(
                                          'تایید',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            );
                          },
                        );
                      },
                      secondaryBackground: Container(
                        margin: EdgeInsets.all(width * 0.02),
                        padding: EdgeInsets.all(width * 0.02),
                        alignment: Alignment.centerLeft,
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.delete_forever),
                      ),
                      background: Container(
                        margin: EdgeInsets.all(width * 0.02),
                        padding: EdgeInsets.all(width * 0.02),
                        alignment: Alignment.centerRight,
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.edit),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 18.0),
                        child: Card(
                          margin: EdgeInsets.all(width * 0.02),
                          child: ListTile(
                            title: Text(helper.username),
                            subtitle: Text('موضوع: ${helper.title}'),
                            trailing: IconButton(
                              onPressed: () {
                                setState(() {
                                  UserModel userModel = UserModel(
                                      username: helper.username,
                                      title: helper.title,
                                      description: helper.description,
                                      isDone: !helper.isDone);
                                  box.put(helper.key, userModel);
                                });
                              },
                              icon: helper.isDone
                                  ? const Icon(Icons.check_box)
                                  : const Icon(Icons.check_box_outline_blank),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
        },
      ),
    );
  }

  SafeArea emptyWidget(double width) {
    return SafeArea(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/dontknow.png',
              width: width * 0.6,
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              'اطلاعاتی درح نشده!',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'sahel'),
            )
          ],
        ),
      ),
    );
  }
}
