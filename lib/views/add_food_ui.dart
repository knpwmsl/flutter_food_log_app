import 'package:flutter/material.dart';

class AddFoodUi extends StatefulWidget {
  const AddFoodUi({super.key});

  @override
  State<AddFoodUi> createState() => _AddFoodUiState();
}

class _AddFoodUiState extends State<AddFoodUi> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 220, 227, 143),
        title: Text(
          'กินแซ่บ Log (เพิ่มรายการ)',
          style: TextStyle(
            color: Color.fromARGB(255, 67, 67, 67),
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: Color.fromARGB(255, 67, 67, 67),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: Column(
          children: [],
        ),
      ),
    );
  }
}
