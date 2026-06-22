import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:rental_room/Pages/Menu/PersonalPage/getLatLng.dart';
import 'package:rental_room/style/color.dart';
import 'package:rental_room/style/styleButton_Text.dart';
import 'package:uuid/uuid.dart';
import '../../Home/PostService.dart';
import 'package:rental_room/Model/Post.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

import '../MapPick.dart';

class CreatePostPage extends StatefulWidget {
  const CreatePostPage({super.key});

  @override
  State<CreatePostPage> createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage> {
  int currentStep = 1;

  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final addressController = TextEditingController();
  final priceController = TextEditingController();
  final areaController = TextEditingController();

  final floorController = TextEditingController();
  final houseFloorController = TextEditingController();
  final bedroomController = TextEditingController();
  final bathroomController = TextEditingController();
  final kitchenRoomController = TextEditingController();

  final PostService postService = PostService();
  String selectedType = 'Apartment';
  int selectedFloor = 1;

  double pickedLat = 0;
  double pickedLng = 0;
  String selectedCity = '';
  String selectedDistrict = '';
  String selectedWard = '';

  List<Map<String, dynamic>> amenities = [
    {"key": "airConditioner", "title": "Air\nConditioner", "icon": Icons.ac_unit, "value": false},
    {"key": "fan", "title": "Fan", "icon": Icons.mode_fan_off_outlined, "value": false},
    {"key": "refrigerator", "title": "Refrigerator", "icon": Icons.kitchen, "value": false},
    {"key": "washingMachine", "title": "Washing\nMachine", "icon": Icons.local_laundry_service, "value": false},
    {"key": "waterHeater", "title": "Water\nHeater", "icon": Icons.water_drop_outlined, "value": false},
    {"key": "bed", "title": "Bed", "icon": Icons.bed, "value": false},
    {"key": "kitchen", "title": "Kitchen", "icon": Icons.countertops, "value": false},
    {"key": "parking", "title": "Parking", "icon": Icons.local_parking, "value": false},
    {"key": "elevator", "title": "Elevator", "icon": Icons.elevator, "value": false},
    {"key": "pool", "title": "Pool", "icon": Icons.pool, "value": false},
    {"key": "gym", "title": "Gym", "icon": Icons.fitness_center, "value": false},
    {"key": "wifi", "title": "Wifi", "icon": Icons.wifi, "value": false},
    {"key": "petAllowed", "title": "Pet", "icon": Icons.pets, "value": false},
    {"key": "balcony", "title": "Balcony", "icon": Icons.balcony, "value": false},
    {"key": "securityCamera", "title": "Security\nCamera", "icon": Icons.videocam_outlined, "value": false},
  ];

  Future<void> createPost() async {
    try {
      if (FirebaseAuth.instance.currentUser == null) {
        throw "User not logged in. Please check main.dart and login again.";
      }

      if (selectedImages.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please select at least one image")));
        return;
      }

      if (pickedLat == 0 || pickedLng == 0) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please pick a location on map")));
        return;
      }

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      String uid = FirebaseAuth.instance.currentUser!.uid;
      String postId = const Uuid().v4();

      List<String> imageUrls = await uploadImages();

      String cleanPrice = priceController.text.replaceAll('.', '').replaceAll(',', '');
      
      PostModel post = PostModel(
        postId: postId,
        uid: uid,
        type: selectedType,
        title: titleController.text.isEmpty ? "No Title" : titleController.text,
        description: descriptionController.text,
        price: double.tryParse(cleanPrice) ?? 0,
        deposit: 0,
        lat: pickedLat,
        lng: pickedLng,
        images: imageUrls,
        street: addressController.text,
        ward: selectedWard,
        district: selectedDistrict,
        city: selectedCity,
        bedroom: int.tryParse(bedroomController.text) ?? 0,
        bathroom: int.tryParse(bathroomController.text) ?? 0,
        area: double.tryParse(areaController.text) ?? 0,
        airConditioner: amenities.firstWhere((e) => e['key'] == 'airConditioner')['value'],
        washingMachine: amenities.firstWhere((e) => e['key'] == 'washingMachine')['value'],
        refrigerator: amenities.firstWhere((e) => e['key'] == 'refrigerator')['value'],
        fan: amenities.firstWhere((e) => e['key'] == 'fan')['value'],
        bed: amenities.firstWhere((e) => e['key'] == 'bed')['value'],
        wifi: amenities.firstWhere((e) => e['key'] == 'wifi')['value'],
        kitchen: amenities.firstWhere((e) => e['key'] == 'kitchen')['value'],
        parking: amenities.firstWhere((e) => e['key'] == 'parking')['value'],
        elevator: amenities.firstWhere((e) => e['key'] == 'elevator')['value'],
        pool: amenities.firstWhere((e) => e['key'] == 'pool')['value'],
        gym: amenities.firstWhere((e) => e['key'] == 'gym')['value'],
        petAllowed: amenities.firstWhere((e) => e['key'] == 'petAllowed')['value'],
        balcony: amenities.firstWhere((e) => e['key'] == 'balcony')['value'],
        securityCamera: amenities.firstWhere((e) => e['key'] == 'securityCamera')['value'],
        waterHeater: amenities.firstWhere((e) => e['key'] == 'waterHeater')['value'],
        available: true,
        status: 'available',
        floor: selectedType == "Apartment" ? selectedFloor : (int.tryParse(houseFloorController.text) ?? 0),
        maxPeople: 1,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        views: 0,
        favorites: 0,
      );

      await postService.createPost(post);
      
      Navigator.pop(context); 
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Created post successfully")));
      Navigator.pop(context);

    } catch (e) {
      if (Navigator.canPop(context)) Navigator.pop(context); 
      print("CREATE POST ERROR: $e");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

  final ImagePicker picker = ImagePicker();
  List<File> selectedImages = [];
  Future<void> _pickAddress() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const LocationAdd()),
    );

