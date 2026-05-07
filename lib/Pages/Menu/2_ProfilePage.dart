import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rental_room/style/color.dart';
import 'package:rental_room/style/myTextField.dart';
import 'package:rental_room/style/styleButton_Text.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  bool isEditing =  false;
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController birthdayController = TextEditingController();
  TextEditingController locationController = TextEditingController();

  final user = FirebaseAuth.instance.currentUser;

  Future<void> update() async{
    await FirebaseFirestore.instance.collection("users").doc(user!.uid).update({
      "fullName": nameController.text,
      "phone": phoneController.text,
      "birthday": birthdayController.text,
      "location": locationController.text
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Center(
          child: Text(
              'Detail Profile',
            style: Text_Button_Styles.text2,
          ),
        ),
        actions: [
          IconButton(
              onPressed: () async{
                if(isEditing){
                  await update();
                }
                setState(() {
                  isEditing = !isEditing;
                });
              },
              icon: Icon(isEditing ? Icons.save : Icons.edit),
          )
        ],
      ),
      body: SafeArea(
          child: StreamBuilder(
              stream: FirebaseFirestore.instance.collection("users").doc(user!.uid).snapshots(),
              builder: (context, snapshot){
                if(snapshot.connectionState == ConnectionState.waiting){
                  return Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(width: 15),
                          Text('Data is loading.')
                        ],
                      ),
                    ),
                  );
                }
                if(!snapshot.hasData || !snapshot.data!.exists){
                  return Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Column(
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(width: 15),
                          Text('No data')
                        ],
                      ),
                    ),
                  );
                }
                if(snapshot.hasError){
                  return Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          CircularProgressIndicator(),
                          Text('Error: ${snapshot.error}')
                        ]
                      ),
                    ),
                  );
                }
                final data = snapshot.data!.data() as Map<String, dynamic>;

                String name ="";
                String avt= "";
                String phone = "";
                String birthday = "";
                String location = "";
                if(isEditing){
                  nameController.text = data["fullName"] ?? "Name";
                  phoneController.text = data["phone"] ?? "Phone number";
                  birthdayController.text = data["birthday"] ?? "00/00/0000";
                  locationController.text = data["location"] ?? "Location";
                }

                 avt = data["avatar"] ?? "";
                 name = data["fullName"] ?? "Name";
                 phone = data["phone"] ?? "Phone number";
                 birthday = data["birthday"] ?? "00/00/0000";
                 location = data["location"] ?? "Location";
                return Padding(
                  padding: const EdgeInsets.fromLTRB(20.0,10,20,10),
                  child: !isEditing? Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          avt.isNotEmpty ? Center(
                            child: Container(

                              child:
                              CircleAvatar(
                                radius: 50,
                                backgroundImage: NetworkImage(
                                  avt,
                                ),
                              ),
                            ),
                          ) :Center(
                           child: Container(
                             width: 95,
                             height: 95,
                             padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  color: colorsyle.primary
                                ),
                                child: Center(
                                  child: Icon(
                                    Icons.perm_identity_rounded,
                                    color: Colors.white,
                                    size: 40,
                                  ),
                                ),
                           ),
                         ),

                          SizedBox(height: 30),
                          Text(
                            'Full Name',
                            style: Text_Button_Styles.text3,
                          ),
                          Card(
                            elevation: 2,
                            child: ListTile(
                              title: Text(
                                name,
                                style: Text_Button_Styles.text5
                              ),
                            ),
                          ),
                          SizedBox(height: 15),
                          Text(
                            'Phone',
                            style: Text_Button_Styles.text3,
                          ),
                          Card(
                            elevation: 2,
                            child: ListTile(
                              title: Text(
                                  phone,
                                  style: Text_Button_Styles.text5
                              ),
                            ),
                          ),
                          SizedBox(height: 15),
                          Text(
                            'Birthday',
                            style: Text_Button_Styles.text3,
                          ),
                          Card(
                            elevation: 2,
                            child: ListTile(
                              title: Text(
                                  birthday,
                                  style: Text_Button_Styles.text5
                              ),
                            ),
                          ),
                          SizedBox(height: 15),
                          Text(
                            'Location',
                            style: Text_Button_Styles.text3,
                          ),
                          Card(
                            elevation: 2,
                            child: ListTile(
                              title: Text(
                                  location,
                                  style: Text_Button_Styles.text5
                              ),
                            ),
                          ),
                        ],
                      )
                  ):
                  Container(
                    child: canEditing(avt, context),
                  ),
                );
              }
          )
      ),
    );
  }

  Column canEditing(String avt, BuildContext context) {
    return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      avt.isNotEmpty ? Center(
                        child: Container(
                          child: Stack(
                            children: [
                              CircleAvatar(
                                radius: 55,
                                backgroundImage: NetworkImage(
                                  avt,
                                ),
                              ),
                              Positioned(
                                bottom: -10,
                                  right: 0,
                                  child: IconButton(
                                    onPressed: (){},
                                      icon: Icon(
                                          Icons.camera_alt,
                                        color: colorsyle.textPrimary,
                                      )
                                  )
                              )
                            ]
                          ),
                        ),
                      ) : Center(
                        child: Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                          ),
                          child: Center(
                            child: Icon(
                              Icons.perm_identity_rounded,
                              color: Colors.white,
                              size: 50,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 40),

                       Container(
                         decoration: BoxDecoration(
                           borderRadius: BorderRadius.circular(20),
                           boxShadow: [
                            BoxShadow(
                              color: Colors.black54.withOpacity(0.1),
                              blurRadius: 10,
                              spreadRadius: 2,
                              offset: Offset(0, 4),
                            )
                           ]
                         ),
                         child: Padding(
                           padding: const EdgeInsets.all(8.0),
                           child: Column(
                             children: [
                               myTextField(
                                   label:"Full Name",
                                   controller: nameController,
                                   isPass: false,
                               ),
                               SizedBox(height: 25),
                               myTextField(
                                  label:"Phone",
                                  controller: phoneController,
                                  isPass: false,

                               ),
                               SizedBox(height: 25),
                               TextFormField(
                                controller: birthdayController,
                                readOnly: true,

                                decoration: InputDecoration(
                                  labelText: "Date of Birth",
                                  suffixIcon: Icon(Icons.cake),

                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(17)
                                  ),
                                ),

                                onTap: () async {
                                  DateTime? pickedDate = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(1900),
                                    lastDate: DateTime.now(),
                                  );

                                  if (pickedDate != null) {
                                    String formattedDate =
                                        "${pickedDate.day.toString().padLeft(2, '0')}/"
                                        "${pickedDate.month.toString().padLeft(2, '0')}/"
                                        "${pickedDate.year}";

                                    setState(() {
                                      birthdayController.text = formattedDate;
                                    });
                                  }
                                }
                                ),
                               SizedBox(height: 25),

                               myTextField(
                                 label:"Location",
                                 controller: locationController,
                                 isPass: false,

                               ),
                             ],
                           ),
                         ),
                       ),
                      Spacer(),
                      Center(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black54.withOpacity(0.1),
                                blurRadius: 10,
                                spreadRadius: 2,
                                offset: Offset(0, 4),
                              )
                            ]
                          ),
                          child: OutlinedButton(
                              onPressed: () async{
                                await update();
                                setState(() {
                                  isEditing = false;
                                });
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Updated Successfully')),
                                );
                              },
                              child: Text(
                                  'Save',
                                  style: Text_Button_Styles.text3
                          )),
                        ),
                      )
                    ],
                  );
  }
}
