import 'package:flutter/material.dart';
import 'package:flutter_food_log_app/models/food.dart';
import 'package:flutter_food_log_app/services/supabase_service.dart';
import 'package:intl/intl.dart';

class AddFoodUi extends StatefulWidget {
  const AddFoodUi({super.key});

  @override
  State<AddFoodUi> createState() => _AddFoodUiState();
}

class _AddFoodUiState extends State<AddFoodUi> {
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

  //เมธอดสำหรับการบันทึกข้อมูลไปยัง Supabase
  void saveFood() async {
    //Validation Ui/ตรวจสอบข้อมูลที่กรอกเข้ามา
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

    //แพ็คข้อมูล
    Food food = Food(
      foodName: foodNameCtrl.text,
      foodMeal: foodMeal,
      foodPrice: double.parse(foodPriceCtrl.text),
      foodPerson: int.parse(foodPersonCtrl.text),
      foodDate: foodDate!.toIso8601String(),
    );
    //ส่งไปยัง Supabase ผ่าน SupabaseService โดยใช้เมธอด insertFood
    final service = SupabaseService();
    await service.insertFood(food);

    //แจ้งผลการบันทึกข้อมูล เช่น บันทึกสำเร็จ หรือ บันทึกไม่สำเร็จ
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('บันทึกข้อมูลเรียบร้อยแล้ว'),
        backgroundColor: Color.fromARGB(255, 102, 236, 102),
        duration: Duration(seconds: 2),
      ),
    );

    //กลับไปหน้าหลัก (ShowAllFoodUi) เพื่อดูข้อมูลที่เพิ่มเข้ามา
    Navigator.pop(context);
  }

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
                    saveFood(); // Handle button press
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
                    'บันทึก',
                    style: TextStyle(
                      color: Color.fromARGB(255, 67, 67, 67),
                      fontSize: 18,
                    ),
                  ),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      foodNameCtrl.clear();
                      foodPriceCtrl.clear();
                      foodPersonCtrl.clear();
                      foodDateCtrl.clear();
                      foodMeal = 'เช้า';
                    }); // Handle button press
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
                    'ยกเลิก',
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
