import 'package:ahlachat/util/Localization.dart';
import 'package:ahlachat/util/SizeConfig.dart';
import 'package:ahlachat/util/app_constants.dart';
import 'package:ahlachat/util/helperclass.dart';
import 'package:ahlachat/util/styles.dart';
import 'package:ahlachat/view/Screans/Family/FamilyRankScrean.dart';
import 'package:ahlachat/view/Screans/Family/MemberFamilyRank.dart';
import 'package:ahlachat/view/Screans/MainScreans/MainScrean/widgets/ImageSlide.dart';
import 'package:ahlachat/view/Screans/MainScreans/MainScrean/widgets/RoomsContainer.dart';
import 'package:ahlachat/viewmodels/Auth_Viewmodel/LoginViewModel.dart';
import 'package:ahlachat/viewmodels/Family_ViewModel/Family_ViewModel.dart';
import 'package:flutter/material.dart';
import 'package:ahlachat/models/RoomModel.dart';
import 'package:ahlachat/viewmodels/Animated_Viewmodel/ElementViewModel.dart';
import 'package:ahlachat/viewmodels/Room_Viewmodel/Room_Viewmodel.dart';
import 'package:ahlachat/viewmodels/Socket_ViewModel/Socketviewmodel.dart';
import 'package:provider/provider.dart';

class TrendScrean extends StatelessWidget {
  ScrollController? _controller= ScrollController();
  int showed_ads = 0;
  @override
  Widget build(BuildContext context) {
    RoomViewmodel Rooms=  Provider.of<RoomViewmodel>(context,listen: true);
     LoginViewmodel user=  Provider.of<LoginViewmodel>(context,listen: true);
    FamilyViewModel  Family=Provider.of<FamilyViewModel>(context,listen:  true);

    roomcontext=context;
    void _scrollListener() {
      if((_controller?.offset??0) >= (_controller?.position.maxScrollExtent??0)-20 && !Rooms.showloading2){
        Rooms.GetMoreRoom(context);
      }
    }
    _controller?.addListener(_scrollListener);
    return RefreshIndicator(color:MainColor, onRefresh: ()async{
      Provider.of<RoomViewmodel>(context,listen: false).GetRoom(context: context);
      Provider.of<RoomViewmodel>(context,listen: false).GetFixedRoom(context: context);
    },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: CustomScrollView(cacheExtent: 20.0,
              controller: _controller,
              slivers: <Widget>[

                    SliverToBoxAdapter(
                  child:  user.Banners.isEmpty?SizedBox():ImageSlide(),
                ),        SliverPadding(padding: EdgeInsets.only(top: 5)),
             if(Rooms.FixedRooms.length!=0)
               SliverToBoxAdapter(
                 child: Container(height: 200,width: SizeConfig.screenWidth,
                   child:
                       Row(
                         children: [
                           if(Rooms.FixedRooms.length>=2)  Expanded(
                             child: Column(
                               children: [
                                 if(Rooms.FixedRooms.length>0)     Expanded(
                                   child: InkWell(onTap: ()
                                   {
                                   Rooms.EnterRoom(context: context,id:Rooms.FixedRooms[0].id,adminId:  Rooms.FixedRooms[0].adminId  );
                                   },child:  RoomsContainer(Roominfo: Rooms.FixedRooms[0],)),
                                 ),
                                 if(Rooms.FixedRooms.length>1)     Expanded(
                                   child: InkWell(onTap: ()
                                   {
                                     Rooms.EnterRoom(context: context,id:Rooms.FixedRooms[1].id,adminId:  Rooms.FixedRooms[1].adminId  );
                                   },child:  RoomsContainer(Roominfo: Rooms.FixedRooms[1],)),
                                 ),
                               ],
                             ),
                           ),

                           if(Rooms.FixedRooms.length>=2)   SizedBox(width: 10,),

                           if(Rooms.FixedRooms.length>3)     Expanded(
                               child: InkWell(onTap: ()
                               {
                                 Rooms.EnterRoom(context: context,id:Rooms.FixedRooms[2].id,adminId:  Rooms.FixedRooms[2].adminId  );
                               },child:  RoomsContainer(Roominfo: Rooms.FixedRooms[2],)),
                             ),

                         ],
                       ),


                 ),
               ),

                SliverToBoxAdapter(
                  child: Row(
                    children: [
                      Expanded(child: InkWell(
                        onTap: () {
                          Navigator.pushNamed( context, AppConstants.LeaderboardScrean);
                          Provider.of<RoomViewmodel>(context,listen: false).GetRoomLeaderboard(context: context);

                        },
                        child: Container(child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Image.asset('assets/image/ic_hotlives_entry_family.png',height: 50),

                            Text(getLang(context: context, key: "Rank"),style: TextStyle(color: Colors.deepPurple,fontWeight: FontWeight.bold,fontSize: 17)),
                          ],
                        ),height: 65,decoration: BoxDecoration(borderRadius: BorderRadius.circular(5),image: DecorationImage(image: ExactAssetImage('assets/image/bg_hotlives_entry_family.png'),fit: BoxFit.fill,opacity: 0.6)),),
                      )),
                     SizedBox(width: 5,),
                      Expanded(child: InkWell(
                        onTap: () {
                          Rooms.GetFamilyLeaderboard(context: context);
                          navigateTo(context: context,screen: LeaderboardFamilyScrean());
                        },
                        child: Container(child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Image.asset('assets/image/ic_hotlives_entry_topboard.png',height: 50),
                            Text(getLang(context: context, key: "Family"),style: TextStyle(color: Colors.orange,fontWeight: FontWeight.bold,fontSize: 17)),
                          ],
                        ),height: 65,decoration: BoxDecoration(borderRadius: BorderRadius.circular(5),image: DecorationImage(image: ExactAssetImage('assets/image/bg_hotlives_entry_topboard.png'),fit: BoxFit.fill,opacity: 0.6)),),
                      ))

                    ],
                  ),
                ),
                SliverPadding(padding: EdgeInsets.only(top: 5)),