    if (result != null && result is String) {
      setState(() {
        addressController.text = result;
      });

      final pos = await getLatLngFromAddress(result);

      setState(() {
        pickedLat = pos["lat"]!;
        pickedLng = pos["lng"]!;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leadingWidth: 90,
          leading: Center(
            child: TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel", style: Text_Button_Styles.text8),
            ),
          ),
          centerTitle: true,
          title: Text("Create post", style: Text_Button_Styles.text6),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 15),
              child: GestureDetector(
                onTap: () {
                  if (currentStep < 3) {
                    setState(() => currentStep++);
                  } else {
                    createPost();
                  }
                },
                child: Center(
                  child: Text(currentStep == 3 ? "Complete" : "Continuous", style: Text_Button_Styles.text8),
                ),
              ),
            )
          ],
        ),
        floatingActionButton: currentStep > 1
            ? FloatingActionButton.extended(
          backgroundColor: colorsyle.primary,
          onPressed: () => setState(() => currentStep--),
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 18),
          label: const Text("Back", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
        ) : null,
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  buildStepItem(1, "Information"),
                  buildStepItem(2, "Image"),
                  buildStepItem(3, "Accept"),
                ],
              ),
              const SizedBox(height: 18),

              if(currentStep == 1)...[
                Text("Post Information", style: Text_Button_Styles.text2),
                const SizedBox(height: 10),
                Text("Title", style: Text_Button_Styles.text3),
                const SizedBox(height: 10),
                buildField(hint: "Enter post title", controller: titleController),
                const SizedBox(height: 10),
                Text("Description", style: Text_Button_Styles.text3),
                const SizedBox(height: 10),
                TextField(
                  controller: descriptionController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: "Describe your rental place...",
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                const SizedBox(height: 20),
                Text("Type places", style: Text_Button_Styles.text2),
                const SizedBox(height: 15),
                Row(
                  children: [
                    buildTypeButton("Room", "Room"),
                    buildTypeButton("Apartment", "Apartment"),
                    buildTypeButton("House", "House"),
                  ],
                ),
                const SizedBox(height: 20),
                Text("Detailed structure", style: Text_Button_Styles.text2),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Bedroom", style: Text_Button_Styles.text3),
                          const SizedBox(height: 10),
                          buildField(hint: "0", controller: bedroomController, type: TextInputType.number),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Bathroom", style: Text_Button_Styles.text3),
                          const SizedBox(height: 10),
                          buildField(hint: "0", controller: bathroomController, type: TextInputType.number),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text("Address", style: Text_Button_Styles.text3),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: _pickAddress,
                  child: AbsorbPointer(
                    child: buildField(
                      hint: "Choose address",
                      controller: addressController,
                      readOnly: true,
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Price", style: Text_Button_Styles.text3),
                          const SizedBox(height: 10),
                          buildField(hint: "1.000.000", controller: priceController, type: TextInputType.number),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Area", style: Text_Button_Styles.text3),
                          const SizedBox(height: 10),
                          buildField(hint: "60", controller: areaController, type: TextInputType.number),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                if(selectedType == "Apartment")...[
                  Text("Floor (Apartment)", style: Text_Button_Styles.text3),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), border: Border.all(color: colorsyle.textPrimary)),
                    child: DropdownButton<int>(
                      value: selectedFloor,
                      isExpanded: true,
                      underline: const SizedBox(),
                      items: List.generate(10, (index) => DropdownMenuItem(
                        value: index + 1,
                        child: Text("Floor ${index + 1}", style: Text_Button_Styles.text8),
                      )),
                      onChanged: (value) => setState(() => selectedFloor = value!),
                    ),
                  ),
                ],
                if(selectedType == "House")...[
                  Text("Floor (House)", style: Text_Button_Styles.text3),
                  const SizedBox(height: 10),
                  buildField(hint: "0", controller: houseFloorController, type: TextInputType.number),
                ],
                const SizedBox(height: 20),
                Text("Rental Service", style: Text_Button_Styles.text2),
                const SizedBox(height: 18),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: amenities.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3, mainAxisSpacing: 10, crossAxisSpacing: 10, childAspectRatio: 0.90,
                  ),
                  itemBuilder: (context, index) => buildAmenity(index),
                ),
              ],

              if(currentStep == 2)...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Image", style: Text_Button_Styles.text2),
                    Text("${selectedImages.length}/10", style: TextStyle(color: Colors.grey.shade600, fontWeight: FontWeight.w500)),
                  ],
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: pickImages,
                  child: Container(
                    height: 140,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: colorsyle.textPrimary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: colorsyle.textPrimary),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 55, height: 55,
                          decoration: BoxDecoration(color: colorsyle.textPrimary.withOpacity(0.3), shape: BoxShape.circle),
                          child: Icon(Icons.add_photo_alternate_outlined, color: colorsyle.primary, size: 30),
                        ),
                        const SizedBox(height: 10),
                        Text("Add image", style: Text_Button_Styles.text6),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 25),
                if(selectedImages.isNotEmpty)...[
                  const Text("Image was chosen", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 18),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: selectedImages.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3, crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: 1,
                    ),
                    itemBuilder: (context, index) => Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(18),
                            image: DecorationImage(image: FileImage(selectedImages[index]), fit: BoxFit.cover),
                          ),
                        ),
                        Positioned(
                          right: 6, top: 6,
                          child: GestureDetector(
                            onTap: () => setState(() => selectedImages.removeAt(index)),
                            child: Container(
                              width: 28, height: 28,
                              decoration: const BoxDecoration(color: Colors.black54, shape: BoxShape.circle),
                              child: const Icon(Icons.close, color: Colors.white, size: 18),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],

              if(currentStep == 3)...[
                const Text("Confirm information", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                const SizedBox(height: 25),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(color: const Color(0xffF7F8FA), borderRadius: BorderRadius.circular(22)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildConfirmItem("Title", titleController.text),
                      buildConfirmItem("Type places", selectedType),
                      buildConfirmItem("Address", addressController.text),
                      buildConfirmItem("Rental Prices", priceController.text),
                      buildConfirmItem("Area", areaController.text),
                      buildConfirmItem("Images", "${selectedImages.length} images"),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget buildStepItem(int step, String title) {
    bool done = currentStep > step;
    bool active = currentStep == step;
    return Expanded(
      child: Column(
        children: [
          Row(
            children: [
              if (step != 1) Expanded(child: Container(height: 2, color: currentStep >= step ? colorsyle.primary : Colors.grey.shade200)),
              Container(
                width: 30, height: 30,
                decoration: BoxDecoration(shape: BoxShape.circle, color: active || done ? colorsyle.primary : Colors.grey.shade200),
                child: Center(child: Text("$step", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
              ),
              if (step != 3) Expanded(child: Container(height: 2, color: currentStep > step ? colorsyle.primary : Colors.grey.shade200)),
            ],
          ),
          const SizedBox(height: 6),
          Text(title, style: TextStyle(fontSize: 12, color: active ? colorsyle.primary : colorsyle.textPrimary)),
        ],
      ),
    );
  }

  Widget buildTypeButton(String type, String title) {
    bool selected = selectedType == type;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => selectedType = type),
        child: Container(
          height: 45, margin: const EdgeInsets.symmetric(horizontal: 4),
          alignment: Alignment.center,
          decoration: BoxDecoration(color: selected ? colorsyle.primary : Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: colorsyle.primary)),
          child: Text(title, style: TextStyle(color: selected ? Colors.white : colorsyle.primary, fontWeight: FontWeight.w600)),
        ),
      ),
    );
  }

  Widget buildField({
    required String hint,
    required TextEditingController controller,
    TextInputType type = TextInputType.text,
    bool readOnly = false,
  }){
    return SizedBox(
      height: 45,
      child: TextField(
        controller: controller,
        keyboardType: type,
        readOnly: readOnly,
        decoration: InputDecoration(
          hintText: hint,
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(horizontal: 14),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }

  Widget buildAmenity(int index) {
    final item = amenities[index];
    return GestureDetector(
      onTap: () => setState(() => item['value'] = !item['value']),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: item['value'] ? colorsyle.textPrimary.withOpacity(0.6) : const Color(0xffF3F4F8),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: item['value'] ? colorsyle.primary : Colors.transparent),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(item['icon'], size: 25, color: item['value'] ? colorsyle.primary : colorsyle.textPrimary),
            const SizedBox(height: 8),
            Text(item['title'], textAlign: TextAlign.center, style: item['value'] ? Text_Button_Styles.subtitle1 : Text_Button_Styles.text4),
          ],
        ),
      ),
    );
  }

  Future<void> pickImages() async {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: Icon(Icons.photo_library, color: colorsyle.primary),
              title: Text("Choose from Album", style: TextStyle(color: colorsyle.primary)),
              onTap: () async {
                Navigator.pop(context);
                final List<XFile> images = await picker.pickMultiImage();
                if (images.length + selectedImages.length > 10) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Maximum 10 images")));
                  return;
                }
                setState(() => selectedImages.addAll(images.map((e) => File(e.path))));
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<List<String>> uploadImages() async {
    const String cloudName = "djrmffdbo";
    const String uploadPreset = "rentalroom";

    List<String> urls = [];

    for (File image in selectedImages) {
      var request = http.MultipartRequest(
        "POST",
        Uri.parse("https://api.cloudinary.com/v1_1/$cloudName/image/upload"),
      );

      request.fields['upload_preset'] = uploadPreset;

      request.files.add(
        await http.MultipartFile.fromPath("file", image.path),
      );

      var response = await request.send();
      var resBody = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        var data = jsonDecode(resBody);
        urls.add(data["secure_url"]);
      } else {
        throw Exception("Upload failed: $resBody");
      }
    }

    return urls;
  }
  Widget buildConfirmItem(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 110, child: Text(title, style: TextStyle(color: colorsyle.textPrimary, fontWeight: FontWeight.w600))),
          Expanded(child: Text(value, style: TextStyle(fontWeight: FontWeight.bold, color: colorsyle.primary))),
        ],
      ),
    );
  }
}
