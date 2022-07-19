import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_base/commons/app_colors.dart';
import 'package:flutter_base/commons/app_images.dart';
import 'package:flutter_base/commons/app_text_styles.dart';
import 'package:flutter_base/ui/components/app_button.dart';
import 'package:flutter_base/ui/widgets/b_agri/app_bar_widget.dart';
import 'package:flutter_base/ui/widgets/b_agri/app_text_field.dart';
import 'package:image_picker/image_picker.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QRGeneratorPage extends StatefulWidget {
  @override
  _QRGeneratorPageState createState() => _QRGeneratorPageState();
}

class _QRGeneratorPageState extends State<QRGeneratorPage> {
  bool _value = true;
  bool _treeName = true;
  bool _plantingPlace = true;
  bool _season = true;
  bool _start_day = true;
  bool _end_day = true;
  bool _fruitQuantity = true;
  bool _manager = true;
  bool _process = true;

  // Image Picker
  final ImagePicker _picker = ImagePicker();
  List<XFile> _imageList = [];
  var search = false;

  PickedFile? imageFile = null;

  // Get from gallery
  void _openGallery(BuildContext context) async {
    final List<XFile>? pickedFiles = await _picker.pickMultiImage();
    if (pickedFiles!.isNotEmpty) {
      _imageList.addAll(pickedFiles);
    }
    setState(() {});
    Navigator.pop(context);
  }

