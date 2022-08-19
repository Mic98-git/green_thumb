import 'package:flutter/material.dart';
import './access_params.dart';
import '../../colors.dart';

class UserInfoScreen extends StatefulWidget {
  static String id = "user_info_screen";
  const UserInfoScreen({Key? key}) : super(key: key);

  @override
  State<UserInfoScreen> createState() => _UserInfoScreenState();
}

class _UserInfoScreenState extends State<UserInfoScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController birthDateController = TextEditingController();
  final TextEditingController fiscalCodeController = TextEditingController();
  bool isCustomer = true;
  late DateTime birthDate;

  void saveInfo() {
    //check errors or nullable values to eraise dialogs
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: Colors.white,
        body: Column(children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 30.0),
            child: Center(
              child: Text(
                'About You',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 40,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          SizedBox(
            height: size.height * 0.05,
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
            Text(
              'Personal Info >> ',
              style: TextStyle(
                  color: primaryColor,
                  fontSize: 15,
                  fontWeight: FontWeight.bold),
            ),
            Text(
              'Access Parameters',
              style: TextStyle(
                color: Colors.black,
                fontSize: 15,
              ),
            ),
          ]),
          SizedBox(
            height: size.height * 0.03,
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
            Text(
              'I am a customer',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: isCustomer ? FontWeight.bold : null),
            ),
            Switch(
              value: !isCustomer,
              onChanged: (value) {
                setState(() {
                  isCustomer = !value;
                });
              },
            ),
            Text(
              'I am a seller',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: !isCustomer ? FontWeight.bold : null),
            ),
          ]),
          SizedBox(
            height: size.height * 0.05,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Full Name",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                ),
              ),
            ),
          ),
          SizedBox(
            height: size.height * 0.02,
          ),
          Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: TextFormField(
                controller: nameController,
                decoration: InputDecoration(
                  hintText: "Name",
                  isDense: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              )),
          SizedBox(
            height: size.height * 0.03,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Birth Date (dd/mm/yyyy)",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                ),
              ),
            ),
          ),
          SizedBox(
            height: size.height * 0.02,
          ),
          Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: TextFormField(
                controller: birthDateController,
                decoration: InputDecoration(
                  suffixIcon: GestureDetector(
                    onTap: () async {
                      final datePick = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1900),
                          lastDate: DateTime(2100));
                      if (datePick != null) {
                        setState(() {
                          this.birthDate = datePick;
                        });
                        final date =
                            "${birthDate.day}/${birthDate.month}/${birthDate.year}";
                        birthDateController.value =
                            birthDateController.value.copyWith(text: date);
                      }
                    },
                    child: Icon(
                      Icons.calendar_month_sharp,
                      color: Colors.grey,
                    ),
                  ),
                  hintText: "dd/mm/yyyy",
                  isDense: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              )),
          SizedBox(
            height: size.height * 0.03,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Fiscal Code",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                ),
              ),
            ),
          ),
          SizedBox(
            height: size.height * 0.02,
          ),
          Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: TextFormField(
                controller: fiscalCodeController,
                decoration: InputDecoration(
                  hintText: "Fiscal Code",
                  isDense: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              )),
          SizedBox(
            height: size.height * 0.05,
          ),
          Container(
            height: 50,
            width: 250,
            decoration: BoxDecoration(
                color: primaryColor, borderRadius: BorderRadius.circular(20)),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  primary: primaryColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15))),
              onPressed: () {
                saveInfo();
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AccessParamsScreen()));
              },
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'Continue',
                      style: TextStyle(color: Colors.white, fontSize: 25),
                    ),
                    Icon(Icons.double_arrow_outlined),
                  ]),
            ),
          ),
        ]));
  }
}
