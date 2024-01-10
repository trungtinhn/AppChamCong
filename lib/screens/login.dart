import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/failed_snackbar.dart';
import 'package:flutter_application_1/constants/app.color.dart';
import 'package:flutter_application_1/provider/nguoidung.provider.dart';
import 'package:flutter_application_1/screens/timekeeping.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String? _userName;
  String? _passWord;
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    final nguoiDungProvider = Provider.of<NguoiDungProvider>(context);
    return Scaffold(
      body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Container(
          height: 100,
          width: 100,
          decoration: const BoxDecoration(
              shape: BoxShape.rectangle,
              image: DecorationImage(
                  image: AssetImage('assets/images/logo.png'),
                  fit: BoxFit.contain)),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 25, right: 25),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const Text(
                "Đăng Nhập",
                style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w500,
                    fontFamily: "CeraPro"),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.greyIron),
                  child: TextField(
                    onChanged: (value) {
                      _userName = value;
                    },
                    onTap: () {},
                    decoration: const InputDecoration(
                      hintText: 'Tên đăng nhập',
                      hintStyle: TextStyle(
                          color: AppColors.greyShuttle,
                          fontFamily: 'CeraPro',
                          fontWeight: FontWeight.w400),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20, bottom: 10),
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.greyIron),
                  child: TextField(
                    onChanged: (value) {
                      _passWord = value;
                    },
                    onTap: () {},
                    style: const TextStyle(
                        fontFamily: "CeraPro",
                        fontSize: 16,
                        color: AppColors.black),
                    decoration: const InputDecoration(
                      hintText: 'Mật khẩu',
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: InkWell(
                    onTap: () async {
                      CollectionReference usersCollection =
                          FirebaseFirestore.instance.collection('users');

// Dữ liệu cần thêm
                      Map<String, dynamic> userData = {
                        'name': 'John Doe',
                        'email': 'johndoe@example.com',
                        'age': 25,
                      };

// Thêm dữ liệu vào Firestore
                      usersCollection
                          .add(userData)
                          .then((value) =>
                              print('Dữ liệu đã được thêm thành công'))
                          .catchError(
                              (error) => print('Lỗi khi thêm dữ liệu: $error'));
                      try {
                        setState(() {
                          loading = true;
                        });
                        await nguoiDungProvider.dangNhap(
                            _userName!, _passWord!);
                        if (nguoiDungProvider.isLoggedIn) {
                          // ignore: use_build_context_synchronously
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => TimeKeepting(
                                      maNV: nguoiDungProvider.nguoiDung!.maNV,
                                    )),
                          );
                        }
                      } catch (e) {
                        print(e);
                        // ignore: use_build_context_synchronously
                        ScaffoldMessenger.of(context).showSnackBar(
                            buildFailedSnackbar('Đăng nhập không thành công!'));
                      }
                      setState(() {
                        loading = false;
                      });
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 50,
                      decoration: BoxDecoration(
                          color: Colors.yellow,
                          borderRadius: BorderRadius.circular(15)),
                      alignment: Alignment.center,
                      child: loading
                          ? const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8.0),
                              child: SizedBox(
                                height: 10,
                                width: 10,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                ),
                              ),
                            )
                          : const Text(
                              'ĐĂNG NHẬP',
                              style: TextStyle(
                                  fontFamily: 'CeraPro',
                                  fontSize: 16,
                                  color: Colors.white),
                            ),
                    )),
              ),
            ],
          ),
        )
      ]),
    );
  }
}
