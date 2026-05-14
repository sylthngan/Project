import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rental_room/Pages/Menu/MapPick.dart';
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

  Future<void> update() async {
    try {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(user!.uid)
          .update({
        "fullName": nameController.text.trim(),
        "phone": phoneController.text.trim(),
        "birthday": birthdayController.text.trim(),
        "location": locationController.text.trim(),
      });
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Updated Successfully",
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Update Failed: $e",
          ),
        ),
      );
    }
  }
  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    birthdayController.dispose();
    locationController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title:  Text(
          'Detail Profile',
          style: Text_Button_Styles.text2,
        ),

        actions: [
          IconButton(
            onPressed: () async{
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
                if(isEditing || nameController.text.isEmpty){
                  nameController.text = data["fullName"] ?? "Name";
                  phoneController.text = data["phone"] ?? "Phone number";
                  birthdayController.text = data["birthday"] ?? "00/00/0000";
                  locationController.text = data["location"] ?? "Location";
                }

                avt = (data["avatar"] == null || data["avatar"].toString().trim().isEmpty)?"" :data["avatar"];
                name =  (data["fullName"] == null || data["fullName"].toString().trim().isEmpty)?"Name" : data["fullName"] ;
                phone = (data["phone"] == null || data["phone"].toString().trim().isEmpty)? "Phone number ": data["phone"] ;
                birthday = (data["birthday"]==null || data["birthday"].toString().trim().isEmpty)? "00/00/0000" :data["birthday"];
                location = (data["location"] == null || data["location"].toString().trim().isEmpty)?"Location" : data["location"];
                return Padding(
                  padding: const EdgeInsets.fromLTRB(25.0, 8, 25, 8),
                  child: AnimatedSwitcher(

                    duration: const Duration(
                      milliseconds: 300,
                    ),
                    child: SingleChildScrollView(
                      keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,

                      padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
                      ),

                      child: isEditing ? canEditing(avt, context,) 
                        :noChange(avt, name, phone, birthday, location),
                    ),
                  ),
                );
              }
          )
      ),
    );
  }

  Column noChange(String avt, String name, String phone, String birthday, String location) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        avt.isNotEmpty ? Center(
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 15,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child:
            CircleAvatar(
              radius: 55,
              backgroundImage: NetworkImage(
                avt,
              ),
            ),
          ),
        ) :Center(
          child: Container(
            width: 110,
            height: 110,
            decoration: BoxDecoration(
              color: colorsyle.primary,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 15,
                  offset: Offset(0, 5),
                ),
              ],
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
        FieldNotChange(name, Icons.person_outline_rounded),
        SizedBox(height: 15),
        Text(
          'Phone',
          style: Text_Button_Styles.text3,
        ),
        FieldNotChange(phone, Icons.phone_outlined),
        SizedBox(height: 15),
        Text(
          'Birthday',
          style: Text_Button_Styles.text3,
        ),
        FieldNotChange(birthday, Icons.cake_outlined),
        SizedBox(height: 15),
        Text(
          'Location',
          style: Text_Button_Styles.text3,
        ),

        FieldNotChange(location, Icons.location_on_outlined)
      ],
    );
  }
  Container FieldNotChange(String label, IconData icon) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 13,
        vertical: 16,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: colorsyle.primary,
              size: 17,
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Text(
              label,
              style: Text_Button_Styles.text5,
            ),
          ),
        ],
      ),
    );
  }
  Column canEditing(String avt, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        avt.isNotEmpty ?
        Center(
          child: Container(
            child: Stack(
              children: [
                Container(
                  child: CircleAvatar(
                    radius: 55,
                    backgroundImage: NetworkImage(
                      avt,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: colorsyle.primary,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white,
                        width: 3,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 10,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.camera_alt_rounded,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ) : Center(

          child: Container(
            width: 110,
            height: 110,
            decoration: BoxDecoration(
              color: colorsyle.primary,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 15,
                  offset: Offset(0, 5),
                ),
              ],
            ),

            child: Stack(
              children: [
                Center(
                  child: Icon(
                    Icons.person_rounded,
                    color: Colors.white,
                    size: 40,
                  ),
                ),

                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 10,
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.camera_alt_rounded,
                      color: colorsyle.primary,
                      size: 18,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 40),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),

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
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: colorsyle.primary,
                  ),
                  decoration: InputDecoration(
                    labelText: "Date of Birth",
                    labelStyle: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                    suffixIcon: Icon(
                      Icons.cake_outlined,
                      color: colorsyle.primary,
                      size: 21,
                    ),
                    filled: true,
                    fillColor: Colors.grey.shade50,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 18,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18),
                      borderSide: BorderSide(
                        color: Colors.grey.shade300,
                        width: 1.2,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18),
                      borderSide: BorderSide(
                        color: colorsyle.primary,
                        width: 1.8,
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18),
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
                        birthdayController.text = formattedDate;});
                    }},
                  ),
                  SizedBox(height: 25),

                myTextField(
                  label: "Location",
                  controller: locationController,
                  isPass: false,
                  readOnly: true,
                  onTap: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const LocationAdd(),
                      ),
                    );

                    if (result != null) {
                      setState(() {
                        locationController.text = result;
                      });
                    }
                  },
                  suffixIcon: Icon(
                    Icons.location_on_outlined,
                    color: colorsyle.primary,
                  ),
                ),
                  SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    height: 45,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor:colorsyle.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius:BorderRadius.circular(18),
                        ),
                      ),
                      onPressed: () async {
                        await update();
                        setState(() {
                          isEditing = false;
                        });
                        },
                      child: const Text(
                          'Save Changes',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
      ]

    );
  }
}
