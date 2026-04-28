// ignore_for_file: unused_local_variable, must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_food_log_app/models/food.dart';
import 'package:flutter_food_log_app/services/supabase_service.dart';
import 'package:intl/intl.dart';

class UpdateDelFoodUi extends StatefulWidget {
  //สรา้งตัวแปรสำหรับรับข้อมูลจากหน้าที่เรียกใช้ เช่น id, foodName, calories, foodDate
  Food? food;

  //เอาตัวแปรที่สร้างมารับค่า
  UpdateDelFoodUi({
    super.key,
    this.food,
  });

  @override
  State<UpdateDelFoodUi> createState() => _UpdateDelFoodUiState();
}

class _UpdateDelFoodUiState extends State<UpdateDelFoodUi> {
  //ตัวควบคุมสำหรับ TextField
  TextEditingController foodNameCtrl = TextEditingController();
  TextEditingController foodPriceCtrl = TextEditingController();
  TextEditingController foodPersonCtrl = TextEditingController();
  TextEditingController foodDateCtrl = TextEditingController();

  //ตัวแปรเพื่อเก็บข้อมูลมื้ออาหารที่เลือก
  String foodMeal = 'เช้า';

  //สร้างตัวแปรเก็บวันที่กิน
  DateTime? foodDate;

  //เมธอดเปิดปฏิทินให้เลือกวันที่ แล้วกำหนดค่าวันที่ที่เลือกให้กับตัวแปร foodDate และแสดงวันที่ที่เลือกใน TextField
  Future<void> picDate() async {
    //เปิดปฏิทินให้เลือกวันที่
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      setState(() {
        //กำหนดค่าวันที่ที่เลือกให้กับตัวแปร foodDate
        foodDate = pickedDate;
        //แสดงวันที่ที่เลือกใน TextField โดยใช้รูปแบบ yyyy/MM/dd
        foodDateCtrl.text = DateFormat('yyyy/MM/dd').format(pickedDate);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    //กำหนดค่าเริ่มต้นให้กับ TextField และตัวแปร foodMeal จากข้อมูลที่ได้รับมาจากหน้าที่เรียกใช้ผ่านตัวแปร widget.food
    foodNameCtrl.text = widget.food!.foodName;
    foodMeal = widget.food!.foodMeal;
    foodPriceCtrl.text = widget.food!.foodPrice.toString();
    foodPersonCtrl.text = widget.food!.foodPerson.toString();
    foodDateCtrl.text = widget.food!.foodDate;
    //กำหนดค่าวันที่กินให้ foodDate
    foodDate = DateTime.parse(widget.food!.foodDate);
  }

  //เรียกใช้เมธอด บันทึกแก้ไขข้อมูล
  void editFood() async {
    //Validate ข้อมูลที่กรอกเข้ามา
    if (foodNameCtrl.text.isEmpty ||
        foodPriceCtrl.text.isEmpty ||
        foodPersonCtrl.text.isEmpty ||
        foodDateCtrl.text.isEmpty) {
      //แจ้งเตือนให้กรอกข้อมูลให้ครบทุกช่อง
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('กรุณากรอกข้อมูลให้ครบ'),
          backgroundColor: Color.fromARGB(255, 236, 110, 102),
          duration: Duration(seconds: 2),
        ),
      );
      return; //หยุดการทำงานของเมธอด saveFood
    }

    //แพ๊คข้อมูลที่จะส่งไปแก้ไข
    Food food = Food(
      foodName: foodNameCtrl.text,
      foodMeal: foodMeal,
      foodPrice: double.parse(foodPriceCtrl.text),
      foodPerson: int.parse(foodPersonCtrl.text),
      foodDate: foodDate!.toIso8601String(),
    );

    //เรียกใช้เมธอดแก้ไขข้อมูลใน Supabase ผ่านทาง SupabaseService
    final service = SupabaseService();
    await service.updateFood(widget.food!.id!, food);

    //แจ้งผลการทำงาน
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('บันทึกข้อมูลเรียบร้อยแล้ว'),
        backgroundColor: Color.fromARGB(255, 102, 236, 102),
        duration: Duration(seconds: 2),
      ),
    );

    //ย้อนกลับไปหน้าที่ ShowAllFoodUi โดยส่งข้อมูลที่แก้ไขกลับไปด้วย
    Navigator.pop(context);
  }

  //เรียกใช้เมธอด ลบข้อมูล
  Future<void> delFood() async {
    //แสดง Dialog เพื่อยืนยันการลบข้อมูล
    await showDialog(
        //dialog จะอยู่บนหน้าจอปัจจุบัน ดังนั้นต้องส่ง context ของหน้าจอปัจจุบันไปด้วย
        context: context,
        //หน้าตา Dialog
        builder: (context) => AlertDialog(
                //หัวข้อของ Dialog
                title: Text('ยืนยันการลบข้อมูล'),
                //เนื้อหาของ Dialog
                content: Text('คุณต้องการลบข้อมูลนี้จริงหรือไม่?'),
                //ปุ่มคำสั่งใน Dialog
                actions: [
                  //ปุ่มยกเลิกเพื่อปิด Dialog โดยไม่ทำอะไร
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context); //ปิด Dialog
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 236, 110, 102),
                    ),
                    child: Text(
                      'ยกเลิก',
                      style: TextStyle(
                        color: Color.fromARGB(255, 67, 67, 67),
                      ),
                    ),
                  ),
                  //ปุ่มยืนยันการลบข้อมูลจริง ออกจาก Supabase ผ่านทาง Services
                  ElevatedButton(
                    onPressed: () async {
                      //เรียกใช้เมธอดลบข้อมูลใน Supabase ผ่านทาง SupabaseService โดยส่ง id ของข้อมูลที่ต้องการลบไปด้วย
                      final service = SupabaseService();
                      await service.deleteFood(widget.food!.id!);

                      //แจ้งผลการทำงาน
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('ลบข้อมูลเรียบร้อยแล้ว'),
                          backgroundColor: Color.fromARGB(255, 102, 236, 102),
                          duration: Duration(seconds: 2),
                        ),
                      );

                      //ย้อนกลับไปหน้าที่ ShowAllFoodUi
                      Navigator.pop(context); //ปิด Dialog
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 102, 236, 102),
                    ),
                    child: Text(
                      'ยืนยันลบข้อมูล',
                      style: TextStyle(
                        color: Color.fromARGB(255, 67, 67, 67),
                      ),
                    ),
                  )
                ]));
    //ถ้าผู้ใช้ยืนยันการลบข้อมูล

    //เรียกใช้เมธอดลบข้อมูลใน Supabase ผ่านทาง SupabaseService โดยส่ง id ของข้อมูลที่ต้องการลบไปด้วย

    //แจ้งผลการทำงาน

    //ย้อนกลับไปหน้าที่ ShowAllFoodUi
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //ส่วนของ AppBar
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 220, 227, 143),
        title: Text(
          'กินแซ่บ Log (แก้ไข/ลบ รายการ)',
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
      //ส่วนของ Body
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(top: 40, bottom: 50, left: 40, right: 40),
          child: Center(
            child: Column(
              children: [
                Image.asset(
                  'assets/images/logo.png',
                  width: 180,
                  height: 180,
                  fit: BoxFit.cover,
                ),
                SizedBox(height: 20),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'กินอะไร',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
                //กินอะไร (ชื่ออาหาร)
                TextField(
                  controller: foodNameCtrl,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    hintText: 'เช่น KFC, Pizza',
                  ),
                ),
                SizedBox(height: 20),
                //กินมื้อไหน (มื้ออาหาร)
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'กินมื้อไหน',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    //มื้อเช้า
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          foodMeal = 'เช้า';
                        }); // Handle button press
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: foodMeal == 'เช้า'
                            ? Color.fromARGB(255, 220, 227, 143)
                            : Colors.blueGrey[100],
                      ),
                      child: Text(
                        'เช้า',
                        style: TextStyle(
                          color: Color.fromARGB(255, 67, 67, 67),
                        ),
                      ),
                    ),
                    //มื้อกลางวัน
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          foodMeal = 'กลางวัน';
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: foodMeal == 'กลางวัน'
                            ? Color.fromARGB(255, 220, 227, 143)
                            : Colors.blueGrey[100],
                      ),
                      child: Text(
                        'กลางวัน',
                        style: TextStyle(
                          color: Color.fromARGB(255, 67, 67, 67),
                        ),
                      ),
                    ),
                    //มื้อเย็น
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          foodMeal = 'เย็น';
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: foodMeal == 'เย็น'
                            ? Color.fromARGB(255, 220, 227, 143)
                            : Colors.blueGrey[100],
                      ),
                      child: Text(
                        'เย็น',
                        style: TextStyle(
                          color: Color.fromARGB(255, 67, 67, 67),
                        ),
                      ),
                    ),
                    //มื้อว่าง
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          foodMeal = 'ว่าง';
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: foodMeal == 'ว่าง'
                            ? Color.fromARGB(255, 220, 227, 143)
                            : Colors.blueGrey[100],
                      ),
                      child: Text(
                        'ว่าง',
                        style: TextStyle(
                          color: Color.fromARGB(255, 67, 67, 67),
                        ),
                      ),
                    )
                  ],
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'กินไปเท่าไหร่',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
                TextField(
                  controller: foodPriceCtrl,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    hintText: 'เช่น 299.50',
                  ),
                ),
                SizedBox(height: 20),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'กินกันกี่คน',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
                TextField(
                  controller: foodPersonCtrl,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    hintText: 'เช่น 3',
                  ),
                ),
                SizedBox(height: 20),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'กินไปวันไหน',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
                TextField(
                  readOnly: true,
                  controller: foodDateCtrl,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    hintText: 'เช่น 2020/01/31',
                    suffixIcon: Icon(
                      Icons.calendar_today,
                    ),
                  ),
                  onTap: () {
                    picDate(); //เปิด ปฏิทินให้เลือกวันที่
                  },
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    editFood(); //เรียกใช้เมธอด บันทึกแก้ไขข้อมูล
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 220, 227, 143),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    fixedSize: Size(
                      MediaQuery.of(context).size.width,
                      50,
                    ),
                  ),
                  child: Text(
                    'บันทึกแก้ไข',
                    style: TextStyle(
                      color: Color.fromARGB(255, 67, 67, 67),
                      fontSize: 18,
                    ),
                  ),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    delFood().then((value) {
                      Navigator.pop(context);
                    }); //เรียกใช้เมธอด ลบข้อมูล
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 255, 202, 202),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    fixedSize: Size(
                      MediaQuery.of(context).size.width,
                      50,
                    ),
                  ),
                  child: Text(
                    'ลบข้อมูล',
                    style: TextStyle(
                      color: Color.fromARGB(255, 67, 67, 67),
                      fontSize: 18,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