                SliverToBoxAdapter(
                    child:  Directionality(textDirection:TextDirection.ltr ,
                      child: Container( width: SizeConfig.screenWidth,height:50 ,child: ListView(scrollDirection:Axis.horizontal,
                        physics: BouncingScrollPhysics(),
                        children: [

                          Row(
                            children:List.generate(user.Roomcatigoris.length+1, (index){
                              if(index==0){
                                return  Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 2),
                                  child: InkWell( onTap: (){
                                    if(SelectedRoomCategory=="Hot" ){}else{
                                      Rooms.updateSelectedCategory(Category:"Hot" ,context: context);
                                    }

                                  },child: Container( height: 26,decoration: BoxDecoration(border: Border.all(color: Colors.black12),  color: SelectedRoomCategory=="Hot"?MainColor.withOpacity(0.2) :Colors.white,  borderRadius: BorderRadius.circular(5) ),child: Center(child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 20),
                                    child: Row(
                                      children: [
                                        Icon(Icons.star,color: MainColor,size: 16),
                                        Text(getLang(key: "popular",context: context),style: style6.copyWith(height: 2,color:Colors.black54  ,fontWeight: FontWeight.bold),),
                                      ],
                                    ),
                                  )),)),
                                );
                              }else{
                                return  Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 5),
                                  child: InkWell(onTap: (){
                                    if(SelectedRoomCategory==user.Roomcatigoris[index-1]['name'] ){}else{
                                      Rooms.updateSelectedCategory(Category:user.Roomcatigoris[index-1]['name'],context: context);
                                    }
                                  },child: Container( height: 26,decoration: BoxDecoration( border: Border.all(color: Colors.black12), color: SelectedRoomCategory==user.Roomcatigoris[index-1]['name']?MainColor.withOpacity(0.2) :Colors.white ,borderRadius: BorderRadius.circular(5) ),child: Center(child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 20),
                                    child: Text(user.Roomcatigoris[index-1]['name'],style: style6.copyWith(height:  1, fontSize: 14, color:   Colors.black54 ,fontWeight: FontWeight.bold),),
                                  )),)),
                                );
                              }
                            }
                            ) ,
                          ),
                        ],

                      )

                      ),
                    )
                ),

                SliverGrid(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio:0.8,
                      mainAxisSpacing: 5,
                      crossAxisSpacing: 7),
                  delegate: SliverChildBuilderDelegate( (context, index) {
                    List<RoomModel> RoomsList = Rooms.Rooms ;
                    return  InkWell(onTap: ()
                    {
                      Rooms.EnterRoom(context: context,id:RoomsList[index].id,adminId:  RoomsList[index].adminId  );


                    },child:  RoomsContainer(Roominfo: RoomsList[index] ));
                  },
                    childCount:Rooms.Rooms.length>4?4:Rooms.Rooms.length,
                  ),
                ),

                SliverPadding(padding: EdgeInsets.only(top: 5)),
                SliverGrid(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio:0.8,
                      mainAxisSpacing: 5,
                      crossAxisSpacing: 7),
                  delegate: SliverChildBuilderDelegate( (context, index) {
                    List<RoomModel> RoomsList = Rooms.Rooms.skip(4).toList() ;
                    return  InkWell(onTap: ()
                    {
                      Rooms.EnterRoom(context: context,id:RoomsList[index].id,adminId:  RoomsList[index].adminId  );


                    },child:  RoomsContainer(Roominfo: RoomsList[index]));
                  },
                    childCount: Rooms.Rooms.skip(4).length,
                  ),
                ),



              ],
            ),
      ),
    );
  }

}
