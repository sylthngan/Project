import 'package:flutter/material.dart';
import 'package:rental_room/style/color.dart';
import 'package:rental_room/style/styleButton_Text.dart';

class CityPick extends StatefulWidget {
  const CityPick({super.key});

  @override
  State<CityPick> createState() => _CityPickState();
}

class _CityPickState extends State<CityPick> {

  String? selectedCity;
  String? selectedWard;

  final List<String> cities = [
    "Da Nang City",
    "Ha Noi City",
    "Ho Chi Minh City",
    "Hue City",
    "Quang Nam Province",
  ];

  Map<String, List<String>> wardsByCity = {
    "Da Nang City": [
      "Lien Chieu Ward",
      "Hai Chau Ward",
      "Son Tra Ward",
      "Thanh Khe Ward",
      "My An Ward",
      "Hoa Khanh Ward",
      "Hoa Xuan Ward",
      "Cam Le Ward",
      "Ngu Hanh Son Ward",
      "An Hai Ward",
    ],

    "Ha Noi City": [
      "Ba Dinh Ward",
      "Dong Da Ward",
      "Hoan Kiem Ward",
      "Cau Giay Ward",
      "Thanh Xuan Ward",
      "Ha Dong Ward",
      "Long Bien Ward",
      "Tay Ho Ward",
      "Nam Tu Liem Ward",
      "Bac Tu Liem Ward",
    ],

    "Ho Chi Minh City": [
      "Ben Nghe Ward",
      "Thao Dien Ward",
      "Tan Dinh Ward",
      "Phu Nhuan Ward",
      "District 1 Ward",
      "District 7 Ward",
      "Binh Thanh Ward",
      "Thu Duc Ward",
      "Go Vap Ward",
      "Tan Binh Ward",

    ],

    "Hue City": [
      "Thuan Hoa Ward",
      "Vy Da Ward",
      "Phu Hoi Ward",
      "An Cuu Ward",
      "Kim Long Ward",
      "Huong So Ward",
    ],

    "Quang Nam Province": [
      "Dien Ban Ward",
      "Hoi An Ward",
      "Tam Ky Ward",
      "Nui Thanh Ward",
      "Duy Xuyen Ward",
      "Thang Binh Ward",
    ],
  };


  void resetSelection() {
    setState(() {
      selectedCity = null;
      selectedWard = null;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text('Select Location'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              color: const Color(0xfffafafa),
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Selected area ",
                    style: TextStyle(
                      color: Colors.grey.shade500,
                      fontSize: 15,
                    ),
                  ),
                  GestureDetector(
                    onTap: resetSelection,
                    child: Text(
                      "Reset",
                      style: TextStyle(
                        color: Colors.blueGrey,
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 20,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: selectedCity == null ? colorsyle.primary : const Color(0xffe6e6e6),
                        width: 1.5,
                      ),
                      color: selectedCity == null ? colorsyle.text4 : Colors.white,
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: selectedCity == null ? colorsyle.primary : Colors.grey.shade400,
                              width: 2,
                            ),
                          ),
                          child: Center(
                            child: Container(
                              width: 14,
                              height: 14,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: selectedCity == null ? colorsyle.primary : Colors.grey.shade400,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(width: 18),
                        Expanded(
                          child: Text(
                            selectedCity ?? "Choose city",
                              style: selectedCity == null ?Text_Button_Styles.text6 : Text_Button_Styles.text61
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 18),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 20,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: selectedCity != null &&
                            (selectedWard == null || selectedWard!.isEmpty) ? colorsyle.primary : const Color(0xffe6e6e6),

                        width: 1.5,
                      ),

                      color: selectedCity != null &&
                          (selectedWard == null || selectedWard!.isEmpty) ? colorsyle.text4 : Colors.white,
                    ),

                    child: Row(
                      children: [
                        Container(
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: selectedCity != null &&
                                  (selectedWard == null || selectedWard!.isEmpty) ? colorsyle.primary : Colors.grey.shade400,
                              width: 2,
                            ),
                          ),

                          child: Center(
                            child: Container(
                              width: 14,
                              height: 14,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: selectedCity != null &&
                                    (selectedWard == null || selectedWard!.isEmpty) ? colorsyle.primary : Colors.grey.shade400,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(width: 18),

                        Expanded(
                          child: Text(
                            selectedWard?.isNotEmpty == true ? selectedWard! : "Choose ward/commune",
                            style: selectedCity != null && (selectedWard == null || selectedWard!.isEmpty)
                                ? Text_Button_Styles.text6
                                : Text_Button_Styles.text61
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )
            ),
            const SizedBox(height: 25),
            Container(
              width: double.infinity,
              color: const Color(0xfff3f3f3),
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              child: Text(
                selectedCity == null
                    ? "Province/City"
                    : "Ward/Commune",
                style: Text_Button_Styles.text3
              ),
            ),
            Expanded(
              child: ListView.separated(
                itemCount: selectedCity == null
                    ? cities.length
                    : (wardsByCity[selectedCity]?.length ?? 0),
                separatorBuilder: (_, __) {
                  return Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Divider(
                      color: Colors.grey.shade300,
                      height: 1,
                    ),
                  );
                },
                itemBuilder: (context, index) {
                  if (selectedCity == null) {
                    final city = cities[index];
                    return InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: () {
                        setState(() {
                          selectedCity = city;
                          selectedWard = null;
                        });
                      },

                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        margin: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 7,
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 15,
                        ),
                        decoration: BoxDecoration(
                          color: selectedCity == city
                              ? const Color(0xfffff1ee)
                              : Colors.white,

                          borderRadius: BorderRadius.circular(16),

                          border: Border.all(
                            color: Colors.grey.shade300,
                            width: 1.5,
                          ),

                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.03),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),

                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                city,
                                style: Text_Button_Styles.text8
                              ),
                            ),

                            if (selectedCity == city)
                              const Icon(
                                Icons.check_circle,
                                color: Color(0xfff05a3f),
                                size: 24,
                              ),
                          ],
                        ),
                      ),
                    );
                  }

                  final ward = wardsByCity[selectedCity]![index];
                  return InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () {
                      setState(() {
                        selectedWard = ward;
                      });
                      Future.delayed(
                        const Duration(milliseconds: 250),
                            () {
                          Navigator.pop(
                            context,
                            "$selectedCity, $selectedWard",
                          );
                        },
                      );
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      margin: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 7,
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 15,
                      ),
                      decoration: BoxDecoration(
                        color: selectedWard == ward
                            ? const Color(0xfffff1ee)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Colors.grey.shade300,
                          width: 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.03),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),

                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              ward,
                              style: Text_Button_Styles.text8
                            ),
                          ),
                          if (selectedWard == ward)
                            const Icon(
                              Icons.check_circle,
                              color: Color(0xfff05a3f),
                              size: 24,
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
