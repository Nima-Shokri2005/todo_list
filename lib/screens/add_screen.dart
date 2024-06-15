import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:todo_list/model/user_model.dart';
import 'package:todo_list/theme/color.dart';
import 'package:uuid/uuid.dart';
import 'package:animate_do/animate_do.dart';

class AddScreen extends StatefulWidget {
  const AddScreen({super.key});

  @override
  State<AddScreen> createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final box = Hive.box<UserModel>('userBox');
  final _formKey = GlobalKey<FormState>();
  bool isDone = false;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _usernameController.dispose();
    _titleController.dispose();
    _descriptionController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(width * 0.02),
                child: Column(
                  children: [
                    FadeInLeft(
                      child: TextFormField(
                        validator: validator('نام کاربری'),
                        cursorColor: primaryColor,
                        controller: _usernameController,
                        decoration: inputDecoration('نام کابری'),
                        keyboardType: TextInputType.name,
                        textInputAction: TextInputAction.next,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    FadeInRight(
                      child: TextFormField(
                        validator: validator('عنوان'),
                        cursorColor: primaryColor,
                        controller: _titleController,
                        decoration: inputDecoration('عنوان'),
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.next,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    FadeInLeft(
                      child: TextFormField(
                        validator: validator('توضیحات'),
                        cursorColor: primaryColor,
                        controller: _descriptionController,
                        decoration: inputDecoration('توضیحات'),
                        textInputAction: TextInputAction.newline,
                        maxLines: 8,
                        minLines: 4,
                      ),
                    ),
                  ],
                ),
              ),
              FadeInRight(
                child: Row(
                  children: [
                    Expanded(
                      child: RadioListTile(
                        title: const Text('انجام شده',
                            style:
                                TextStyle(fontFamily: 'sahel', fontSize: 19)),
                        value: true,
                        groupValue: isDone,
                        onChanged: (value) {
                          setState(() {
                            isDone = value!;
                          });
                        },
                      ),
                    ),
                    Expanded(
                      child: RadioListTile(
                        title: const Text(
                          'انجام نشده',
                          style: TextStyle(fontFamily: 'sahel', fontSize: 19),
                        ),
                        value: false,
                        groupValue: isDone,
                        onChanged: (value) {
                          setState(() {
                            isDone = value!;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 18,
              ),
              FadeInUp(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    fixedSize: Size(width * 0.75, 50),
                  ),
                  onPressed: () async {
                    final userModel = UserModel(
                      username: _usernameController.text,
                      title: _titleController.text,
                      description: _descriptionController.text,
                      isDone: isDone,
                    );
                    if (_formKey.currentState!.validate()) {
                      await box.put(const Uuid().v1(), userModel);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          duration: const Duration(seconds: 2),
                          backgroundColor: Colors.green,
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          // action: SnackBarAction(
                          //   label: '',
                          //   onPressed: () {},
                          // ),
                          content: const Text(
                            'با موفقیت اطلاعات ثبت شد!',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'sahel',
                            ),
                          ),
                        ),
                      );
                      Navigator.pop(context);
                    } else {
                      AwesomeDialog(
                        context: context,
                        dialogType: DialogType.error,
                        animType: AnimType.rightSlide,
                        title: 'خطا',
                        desc: 'در مقادیر ورودی مشکلی پیش آمده',
                        btnCancelText: 'بستن',
                        btnCancelOnPress: () {},
                      ).show();
                    }
                  },
                  child: const Text(
                    'ثبت اطلاعات',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontFamily: 'sahel',
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  validator(String x) {
    return (value) {
      if (value!.isEmpty) {
        return '$x نمی تواند خالی باشد!';
      } else if (value.length < 3) {
        return '$x نمی تواند کمتر از 3 کاراکتر باشد!';
      }
    };
  }

  InputDecoration inputDecoration(String label) {
    return InputDecoration(
      prefix: const Padding(
        padding: EdgeInsets.only(left: 10),
        child: Icon(Icons.edit_outlined),
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
      labelText: label,
      labelStyle: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontFamily: 'sahel'),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: secondaryPrimaryColor, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: primaryColor, width: 3),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: primaryColor, width: 2),
      ),
    );
  }
}
