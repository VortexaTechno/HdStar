import 'package:ahlachat/util/helperclass.dart';
import 'package:ahlachat/view/Screans/Family/FamilyRankScrean.dart';
import 'package:ahlachat/view/Screans/WeeklyStar/WeeklyStarScrean.dart';
import 'package:ahlachat/viewmodels/Animated_Viewmodel/ElementViewModel.dart';
import 'package:flutter/material.dart';
import 'package:ahlachat/models/RoomModel.dart';
import 'package:ahlachat/util/Localization.dart';
import 'package:ahlachat/util/styles.dart';
import 'package:ahlachat/view/Screans/MainScreans/MainScrean/widgets/RoomsContainer.dart';
import 'package:ahlachat/viewmodels/Room_Viewmodel/Room_Viewmodel.dart';
import 'package:ahlachat/viewmodels/Socket_ViewModel/Socketviewmodel.dart';
import 'package:provider/provider.dart';

import '../../../../util/images.dart';
import '../../../../viewmodels/Auth_Viewmodel/LoginViewModel.dart';
import '../../../../viewmodels/Room_Viewmodel/Room_Viewmodel.dart';

class NewRoomsScrean extends StatelessWidget {
  ScrollController? _controller= ScrollController();
  int showed_ads = 0;
  @override
  Widget build(BuildContext context) {
    RoomViewmodel Rooms=  Provider.of<RoomViewmodel>(context,listen: true);
    SvgViewmodel svga=  Provider.of<SvgViewmodel>(context,listen: true);
    LoginViewmodel user=  Provider.of<LoginViewmodel>(context,listen: true);

    roomcontext=context;
    void _scrollListener() {
      if((_controller?.offset??0) >= (_controller?.position.maxScrollExtent??0)-20 && !Rooms.showloading2){
        Rooms.GetMoreNewRoom(context);
      }
    }
    _controller?.addListener(_scrollListener);
    return WillPopScope(onWillPop:()async{
      FocusScope.of(context).unfocus();
      return true;
    },
      child:  RefreshIndicator(color:MainColor, onRefresh: ()async{
        Rooms.GetNewRoom(context: context);
      },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CustomScrollView(cacheExtent: 10.0,physics: const BouncingScrollPhysics(),
            controller: _controller,
            slivers: <Widget>[


            SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio:0.9,
                  mainAxisSpacing: 5,
                  crossAxisSpacing:5),
              delegate: SliverChildBuilderDelegate( (context, index) {
                List<RoomModel> RoomsList = Rooms.NewRooms ;

                  return  InkWell(onTap: ()
                   {
                     Rooms.EnterRoom(context: context,id:RoomsList[index].id,adminId:  RoomsList[index].adminId  );
                  },child: RoomsContainer(Roominfo:RoomsList[index] ,));
                },
                childCount: Rooms.NewRooms.length,
              ),
            ),

          ],
          ),
        ),
      ),
    );
  }
}
