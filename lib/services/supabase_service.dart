//คลาสนี้ใช้สำหรับการเขียนโค้ดคำสั่งเพื่อทำงานต่างๆ กับ Supabase
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  //สร้าง Object/Instance/ตัวแทน ที่จะใช้ทำงานต่างๆ กับ Supabase
  final supabase = Supabase.instance.client;

  //ส่วนของเมธอดการทำงานต่างๆ กับ Supabase
  //เช่น การเพิ่ม..., การแก้ไข..., การลบ...., การค้นหา-ตรวจสอบ-ดึง-ดู....

  //สร้างเมธอดสำหรับการดึงข้อมูลทั้งหมดจาก food_tb ใน Supabase
}
