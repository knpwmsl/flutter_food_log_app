//คลาสนี้ใช้สำหรับการเขียนโค้ดคำสั่งเพื่อทำงานต่างๆ กับ Supabase
import 'package:flutter_food_log_app/models/food.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  //สร้าง Object/Instance/ตัวแทน ที่จะใช้ทำงานต่างๆ กับ Supabase
  final supabase = Supabase.instance.client;

  //ส่วนของเมธอดการทำงานต่างๆ กับ Supabase
  //เช่น การเพิ่ม..., การแก้ไข..., การลบ...., การค้นหา-ตรวจสอบ-ดึง-ดู....

  //สร้างเมธอดสำหรับการดึงข้อมูลทั้งหมดจาก food_tb ใน Supabase
  Future<List<Food>> getAllFood() async {
    //ดึงข้อมูลทั้งหมดจาก food_tb ใน Supabase
    final data = await supabase
        .from('food_tb')
        .select('*')
        .order('foodDate', ascending: false);
    //แปลงข้อมูลที่ได้จาก Supabase ซึ่งเป็น Json นำมาใช้ในแอป และส่งผลกลับไป จุดเรียกใช้เมธอด
    return data.map<Food>((e) => Food.fromJson(e)).toList();
  }

  //สร้างเมธอดสำหรับการเพิ่มข้อมูลลงใน food_tb ใน Supabase
  Future insertFood(Food food) async {
    //เพิ่มข้อมูลลงใน food_tb ใน Supabase โดยใช้ข้อมูลจากตัวแปร food ที่ส่งเข้ามา
    await supabase.from('food_tb').insert(food.toJson());
  }

  //สร้างเมธอดสำหรับการแก้ไขข้อมูลใน food_tb ใน Supabase
  Future updateFood(String id, Food food) async {
    //แก้ไขข้อมูลใน food_tb ใน Supabase โดยใช้ข้อมูลจากตัวแปร food ที่ส่งเข้ามา และระบุ id ของข้อมูลที่ต้องการแก้ไข
    await supabase.from('food_tb').update(food.toJson()).eq('id', id);
  }

  //สร้างเมธอดสำหรับการลบข้อมูลใน food_tb ใน Supabase
  Future deleteFood(String id) async {
    //ลบข้อมูลใน food_tb ใน Supabase โดยระบุ id ของข้อมูลที่ต้องการลบ
    await supabase.from('food_tb').delete().eq('id', id);
  }
}
