// ignore_for_file: sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:flutter_food_log_app/views/add_food_ui.dart';

class ShowAllFoodUi extends StatefulWidget {
  const ShowAllFoodUi({super.key});

  @override
  State<ShowAllFoodUi> createState() => _ShowAllFoodUiState();
}

class _ShowAllFoodUiState extends State<ShowAllFoodUi> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 220, 227, 143),
        title: Text(
          'กินแซ่บ Log',
          style: TextStyle(
            color: Color.fromARGB(255, 67, 67, 67),
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(height: 40),
            Image.asset(
              'assets/images/logo.png',
              width: 180,
              height: 180,
              fit: BoxFit.cover,
            ),
            SizedBox(height: 20),
            Text(
              'แสดงข้อมูลอาหารทั้งหมด',
              style: TextStyle(
                fontSize: 20,
                color: const Color.fromARGB(255, 67, 67, 67),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddFoodUi(),
              ));
        },
        child: Icon(
          Icons.add,
          color: Color.fromARGB(255, 67, 67, 67),
        ),
        backgroundColor: Color.fromARGB(255, 220, 227, 143),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
