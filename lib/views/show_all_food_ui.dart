import 'package:flutter/material.dart';
import 'package:flutter_food_log_app/models/food.dart';
import 'package:flutter_food_log_app/services/supabase_service.dart';
import 'package:flutter_food_log_app/views/add_food_ui.dart';
import 'package:flutter_food_log_app/views/update_del_food_ui.dart';

class ShowAllFoodUi extends StatefulWidget {
  const ShowAllFoodUi({super.key});

  @override
  State<ShowAllFoodUi> createState() => _ShowAllFoodUiState();
}

class _ShowAllFoodUiState extends State<ShowAllFoodUi> {
  //สร้างตัวแปรเพื่อเก็บข้อมูลที่จะนำไปแสดงในหน้าจอ
  List<Food> foods = [];

  //สร้าง instance ของ SupabaseService เพื่อเรียกใช้เมธอดต่างๆ ที่เขียนไว้ใน SupabaseService
  final service = SupabaseService();

  //สร้างเมธอดเพื่อดึงข้อมูลทั้งหมดจาก Supabase ผ่านทาง SupabaseService
  void loadAllFood() async {
    //สร้างตัวแปรเพื่อรับข้อมูลทั้งหมดที่ได้จาก Supabase ผ่านทางเมธอด getAllFood() ใน SupabaseService
    final data = await service.getAllFood();
    //กำหนดค่าให้กับตัวแปร foods
    setState(() {
      foods = data;
    });
  }

  @override
  void initState() {
    super.initState();
    loadAllFood();
  }

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
            Expanded(
              child: ListView.builder(
                  //จำนวนรายการที่จะแสดงใน ListView
                  itemCount: foods.length,
                  //การสร้าง หน้าตา สำหรับแต่ละรายการใน ListView
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.only(
                          left: 30, right: 30, top: 5, bottom: 5),
                      child: ListTile(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => UpdateDelFoodUi(
                                food: foods[index],
                              ),
                            ),
                          ).then((value) {
                            loadAllFood();
                          });
                        },
                        leading: Image.asset(
                          'assets/images/food_img.png',
                        ),
                        trailing: Icon(
                          Icons.info,
                          color: Color.fromARGB(255, 134, 55, 55),
                        ),
                        title: Text(
                          'กิน: ${foods[index].foodName}',
                        ),
                        subtitle: Text(
                          'วันที่: ${foods[index].foodDate.toString().split(' ')[0]} มื้อ: ${foods[index].foodMeal}',
                        ),
                        tileColor: index % 2 == 0
                            ? Color.fromARGB(255, 220, 227, 143)
                            : Color.fromARGB(255, 254, 224, 234),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                    );
                  }),
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
              )).then((value) {
            loadAllFood();
          });
        },
        backgroundColor: Color.fromARGB(255, 220, 227, 143),
        child: Icon(
          Icons.add,
          color: Color.fromARGB(255, 67, 67, 67),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
