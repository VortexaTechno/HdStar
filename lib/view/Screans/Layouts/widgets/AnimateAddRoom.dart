import 'package:ahlachat/viewmodels/Socket_ViewModel/Socketviewmodel.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../util/Dialogs.dart';
import '../../../../util/Localization.dart';
import '../../../../util/SizeConfig.dart';
import '../../../../util/app_constants.dart';
import '../../../../util/styles.dart';
import '../../../../viewmodels/Auth_Viewmodel/LoginViewModel.dart';
import '../../../../viewmodels/Room_Viewmodel/Room_Viewmodel.dart';

class AddRoomScrean extends StatefulWidget {
  const AddRoomScrean({Key? key}) : super(key: key);

  @override
  State<AddRoomScrean> createState() => _AddRoomScreanState();
}

class _AddRoomScreanState extends State<AddRoomScrean> {
  bool _loadingCategories = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _ensureCategories();
      // استرجاع الصورة لو أندرويد قتل التطبيق أثناء فتح المعرض
      Provider.of<RoomViewmodel>(context, listen: false).retrieveLostData();
    });
  }

  bool _triedReload = false;

  Future<void> _ensureCategories() async {
    final user = Provider.of<LoginViewmodel>(context, listen: false);
    if (user.Roomcatigoris.isNotEmpty || _triedReload) return;
    _triedReload = true;

    setState(() => _loadingCategories = true);
    try {
      await user.getAllconstant(context);
    } catch (e) {
      debugPrint('Reload categories error: $e');
    }
    if (!mounted) return;
    setState(() => _loadingCategories = false);
  }

  bool _canCreate(RoomViewmodel Room) {
    return Room.RoomName.text.trim().isNotEmpty &&
        Room.RoomAds.text.trim().isNotEmpty &&
        Room.choosen.isNotEmpty &&
        Room.Roomimage != null &&
        Room.backchoosen.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    RoomViewmodel Room = Provider.of<RoomViewmodel>(context, listen: true);
    LoginViewmodel user = Provider.of<LoginViewmodel>(context, listen: true);
    final bool canCreate = _canCreate(Room);

    return Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: CustomScrollView(
          slivers: [
            SliverPadding(padding: EdgeInsets.symmetric(vertical: 30)),
            SliverToBoxAdapter(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                      onTap: () {
                        Room.clearadd();
                        Navigator.pop(context);
                      },
                      child: const Icon(Icons.clear,
                          size: 25, color: Colors.black87)),
                ],
              ),
            ),
            SliverPadding(padding: EdgeInsets.symmetric(vertical: 5)),
            SliverToBoxAdapter(
              child: Center(
                child: InkWell(
                  onTap: () {
                    Room.getImage();
                  },
                  child: Container(
                      height: 90,
                      width: 100,
                      decoration: BoxDecoration(
                          color: Color(0xFFf8f9fb),
                          borderRadius: BorderRadius.circular(8)),
                      child: Room.Roomimage == null
                          ? Icon(Icons.image, color: Colors.black26, size: 50)
                          : ClipRRect(
                          borderRadius: BorderRadius.circular((10.0)),
                          child: Image.file(
                            Room.Roomimage,
                            fit: BoxFit.cover,
                            cacheWidth: 300, // فك الصورة بحجم صغير
                          ))),
                ),
              ),
            ),
            SliverPadding(padding: EdgeInsets.symmetric(vertical: 10)),
            SliverToBoxAdapter(
              child: Container(
                decoration: BoxDecoration(
                    color: Color(0xFFf8f9fb),
                    borderRadius: BorderRadius.circular(10)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    onChanged: (v) {
                      setState(() {});
                    },
                    controller: Room.RoomName,
                    cursorColor: MainColor,
                    decoration: InputDecoration.collapsed(
                      hintText: getLang(context: context, key: "Name_Room"),
                      hintStyle: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ),
            SliverPadding(padding: EdgeInsets.symmetric(vertical: 5)),
            SliverToBoxAdapter(
              child: Container(
                decoration: BoxDecoration(
                    color: Color(0xFFf8f9fb),
                    borderRadius: BorderRadius.circular(10)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    onChanged: (v) {
                      setState(() {});
                    },
                    controller: Room.RoomAds,
                    cursorColor: MainColor,
                    decoration: InputDecoration.collapsed(
                      hintText: getLang(context: context, key: "Room_ADS"),
                      hintStyle: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ),
            SliverPadding(padding: EdgeInsets.symmetric(vertical: 5)),

            // ---------- التصنيفات ----------
            if (user.Roomcatigoris.isEmpty)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Center(
                    child: _loadingCategories
                        ? const SizedBox(
                        height: 22,
                        width: 22,
                        child: CircularProgressIndicator(strokeWidth: 2))
                        : InkWell(
                      onTap: _ensureCategories,
                      child: const Text(
                        'لا توجد تصنيفات، اضغط لإعادة التحميل',
                        style: TextStyle(
                            fontSize: 13, color: Colors.black54),
                      ),
                    ),
                  ),
                ),
              )
            else
              SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    childAspectRatio: 2.7,
                    mainAxisSpacing: 5,
                    crossAxisSpacing: 5),
                delegate: SliverChildBuilderDelegate(
                      (context, index) {
                    final String catName =
                    user.Roomcatigoris[index]['name'].toString();
                    final bool isSelected = Room.choosen.contains(catName);
                    return InkWell(
                        onTap: () {
                          Room.choosen.clear();
                          setState(() {
                            Room.choosen.add(catName);
                          });
                        },
                        child: Container(
                            decoration: BoxDecoration(
                                color: !isSelected
                                    ? Color(0xFFf8f9fb)
                                    : Colors.yellowAccent.withOpacity(0.5),
                                borderRadius: BorderRadius.circular(10)),
                            child: Padding(
                              padding:
                              const EdgeInsets.symmetric(horizontal: 10),
                              child: Center(
                                  child: Text(catName,
                                      style: const TextStyle(
                                          fontSize: 12,
                                          height: 1,
                                          color: Colors.black))),
                            )));
                  },
                  childCount: user.Roomcatigoris.length,
                ),
              ),
            SliverPadding(padding: EdgeInsets.symmetric(vertical: 5)),

            // ---------- الخلفيات ----------
            SliverToBoxAdapter(
                child: SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        SizedBox(
                          width: 5,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: InkWell(
                              onTap: () {
                                // نمرر context الشاشة الحالية
                                Room.getImage3(context);
                              },
                              child: Container(
                                  child: Center(
                                      child: Icon(
                                        Icons.image_outlined,
                                        color: Colors.black26,
                                      )),
                                  height: 140,
                                  width: 80,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Color(0xFFf8f9fb)))),
                        ),
                        Row(
                            children: List.generate(
                                user.background.length,
                                    (index) => InkWell(
                                    onTap: () {
                                      Room.backchoosen.clear();
                                      Room.backchoosen
                                          .add(user.background[index]['image']);
                                      setState(() {});
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 5),
                                      child: Container(
                                        height: 140,
                                        width: 80,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                            BorderRadius.circular(10),
                                            border: Border.all(
                                                color: Room.backchoosen.contains(
                                                    user.background[index]
                                                    ['image'])
                                                    ? Colors.red
                                                    : Colors.transparent,
                                                width: 3),
                                            image: DecorationImage(
                                                image: CachedNetworkImageProvider(
                                                    AppConstants.Image_URL +
                                                        user.background[index]
                                                        ['image']),
                                                fit: BoxFit.cover)),
                                      ),
                                    )))),
                      ],
                    ))),
            SliverPadding(padding: EdgeInsets.symmetric(vertical: 5)),

            // ---------- زرار الإنشاء ----------
            SliverToBoxAdapter(
              child: InkWell(
                  onTap: () {
                    if (!canCreate) {
                      String missing = '';
                      if (Room.Roomimage == null) {
                        missing = 'اختر صورة الغرفة';
                      } else if (Room.RoomName.text.trim().isEmpty) {
                        missing = 'اكتب اسم الغرفة';
                      } else if (Room.RoomAds.text.trim().isEmpty) {
                        missing = 'اكتب وصف الغرفة';
                      } else if (Room.choosen.isEmpty) {
                        missing = user.Roomcatigoris.isEmpty
                            ? 'التصنيفات غير متاحة، أعد التحميل'
                            : 'اختر تصنيف الغرفة';
                      } else if (Room.backchoosen.isEmpty) {
                        missing = 'اختر خلفية الغرفة';
                      }
                      Dialogs().showtoast(missing);
                      return;
                    }

                    bool existed = false;
                    insult.forEach((item) {
                      if (item.contains(Room.RoomName.text)) {
                        existed = true;
                      }
                    });

                    if (existed) {
                      Room.Addinsults(
                          context: context,
                          message: Room.RoomName.text,
                          type: 'Create Room');
                      Dialogs().showdialog4(
                        context: context,
                        content: getLang(context: context, key: "sults"),
                      );
                    } else {
                      print('========== CREATE ROOM DATA (from screen) ==========');
                      print('name           : ${Room.RoomName.text}');
                      print('RoomAds        : ${Room.RoomAds.text}');
                      print('Category       : ${Room.choosen.first}');
                      print('city (flag)    : ${Room.flagchoosen}');
                      print('background     : ${Room.backchoosen.first}');
                      print('image path     : ${Room.Roomimage?.path}');
                      print('=====================================================');

                      Room.CreateRoom(
                          context: roomcontext,
                          name: Room.RoomName.text,
                          Category: Room.choosen.first,
                          city: Room.flagchoosen,
                          backgroundimage: Room.backchoosen.first);

                      Navigator.pop(context);
                    }
                  },
                  child: Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 0),
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: canCreate
                                  ? Colors.yellowAccent.withOpacity(0.5)
                                  : Colors.black12),
                          child: Center(
                              child: Text(
                                "انشاء",
                                style: style2,
                              )),
                          height: 45,
                          width: SizeConfig.screenWidth!,
                        ),
                      ))),
            ),
            SliverPadding(padding: EdgeInsets.symmetric(vertical: 60)),
          ],
        ),
      ),
    );
  }
}