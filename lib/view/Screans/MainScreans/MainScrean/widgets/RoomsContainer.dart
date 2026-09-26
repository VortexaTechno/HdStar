import 'package:ahlachat/models/RoomModel.dart';
import 'package:ahlachat/util/helperclass.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../../util/images.dart';
import '../../../../../util/styles.dart';
class RoomsContainer extends StatelessWidget {
   RoomModel Roominfo;
   RoomsContainer({required this.Roominfo});
  @override
  Widget build(BuildContext context) {

    return  Stack(fit: StackFit.expand,children: [
      Column(
        children: [
          Expanded(child: Container(   decoration: BoxDecoration(    borderRadius: BorderRadius.circular(10), image: DecorationImage(fit: BoxFit.fill,image: CachedNetworkImageProvider(Roominfo.image??''))),)),
          SizedBox(height: 5,),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [


                Flexible(child: Text(Roominfo.name??'',maxLines: 1,style: style2.copyWith( color: Colors.black,fontSize: 12),)),


             //  Text(Helper().k_m_b_generator(Roominfo.Karisma),style: TextStyle().copyWith( color: Colors.black,fontSize: 10,fontWeight: FontWeight.normal),),
              ],
            ),
          ),
          SizedBox(height: 5,),
        ],
      ),
       Padding(
         padding: const EdgeInsets.symmetric(horizontal: 5,vertical: 3),
         child: Container(color: Colors.transparent,child: Column(
           mainAxisAlignment: MainAxisAlignment.spaceBetween,
           crossAxisAlignment: CrossAxisAlignment.start,
           children: [
             Row(
               children: [
                  Spacer(),
                 Row(
                   children: [
                     Text(Roominfo.userNumber!.abs().toString(),maxLines: 1,style: style1.copyWith( fontSize: 10),),
                     const SizedBox(width: 5,),
                     const FaIcon( FontAwesomeIcons.user,size: 12,color: whitecolor),
                   ],
                 ),

               ],
             ) ,
             Spacer(),

             SizedBox(height: 3,),

           ],
         ),),
       ),
    if(Roominfo.locked==1)  Align(alignment: Alignment.center,child: SizedBox(width: 30,height: 30,child: Image.asset('assets/image/roomlocak.png')))
    ], 
    );


  }
}