  // Get from Camera
  void _openCamera(BuildContext context) async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile!.path.isNotEmpty) {
      _imageList.add(pickedFile);
    }
    setState(() {});
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarWidget(
          title: 'Tạo QR',
          context: context,
        ),
        body: SafeArea(
            child: Column(
          children: [
            Flexible(flex: 1, child: _body()),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: AppGreenButton(
                title: "Tạo QR code",
                onPressed: () {
                  showDialog(
                      context: context, builder: (context) => _dialogCreate());
                },
              ),
            )
          ],
        )));
  }

  Widget _body() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              "Thông tin chi tiết: ",
              style: AppTextStyle.greyS18Bold,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _informationItem(
                    selectValue: _treeName,
                    title: "Loại cây trồng:",
                    subtitle: "Dưa hoàng hậu",
                    onChanged: (bool value) {
                      setState(() {
                        _treeName = value;
                      });
                    }),
                _informationItem(
                    selectValue: _plantingPlace,
                    title: "Nơi trồng:",
                    subtitle: "Khu A - Vườn A1",
                    onChanged: (bool value) {
                      setState(() {
                        _plantingPlace = value;
                      });
                    }),
                _informationItem(
                    selectValue: _season,
                    title: "Mùa vụ: ",
                    subtitle: "Mùa xuân 2022",
                    onChanged: (bool value) {
                      setState(() {
                        _season = value;
                      });
                    }),
                _informationItem(
                    selectValue: _start_day,
                    title: "Ngày bắt đầu:",
                    subtitle: "01/01/2022",
                    onChanged: (bool value) {
                      setState(() {
                        _start_day = value;
                      });
                    }),
                _informationItem(
                    selectValue: _end_day,
                    title: "Ngày kết thúc",
                    subtitle: "01/03/2001",
                    onChanged: (bool value) {
                      setState(() {
                        _end_day = value;
                      });
                    }),
                SwitchListTile(
                  title: Row(
                    children: [
                      Flexible(
                          fit: FlexFit.tight,
                          child: Text("Số lượng quả ",
                              style: AppTextStyle.greyS16)),
                      Flexible(
                          fit: FlexFit.tight,
                          child: Container(
                            child: TextFormField(
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                suffixIcon: Icon(
                                  Icons.edit,
                                  color: AppColors.main,
                                ),
                                focusColor: AppColors.main,
                                hoverColor: AppColors.main,
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: AppColors.main),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: AppColors.main),
                                ),
                              ),
                            ),
                          ))
                    ],
                  ),
                  value: _value,
                  onChanged: (bool value) {
                    setState(() {
                      _value = value;
                    });
                  },
                  activeColor: AppColors.main,
                ),
              ],
            ),
            SizedBox(
              height: 15,
            ),
            Divider(
              height: 1,
              thickness: 1,
            ),
            SizedBox(
              height: 15,
            ),
            Row(
              children: [
                Flexible(
                  flex: 4,
                  fit: FlexFit.tight,
                  child: Text(
                    "Ngày hết hạn của QR: ",
                    style: AppTextStyle.greyS18Bold,
                  ),
                ),
                Flexible(
                    flex: 3,
                    fit: FlexFit.tight,
                    child: Row(
                      children: [
                        Text(
                          "12/01/2023",
                          style: AppTextStyle.greyS18,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        InkWell(
                          child: Icon(Icons.calendar_today,
                              size: 25, color: AppColors.main),
                          onTap: () {
                            print("change date");
                          },
                        )
                      ],
                    )),
              ],
            ),
            SizedBox(
              height: 15,
            ),
            Divider(
              height: 1,
              thickness: 1,
            ),
            SizedBox(
              height: 15,
            ),
            Text(
              "Quy trình chăm sóc: ",
              style: AppTextStyle.greyS18Bold,
            ),
            _informationItem(
                selectValue: _process,
                title: "Quy trình áp dụng:",
                subtitle: "Quy trình chuẩn 1",
                onChanged: (bool value) {
                  setState(() {
                    _process = value;
                  });
                }),
            Divider(
              height: 1,
              thickness: 1,
            ),
            SizedBox(
              height: 15,
            ),
            Row(
              children: [
                Text(
                  "Hình ảnh: ",
                  style: AppTextStyle.greyS18Bold,
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              child: _imageList.isEmpty
                  ? Padding(
                      padding: const EdgeInsets.only(left: 15),
                      child: addImage(),
                    )
                  : Padding(
                      padding: const EdgeInsets.only(left: 15),
                      child: GridView.builder(
                          shrinkWrap: true,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4,
                            crossAxisSpacing: 15,
                          ),
                          itemCount: _imageList.length + 1,
                          itemBuilder: (BuildContext context, int index) {
                            if (index == 0) {
                              return addImage();
                            } else
                              return _imageResult(_imageList[index - 1], index);
                          }),
                    ),
            ),
            SizedBox(
              height: 10,
            ),
            Divider(
              height: 1,
              thickness: 1,
            ),
            SizedBox(
              height: 15,
            ),
            Text(
              "Giới thiệu về sản phẩm: ",
              style: AppTextStyle.greyS18Bold,
            ),
            SizedBox(
              height: 10,
            ),
            AppTextAreaField(
              hintText: "Giới thiệu sản phẩm",
            ),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _informationItem(
      {required bool selectValue,
      String? title,
      String? subtitle,
      ValueChanged<bool>? onChanged}) {
    return SwitchListTile(
      title: Row(
        children: [
          Flexible(
              fit: FlexFit.tight,
              child: Text("${title}", style: AppTextStyle.greyS16)),
          Flexible(
              fit: FlexFit.tight,
              child: Text("${subtitle}", style: AppTextStyle.greyS16))
        ],
      ),
      value: selectValue,
      onChanged: onChanged,
      activeColor: AppColors.main,
    );
  }

  Widget addImage() {
    return InkWell(
        onTap: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                    title: Text(
                      'Lựa chọn',
                      style: TextStyle(fontWeight: FontWeight.normal),
                    ),
                    content: SingleChildScrollView(
                        child: ListBody(
                      children: [
                        InkWell(
                          onTap: () {
                            _openCamera(context);
                          },
                          splashColor: Colors.blue.withAlpha(30),
                          child: Row(
                            children: [
                              Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Icon(Icons.camera_alt)),
                              Text('Camera')
                            ],
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            _openGallery(context);
                          },
                          splashColor: Colors.blue.withAlpha(30),
                          child: Row(
                            children: [
                              Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Icon(Icons.image)),
                              Text('Thư viện')
                            ],
                          ),
                        )
                      ],
                    )));
              });
        },
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: Color(0xFFDFDFDE),
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            Icons.add_photo_alternate_outlined,
            color: AppColors.main,
            size: 55,
          ),
        ));
  }

  Widget _imageResult(var imageFile, int index) {
    return GestureDetector(
      onTap: () {
        //Navigator.of(context).push(MaterialPageRoute(builder:(context) => ShowFullImages(imageResultFull: imageFile)));
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Image.file(
              File(imageFile!.path),
              width: 75,
              height: 75,
              fit: BoxFit.fill,
            ),
            Positioned(
              right: 0,
              top: 0,
              child: InkWell(
                  onTap: () {
                    setState(() {
                      _imageList.removeAt(index - 1);
                    });
                  },
                  child: Icon(Icons.close, size: 22, color: Color(0xFFDFDFDE))),
            ),
          ],
        ),
      ),
    );
  }

  Widget _dialogCreate() {
    return StatefulBuilder(builder: (context, state) {
      return AlertDialog(
        backgroundColor: AppColors.mainDarker,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0))),
        title: Center(child: Text("Vườn A1 - Mùa 2022", style: TextStyle(color: Colors.white),)),
        content: Container(
          height: MediaQuery.of(context).size.height / 3,
          width: MediaQuery.of(context).size.width,
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
              ),
              child: QrImage(
                data: "https://pub.dev/packages/qr_flutter",
                version: QrVersions.auto,
                size: 200.0,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                whiteButton(title: "Đóng", color: AppColors.red),
                whiteButton(title: "Lưu", color: AppColors.mainDarker)],
            )
          ]),
        ),
      );
    });
  }

  Widget whiteButton({String? title, Color? color}) {
    return Container(
      width: MediaQuery.of(context).size.width / 3 - 20,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
      ),
      child: FlatButton(
          onPressed: () {
            print(title);
          },
          child: Text(
            "${title}",
            style: TextStyle(
              color: color,
            ),
          )),
    );
  }
}
