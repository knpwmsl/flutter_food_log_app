//คลาสนี้ใช้สำหรับทำงานร่วมกับตารางในฐานข้อมูลที่จะทำงานด้วย

// ignore_for_file: non_constant_identifier_names

class Food {
  //ตัวแปรที่ตั้งชื่อล้อกับคอลัมน์ในฐานข้อมูล
  String? id;
  DateTime? created_at;
  DateTime? foodDate;
  String? foodMeal;
  String? foodName;
  double? foodPrice;
  int? foodPerson;

  Food({
    this.id,
    this.created_at,
    this.foodDate,
    this.foodMeal,
    this.foodName,
    this.foodPrice,
    this.foodPerson,
  });
  //แปลงข้อมูลที่รับมาแอป เพื่อมาใช้ในการส่งข้อมูลไปยัง Supabase
  Map<String, dynamic> toMap() {
    return {
      'foodDate': foodDate,
      'foodMeal': foodMeal,
      'foodName': foodName,
      'foodPrice': foodPrice,
      'foodPerson': foodPerson,
    };
  }

  //แปลงข้อมูลที่รับมาจาก Supabase เพื่อมาใช้ในแอปฯ
  factory Food.fromMap(Map<String, dynamic> map) {
    return Food(
      id: map['id'] as String,
      created_at: DateTime.parse(map['created_at'] as String),
      foodDate: DateTime.parse(map['foodDate'] as String),
      foodMeal: map['foodMeal'] as String,
      foodName: map['foodName'] as String,
      foodPrice: double.parse(map['foodPrice'] as String),
      foodPerson: int.parse(map['foodPerson'] as String),
    );
  }
}
