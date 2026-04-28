//คลาสนี้ใช้สำหรับทำงานร่วมกับตารางในฐานข้อมูลที่จะทำงานด้วย

class Food {
  //ตัวแปรที่ตั้งชื่อล้อกับคอลัมน์ในฐานข้อมูล
  String? id;
  String foodDate;
  String foodMeal;
  String foodName;
  double foodPrice;
  int foodPerson;

  Food({
    this.id,
    required this.foodDate,
    required this.foodMeal,
    required this.foodName,
    required this.foodPrice,
    required this.foodPerson,
  });

  //แปลงข้อมูลที่รับมาจาก Supabase เพื่อมาใช้ในแอปฯ
  factory Food.fromJson(Map<String, dynamic> json) {
    return Food(
      id: json['id'] as String,
      foodDate: json['foodDate'],
      foodMeal: json['foodMeal'],
      foodName: json['foodName'],
      foodPrice: (json['foodPrice'] as num).toDouble(),
      foodPerson: json['foodPerson'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'foodDate': foodDate,
      'foodMeal': foodMeal,
      'foodName': foodName,
      'foodPrice': foodPrice,
      'foodPerson': foodPerson,
    };
  }
}
