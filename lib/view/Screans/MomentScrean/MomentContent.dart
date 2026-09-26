import 'package:ahlachat/models/PostsModel.dart';
import 'package:ahlachat/view/Screans/UserProfile/ShowUserProfile.dart';
import 'package:ahlachat/view/widgets/ImageView.dart';
import 'package:ahlachat/view/widgets/UserSideInfoWidget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:ahlachat/models/CommentsModel.dart';
import 'package:ahlachat/models/Likemodel.dart';
import 'package:ahlachat/util/Dialogs.dart';
import 'package:ahlachat/util/Localization.dart';
import 'package:ahlachat/util/SizeConfig.dart';
import 'package:ahlachat/util/app_constants.dart';
import 'package:ahlachat/util/helperclass.dart';
import 'package:ahlachat/util/styles.dart';
import 'package:ahlachat/viewmodels/Auth_Viewmodel/LoginViewModel.dart';
import 'package:ahlachat/viewmodels/Follow_ViewModel/Follow_ViewModel.dart';
import 'package:ahlachat/viewmodels/Moment_Viewmodel/Moment_ViewModel.dart';
import 'package:ahlachat/viewmodels/Room_Viewmodel/Room_Viewmodel.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
class Momentcontent extends StatelessWidget {
  Postes ChoosePost;
  Momentcontent({required this.ChoosePost});
  TextEditingController Message=TextEditingController();
  TextEditingController MessageReplay=TextEditingController();

  @override
  Widget build(BuildContext context) {

      FollowViewModel Follow=  Provider.of<FollowViewModel>(context,listen: true);
    MomentViewModel   posts=Provider.of<MomentViewModel>(context,listen: true);
    LoginViewmodel user = Provider.of<LoginViewmodel>(context, listen: true);


    return  Scaffold(
      appBar: AppBar(leading: IconButton(
        icon: Icon(Icons.navigate_before, color: Colors.black),
        onPressed: () => Navigator.of(context).pop(),
      ), title:   Text('',style: style4.copyWith(height: 1,color: Colors.black87,fontWeight: FontWeight.normal)),centerTitle: false),
      body:  Scaffold(



     body:Padding(
       padding: const EdgeInsets.all(8.0),
       child: Stack(
         children: [
           CustomScrollView(physics: BouncingScrollPhysics(),
             slivers: <Widget>[



               SliverToBoxAdapter(child: Padding(
                 padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 5),
                 child: Text('Comments',style: styleb45.copyWith(fontSize: 15, fontWeight: FontWeight.w400,color:MainColor)),
               ),),
               SliverToBoxAdapter(child: Column(
                 children: List.generate(ChoosePost.commentsuser?.length??0, (indexx){
                   List<Comments> comments= ChoosePost.commentsuser?.reversed.toList()??[];
                   return Padding(
                     padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                     child: Container(
                       child:Column(mainAxisAlignment: MainAxisAlignment.start,
                         crossAxisAlignment: CrossAxisAlignment.start,
                         children: [
                           Row(crossAxisAlignment: CrossAxisAlignment.start,
                             children: [
                               InkWell( onTap: () {
                                 if(comments[indexx].user?.id!=user.userinfo?.id){
                                   user.GetShoweduserProfile(comments[indexx].user);
                                   navigateTo(context: context,screen: ShowUserProfile());
                                 }
                               },
                                 child: Row(mainAxisAlignment: MainAxisAlignment.start,
                                   children: [
                                     CircleAvatar(backgroundColor: Colors.transparent,backgroundImage:CachedNetworkImageProvider(comments[indexx].user?.image??'') ,),
                                     SizedBox(width: 5,),
                                     UserSideInfoWidgets(showdescr:1 ,UserDate: comments[indexx].user,)
                                   ],
                                 ),
                               ),
                               Spacer(),
                               Text(Helper().getTimeago(time: comments[indexx].createdAt),style: styleb45.copyWith(fontSize: 11),)

                             ],
                           ),
                           Text(comments[indexx].comment??'',style: styleb.copyWith(color: Colors.black87,fontSize: 12),),
                           comments[indexx].commentReplay==''||comments[indexx].commentReplay==null ?  SizedBox()  : Container(decoration: BoxDecoration(color: whitecolor,borderRadius: BorderRadius.circular(10)), width: SizeConfig.screenWidth!,child: Column(
                             crossAxisAlignment: CrossAxisAlignment.start,
                             mainAxisAlignment: MainAxisAlignment.start,
                             children: [
                               InkWell(onTap: (){
                                 if(user.checkuserkind(context: context,id:ChoosePost.user?.id)){

                                   Dialogs().showtoast(getLang(context: context, key: "Its_Profile"));
                                 }else{
                                   user.GetShoweduserProfile(ChoosePost.user);
                                   Navigator.pushNamed(context, AppConstants.ShowUser_Profile);
                                   print('object');
                                 }
                               },
                                 child: Row(mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.start,children: [
                                   Padding(
                                     padding: const EdgeInsets.all(6.0),
                                     child: CircleAvatar(backgroundColor: Colors.transparent,radius:18,backgroundImage: CachedNetworkImageProvider(ChoosePost.user?.image??''),),
                                   ),
                                   Column(crossAxisAlignment: CrossAxisAlignment.start,
                                     mainAxisAlignment: MainAxisAlignment.start,
                                     children: [
                                       Text(ChoosePost.user?.name??'',style: style6.copyWith(fontSize: 12)),
                                       const          SizedBox(height: 5,),
                                       Text(Helper().getTimeago(time:comments[indexx].updatedAt),style: styleb45.copyWith(fontSize: 11),)
                                     ],
                                   ),
                                   const Spacer(),
                                 ],),
                               ),
                               Padding(
                                 padding: const EdgeInsets.only(left: 50),
                                 child: Text(comments[indexx].commentReplay??'',style: styleb.copyWith(color: Colors.black87,fontSize: 12),),
                               ),

                             ],
                           ),)

                         ],

                       ) ,
                     ),
                   );
                 }),
               ),),
               SliverToBoxAdapter(child: Padding(
                 padding: const EdgeInsets.symmetric(vertical: 20,horizontal: 5),
                 child: Container(color: Colors.black12,height: 0.5,width: SizeConfig.screenWidth),
               ),),
               //SliverList
             ], //<Widget>[]
           ),
           Align(alignment: Alignment.bottomCenter,child: Container(height: 40,child: Row(
             children: [


            Expanded(child: Container(child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
              child:  TextFormField(decoration: InputDecoration.collapsed(hintText: 'Say Something....'),controller: Message),
            ),decoration: BoxDecoration(color:whitecolor3,borderRadius: BorderRadius.circular(20)),)),
               SizedBox(width: 5,),
               InkWell(onTap: () {
                 if(Message.text!=''){
                   FocusScope.of(context).unfocus();
                   posts.AddComment(Postid:ChoosePost.id,Comment: Message.text,context: context  );
                   Message.clear();

                 }

               },child: Icon(Icons.send_outlined,size: 30,color: MainColor)),
               SizedBox(width: 5,),
             ],
           ),decoration: BoxDecoration(color: Colors.white),width: SizeConfig.screenWidth, ))
         ],
       )
     ),
   ),
    );


  }

}

