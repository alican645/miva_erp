import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';


class FotograflarWidget extends StatefulWidget {
  const FotograflarWidget({super.key});

  @override
  State<FotograflarWidget> createState() => _FotograflarWidgetState();
}

class _FotograflarWidgetState extends State<FotograflarWidget> {
  XFile? imageFile;
  List<XFile> xFileList = [];
  final imagePicker = ImagePicker();
  int currentIndex = 0;
  final PageController _pageController =
  PageController(); // PageController tanımladık

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 19, vertical: 10),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),

        ),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Fotoğraflar",

                    )),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: SizedBox(
                  height: 210, // Stack widget için belirli bir yükseklik
                  child: PageView.builder(
                    controller: _pageController,
                    onPageChanged: (index) {
                      setState(() {
                        currentIndex = index;
                        imageFile = xFileList[index];
                      });
                    },
                    itemCount: xFileList.isNotEmpty ? xFileList.length : 1,
                    itemBuilder: (context, index) {
                      return Stack(
                        children: [
                          Container(
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width*0.9,
                              height: 220,
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: xFileList.isNotEmpty
                                      ? Image.file(
                                    File(xFileList[index].path),
                                    fit: BoxFit.cover,
                                  )
                                      : Image.asset(
                                      "lib/assets/images/picture-icon-vector-illustration.jpg")),
                            ),
                          ),
                          Positioned(
                            right: 10,
                            top: 10,
                            child: DeleteButton(
                              onPressed: () {
                                if (xFileList.isNotEmpty) {
                                  setState(() {
                                    xFileList.removeAt(index);
                                    if (xFileList.isEmpty) {
                                      imageFile = null;
                                    } else {
                                      currentIndex = currentIndex.clamp(
                                          0, xFileList.length - 1);
                                      imageFile = xFileList[currentIndex];
                                    }
                                  });
                                }
                              },
                            ),
                          ),
                          Positioned(
                            left: 10,
                            right: 10,
                            bottom: 15,
                            child: Align(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.black45.withOpacity(0.7),
                                  borderRadius: BorderRadius.circular(45),
                                ),
                                child: SizedBox(
                                  width: 65,
                                  height: 40,
                                  child: Center(
                                    child: Text(
                                      style: const TextStyle(
                                          color: Colors.white),
                                      xFileList.isNotEmpty
                                          ? "${index + 1}/${xFileList.length}"
                                          : "0/0",
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 5),
                      child: _buildGestureDetector(),
                    ),
                    // Kaydırılabilir Row için SingleChildScrollView
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal, // Yatay kaydırma
                        child: Row(
                          children: List.generate(
                            xFileList.length,
                                (index) => GestureDetector(
                              onTap: () {
                                setState(() {
                                  currentIndex = index;
                                  imageFile = xFileList[index];
                                  _pageController.jumpToPage(
                                      index); // Tıklanan thumbnail ile PageView'in sayfasını değiştirme
                                });
                              },
                              child: Container(
                                //seçili durumda border olacak.
                                margin:
                                const EdgeInsets.symmetric(horizontal: 5),
                                height: 80,
                                width: 80,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.file(
                                    File(xFileList[index].path),
                                    fit: BoxFit
                                        .cover, // Resmi belirlenen alana sığdırmak için
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(200),
                    color: Color(0xff189DFD)),
                width: double.infinity,
                height: 56,
                child: Center(
                  child: Text(
                    "Değişiklikleri Kaydet",
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  GestureDetector _buildGestureDetector() {
    return GestureDetector(
                      onTap: () async {
                        XFile? pickedFile = await imagePicker.pickImage(
                            source: ImageSource.gallery);
                        if (pickedFile != null) {
                          setState(() {
                            xFileList.add(pickedFile);
                            imageFile = xFileList[0];
                            currentIndex = 0;
                          });
                        } else {
                          Fluttertoast.showToast(msg: 'No image selected.');
                        }
                      },
                      child: Icon(Icons.add)
                    );
  }
}

class DeleteButton extends StatefulWidget {
  final VoidCallback onPressed;
  DeleteButton({
    super.key,
    required this.onPressed,
  });

  @override
  State<DeleteButton> createState() => _DeleteButtonState();
}

class _DeleteButtonState extends State<DeleteButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onPressed,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(200),
          color: const Color(0xffFF6363),
        ),
        child: SizedBox(
          width: 75,
          height: 40,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset("lib/assets/icons/delete_2.png"),
              Text(
                "Sil",

              )
            ],
          ),
        ),
      ),
    );
  }
}