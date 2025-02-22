import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // تهيئة Firebase
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AddAdminScreen(),
    );
  }
}

class AddAdminScreen extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController idController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  Future<void> addAdmin(BuildContext context) async {
    String name = nameController.text.trim();
    String id = idController.text.trim();
    String phone = phoneController.text.trim();

    // *1. التحقق من أن جميع الحقول ممتلئة*
    if (name.isEmpty || id.isEmpty || phone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("يجب ملء جميع الحقول قبل الإضافة")),
      );
      return; // إيقاف التنفيذ إذا كانت هناك بيانات مفقودة
    }

    try {
      // *2. التحقق مما إذا كان الإداري مسجلاً بالفعل*
      var existingAdmin =
          await FirebaseFirestore.instance
              .collection('admins')
              .where('id', isEqualTo: id)
              .get();

      if (existingAdmin.docs.isNotEmpty) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("هذا الإداري مسجل بالفعل")));
        return; // إيقاف التنفيذ إذا كان الإداري موجودًا
      }

      // *3. إضافة البيانات إلى Firestore*
      await FirebaseFirestore.instance.collection('admins').add({
        'name': name,
        'id': id,
        'phone': phone,
        'createdAt': Timestamp.now(), // تسجيل وقت الإضافة
      });

      // *4. عرض رسالة نجاح*
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("تمت إضافة الإداري بنجاح")));

      // *5. مسح الحقول بعد الإضافة*
      nameController.clear();
      idController.clear();
      phoneController.clear();
    } catch (e) {
      print("Error adding admin: $e");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("حدث خطأ أثناء الإضافة")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text("إضافة إداري", style: TextStyle(color: Colors.white)),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: [
          const Spacer(flex: 3), // زيادة المسافة لدفع المحتوى للأسفل
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              children: [
                CustomTextField(
                  controller: nameController,
                  icon: Icons.person,
                  hintText: "اسم الإداري",
                ),
                SizedBox(height: 15),
                CustomTextField(
                  controller: idController,
                  icon: Icons.badge,
                  hintText: "رقم الإداري",
                ),
                SizedBox(height: 15),
                CustomTextField(
                  controller: phoneController,
                  icon: Icons.phone,
                  hintText: "رقم هاتف الإداري",
                ),
              ],
            ),
          ),
          const Spacer(flex: 4), // دفع الزر للأسفل أكثر
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: CustomButtonAuth(
              title: "إضافة",
              onPressed: () async {
                await addAdmin(context);
              },
              color: Colors.black,
            ),
          ),
          const Spacer(flex: 2), // مسافة في الأسفل
        ],
      ),
    );
  }
}

class CustomButtonAuth extends StatelessWidget {
  final void Function()? onPressed;
  final String title;
  const CustomButtonAuth({
    super.key,
    this.onPressed,
    required this.title,
    required Color color,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      height: 50,
      minWidth: 200,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
      color: const Color.fromARGB(
        255,
        1,
        113,
        189,
      ), // لون الزر كما هو في الصورة
      textColor: Colors.white,
      onPressed: onPressed,
      child: Text(title, style: TextStyle(fontSize: 20)),
    );
  }
}

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final IconData icon;
  final String hintText;

  CustomTextField({
    required this.controller,
    required this.icon,
    required this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.indigo),
          hintText: hintText,
          filled: true,
          fillColor: Colors.grey[200],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}
