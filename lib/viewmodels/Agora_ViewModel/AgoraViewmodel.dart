import 'dart:async';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:ahlachat/util/Dialogs.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../util/app_constants.dart';
import '../Auth_Viewmodel/LoginViewModel.dart';
import '../Music_Viewmodel/MusicViewmodel.dart';
import '../Room_Viewmodel/Room_Viewmodel.dart';

class AgoraViewmodel extends ChangeNotifier {
  /// App ID on the Agora dashboard
  String APP_ID = '2d1320fdea0940e58ff09f630e47d9a8';

  bool muted = true;
  bool KickedFromChair = false;

  RtcEngine? _engine;

  List usersuid = [];

  bool Rebeate = false;

  void ChangeRepeate(state) {
    Rebeate = state;
    notifyListeners();
  }

  void updateKickedFromChair({value}) {
    KickedFromChair = value;
    notifyListeners();
  }

  Future<void> EndAgora() async {
    muted = true;

    await _engine?.leaveChannel();

    notifyListeners();
  }

  bool disableAudio = false;

  void disableAudioroomvoice() {
    disableAudio = false;
    playmusic = false;
    PlaySong.clear();

    notifyListeners();
  }

  Future<void> closeroomvoice() async {
    await _engine?.disableAudio();

    disableAudio = true;

    notifyListeners();
  }

  Future<void> enableroomvoice() async {
    await _engine?.enableAudio();

    disableAudio = false;

    notifyListeners();
  }

  var initialValue = 0.0;

  Future<void> initialize({
    ClientRoleType? role,
    required String Token,
    required String channelName,
  }) async {
    await _initAgoraRtcEngine(role: role);

    _addAgoraEventHandlers();

    await _engine?.joinChannel(
      token: Token,
      channelId: channelName,
      uid: int.parse(UserId!),
      options: ChannelMediaOptions(
        clientRoleType: role ?? ClientRoleType.clientRoleAudience,
        channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
      ),
    );

    notifyListeners();
  }

  Future<void> unmuteusermic(uid) async {
    await _engine?.muteRemoteAudioStream(
      uid: uid,
      mute: false,
    );

    notifyListeners();
  }

  Future<void> _initAgoraRtcEngine({
    ClientRoleType? role,
  }) async {
    _engine = createAgoraRtcEngine();

    await _engine?.initialize(
      const RtcEngineContext(
        appId: 'a8200d4d7e4a4dd589fd7e1c1e9fe0fc',
      ),
    );

    await _engine?.enableAudio();

    await _engine?.setChannelProfile(
      ChannelProfileType.channelProfileLiveBroadcasting,
    );

    if (role == ClientRoleType.clientRoleBroadcaster) {
      await _engine?.adjustRecordingSignalVolume(
        400,
      );

      muted = false;
    } else {
      muted = true;
    }

    await _engine?.enableAudioVolumeIndication(
      interval: 250,
      smooth: 3,
      reportVad: true,
    );

    if (role != null) {
      await _engine?.setClientRole(role: role);
    }

    notifyListeners();
  }

  bool playmusic = false;

  List PlaySong = [];

  int index = 0;

  Future<void> StartAudioMexing({
    required String filePath,
    required int duration,
    required String tittle,
    required int indexsong,
  }) async {
    PlaySong.clear();

    playmusic = true;
    index = indexsong;

    PlaySong.add(tittle);

    await _engine?.startAudioMixing(
      filePath: filePath,
      loopback: false,
      cycle: -1,
    );

    notifyListeners();
  }

  Future<void> next(context) async {
    MusicViewModel music =
    Provider.of<MusicViewModel>(context, listen: false);

    if (music.SongsList.length == index + 1) {
      Dialogs().showtoast('لا يوجد اغاني اخري');
    } else {
      PlaySong.clear();

      playmusic = true;

      PlaySong.add(
        music.SongsList[index + 1].displayName,
      );

      await _engine?.startAudioMixing(
        filePath: music.SongsList[index + 1].data,
        loopback: false,
        cycle: -1,
      );

      music.play(
        music.SongsList[index + 1].data,
      );

      index = index + 1;
    }

    notifyListeners();
  }

  Future<void> last(context) async {
    MusicViewModel music =
    Provider.of<MusicViewModel>(context, listen: false);

    print(index + 1);
    print(music.SongsList.length);

    if (index <= 0) {
      Dialogs().showtoast('لا يوجد اغاني سابقة');
    } else {
      PlaySong.clear();

      playmusic = true;

      PlaySong.add(
        music.SongsList[index - 1].displayName,
      );

      await _engine?.startAudioMixing(
        filePath: music.SongsList[index - 1].data,
        loopback: false,
        cycle: -1,
      );

      music.play(
        music.SongsList[index - 1].data,
      );

      index = index - 1;
    }

    notifyListeners();
  }

  int volumnaudio = 50;

  Future<void> setaudiovolum(int volum) async {
    volumnaudio = volum;

    await _engine?.adjustAudioMixingVolume(
      volum,
    );

    notifyListeners();
  }

