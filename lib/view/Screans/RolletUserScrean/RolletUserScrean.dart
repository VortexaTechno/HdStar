import 'dart:math';

import 'package:ahlachat/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:roulette/roulette.dart';

import '../../../util/images.dart';
import '../../../viewmodels/Room_Viewmodel/Room_Viewmodel.dart';

class MyRoulette extends StatelessWidget {
  const MyRoulette({
    super.key,
    required this.controller,
    required this.group,
  });

  final RouletteController controller;
  final RouletteGroup group;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        SizedBox(
          width: 260,
          height: 260,
          child: Padding(
            padding: const EdgeInsets.only(top: 30),
            child: Roulette(
              controller: controller,
              group: group,
              style: const RouletteStyle(
                dividerColor: Colors.white,
                dividerThickness: 4,
                textLayoutBias: .8,
                centerStickerColor: Colors.white,
              ),
            ),
          ),
        ),

        SizedBox(
          width: 30,
          height: 30,
          child: Image.asset(
            Images.roulettecenter,
          ),
        ),
      ],
    );
  }
}

class RolletFullscrean extends StatefulWidget {
  const RolletFullscrean({
    super.key,
  });

  @override
  State<RolletFullscrean> createState() => _RolletFullscreanState();
}

class _RolletFullscreanState extends State<RolletFullscrean> {
  final Random _random = Random();

  late RouletteController _controller;
  late RouletteGroup _group;

  bool _initialized = false;

  @override
  void initState() {
    super.initState();

    final room = Provider.of<RoomViewmodel>(
      context,
      listen: false,
    );

    if (room.Rolletchoice.isEmpty) {
      return;
    }

    _group = RouletteGroup.uniform(
      room.Rolletchoice.length,
      colorBuilder: (index) {
        return Colors.red.withAlpha(50);
      },
      textBuilder: room.Rolletchoice.elementAt,
      textStyleBuilder: (index) {
        return style1.copyWith(
          fontSize: 13,
        );
      },
    );

    _controller = RouletteController();

    _initialized = true;
  }

  @override
  Widget build(BuildContext context) {
    final room = Provider.of<RoomViewmodel>(
      context,
      listen: false,
    );

    if (!_initialized || room.Rolletchoice.isEmpty) {
      return Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
          image: DecorationImage(
            image: ExactAssetImage(
              Images.VipBackground,
            ),
            fit: BoxFit.fill,
          ),
        ),
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        image: DecorationImage(
          image: ExactAssetImage(
            Images.VipBackground,
          ),
          fit: BoxFit.fill,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,

        body: Center(
          child: MyRoulette(
            controller: _controller,
            group: _group,
          ),
        ),

        floatingActionButton: FloatingActionButton(
          backgroundColor: MainColor,

          onPressed: () async {
            if (room.Rolletchoice.isEmpty) {
              return;
            }

            final int index = _random.nextInt(
              room.Rolletchoice.length,
            );

            _controller.rollTo(
              index,
              clockwise: true,
              offset: _random.nextDouble(),
            );

            await Future.delayed(
              const Duration(seconds: 4),
            );

            if (!mounted) {
              return;
            }

            await room.Playrollet(
              context: context,
              name: room.Rolletchoice[index],
            );
          },

          child: Image.asset(
            Images.Rolletuser,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}