// if((comments[indexx].commentReplay==''||comments[indexx].commentReplay==null)&&user.userinfo?.id.toString()==ChoosePost.user?.id.toString()&&user.userinfo?.id.toString()!=comments[indexx].user?.id.toString())
// InkWell(onTap: (){
// commentsid=comments[indexx].id;
// indexcomment=indexx;
// Room.showSpinner27();
// },
// child: Padding(
// padding: const EdgeInsets.all(8.0),
// child:   Icon(Icons.chat,color: MainColor),
// ),
// )

// if (!Room.showloading26)const SizedBox() else Container(color: Colors.transparent,
// child: ListView(
// reverse: true,
// children: <Widget>[
// Container(color: whitecolor,child: Row(
// children: [
// const  SizedBox(width: 10,),
//
// Expanded(child: ChatTextField(autofocus: true,hight: 30,radius: 25,hint: getLang(context: context,key: "Add_comment"),Controller:Message)),
// Padding(
// padding: const EdgeInsets.symmetric(horizontal: 10),
// child: Center(child: Icon(Icons.send_outlined,color: whitecolor,)),
// ),
//
// ],
// )),
// ].reversed.toList(),
// ),
// ),
// if (!Room.showloading27)const SizedBox() else  Container(color: Colors.transparent,
// child: ListView(
// reverse: true,
// children: <Widget>[
// Container(color: whitecolor,child: Row(
// children: [
// const        SizedBox(width: 10,),
//
// Expanded(child: ChatTextField(autofocus: true,hight: 30,radius: 25,hint: getLang(context: context,key: "Add_Reply"),Controller:MessageReplay)),
// InkWell(onTap: (){
// if(MessageReplay.text==''){
// }else{
// posts.ReplayComment(Commentid: commentsid,context: context,Replay:   MessageReplay.text ,index:index,indexx: indexcomment );
// Room.hiddenSpinner27();
// }
//
//
// },
// child: Padding(
// padding: const EdgeInsets.symmetric(horizontal: 10),
// child: Center(child: Icon(Icons.send_outlined,color: MainColor,)),
// ),
// ),
//
// ],
// )),
// ].reversed.toList(),
// ),
// )