  void volumnausdio(int volum) {
    volumnaudio = volum;

    notifyListeners();
  }

  Future<void> stopAudioMexing(context) async {
    playmusic = false;

    MusicViewModel music =
    Provider.of<MusicViewModel>(context, listen: false);

    await _engine?.pauseAudioMixing();

    music.player.pause();

    notifyListeners();
  }

  Future<void> resumAudioMexing(context) async {
    MusicViewModel music =
    Provider.of<MusicViewModel>(context, listen: false);

    playmusic = true;

    await _engine?.resumeAudioMixing();

    music.player.play();

    notifyListeners();
  }

  Future<void> muteusermic(uid) async {
    Dialogs().showtoast('uid');

    await _engine?.muteRemoteAudioStream(
      uid: uid,
      mute: true,
    );

    notifyListeners();
  }

  Future<void> xxxxx(uid) async {
    Dialogs().showtoast('uid');

    await _engine?.muteRemoteAudioStream(
      uid: uid,
      mute: true,
    );

    notifyListeners();
  }

  Future<void> pauseAudioMixing() async {
    await _engine?.pauseAudioMixing();

    notifyListeners();
  }

  Future<void> resumeAudioMixing() async {
    await _engine?.resumeAudioMixing();

    notifyListeners();
  }

  Future<void> setAudioMixingPosition(int duration) async {
    await _engine?.setAudioMixingPosition(
      duration,
    );

    notifyListeners();
  }

  Future<void> mutebyuid({
    required uid,
    required context,
  }) async {
    RoomViewmodel Room =
    Provider.of<RoomViewmodel>(context, listen: false);

    if (Room.Mutedids.contains(uid)) {
      Room.Mutedids.remove(uid);

      await _engine?.muteRemoteAudioStream(
        uid: uid,
        mute: false,
      );
    } else {
      Room.Mutedids.add(uid);

      await _engine?.muteRemoteAudioStream(
        uid: uid,
        mute: true,
      );
    }

    notifyListeners();
  }

  Future<void> SetasBroadcaster() async {
    muted = false;

    notifyListeners();

    await _engine?.setClientRole(
      role: ClientRoleType.clientRoleBroadcaster,
    );

    await _engine?.adjustRecordingSignalVolume(
      400,
    );
  }

  Future<void> SetasAudience() async {
    muted = true;

    notifyListeners();

    await _engine?.setClientRole(
      role: ClientRoleType.clientRoleAudience,
    );
  }

  Future<void> Mute() async {
    muted = true;

    await _engine?.adjustRecordingSignalVolume(
      0,
    );

    notifyListeners();
  }

  // Future<void> xxxxxxxx(uid) async {
  //   await _engine?.adjustUserPlaybackVolume(
  //     uid: uid,
  //     volume: 0,
  //   );
  //
  //   notifyListeners();
  // }

  Future<void> UnMute() async {
    muted = false;

    await SetasBroadcaster();

    await _engine?.adjustRecordingSignalVolume(
      400,
    );

    notifyListeners();
  }

  Future<void> keickedfromasAudience() async {
    muted = true;

    JoinChairs = false;
    KickedFromChair = false;

    await _engine?.setClientRole(
      role: ClientRoleType.clientRoleAudience,
    );

    notifyListeners();
  }

  int userjoindid = 0;

  List<Map> userjoin = [];

  int speakeruid = 0;

  List speakerids = [];

  List UserIDS = [];

  void _addAgoraEventHandlers() {
    _engine?.registerEventHandler(
      RtcEngineEventHandler(
        onError: (ErrorCodeType err, String msg) {
          print('onError: $err');
          print('message: $msg');
        },

        onJoinChannelSuccess: (
            RtcConnection connection,
            int elapsed,
            ) {
          userjoindid = connection.localUid ?? 0;

          print(
            'Joined channel: ${connection.channelId}',
          );

          notifyListeners();
        },

        onLeaveChannel: (
            RtcConnection connection,
            RtcStats stats,
            ) {
          print(
            'onLeaveChannel ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::',
          );
        },

        onUserJoined: (
            RtcConnection connection,
            int uid,
            int elapsed,
            ) {
          usersuid.add(uid);

          userjoin.add({
            'userid': userjoindid,
            'uid': uid,
          });

          notifyListeners();
        },

        onAudioVolumeIndication: (
            RtcConnection connection,
            List<AudioVolumeInfo> volumeInfo,
            int totalVolume,
            int totalRemoteVolume,
            ) {
          for (var speaker in volumeInfo) {
            if ((speaker.volume ?? 0) > 70) {
              if (speaker.uid != 0) {
                speakerids.add({
                  'uid': speaker.uid,
                  'time': DateTime.now(),
                });
              }

              print('x');

              for (var i in List.from(speakerids)) {
                if (DateTime.now()
                    .difference(i['time'])
                    .inSeconds >
                    2) {
                  speakerids.remove(i);

                  notifyListeners();

                  break;
                }
              }
            }
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    _engine?.leaveChannel();
    _engine?.release();

    super.dispose();
  }
}