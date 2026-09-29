import 'dart:async';

import 'package:ahlachat/main.dart';
import 'package:ahlachat/util/Dialogs.dart';
import 'package:ahlachat/util/Localization.dart';
import 'package:ahlachat/viewmodels/Agora_ViewModel/AgoraViewmodel.dart';
import 'package:ahlachat/viewmodels/Socket_ViewModel/Socketviewmodel.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ahlachat/util/styles.dart';

import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';

import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Repositores/Music_repositores/Musicapi.dart';
import '../Auth_Viewmodel/LoginViewModel.dart';

class DurationState {
  DurationState({
    this.position = Duration.zero,
    this.total = Duration.zero,
  });

  Duration position;
  Duration total;
}

class MusicViewModel extends ChangeNotifier {
  // ============================================================
  // AUDIO
  // ============================================================

  final OnAudioQuery audioQuery = OnAudioQuery();
  final AudioPlayer player = AudioPlayer();

  bool playerorno = false;

  List<SongModel> songs = [];
  List<SongModel> SongsList = [];

  List<SongModel> searchResult = [];
  List<SongModel> SelectedMusic = [];

  StreamSubscription<PlayerState>? _playerStateSubscription;
  StreamSubscription<int?>? _currentIndexSubscription;

  bool _isInitializingSongs = false;

  // ============================================================
  // SELECT MUSIC
  // ============================================================

  Future<void> SelectMusic(SongModel val) async {
    if (!SongsList.contains(val)) {
      SongsList.add(val);
    }

    final SharedPreferences prefs =
    await SharedPreferences.getInstance();

    final List<String>? savedSongs =
    prefs.getStringList('Songs');

    if (savedSongs != null) {
      if (!savedSongs.contains(val.displayName)) {
        savedSongs.add(val.displayName);
      }

      await prefs.setStringList('Songs', savedSongs);
    } else {
      await prefs.setStringList(
        'Songs',
        [val.displayName],
      );
    }

    notifyListeners();
  }

  Future<void> UnSelectMusic(SongModel val) async {
    SongsList.remove(val);

    final SharedPreferences prefs =
    await SharedPreferences.getInstance();

    final List<String>? savedSongs =
    prefs.getStringList('Songs');

    if (savedSongs != null) {
      savedSongs.remove(val.displayName);

      await prefs.setStringList(
        'Songs',
        savedSongs,
      );
    }

    notifyListeners();
  }

  // ============================================================
  // ADD MUSIC
  // ============================================================

  bool loading = false;

  Future<void> AddNewMusic({
    BuildContext? context,
  }) async {
    if (context == null) {
      print('❌ AddNewMusic: context is null');
      return;
    }

    if (SelectedMusic.isEmpty) {
      print('❌ AddNewMusic: SelectedMusic is empty');
      return;
    }

    final LoginViewmodel user =
    Provider.of<LoginViewmodel>(
      context,
      listen: false,
    );

    loading = true;
    notifyListeners();

    try {
      final value = await Musicapi().AddMusic(
        context: context,
        Music: SelectedMusic.first,
      );

      loading = false;

      if (value.name != null) {
        Dialogs().showtoast(
          getLang(
            context: NavigationService
                .navigatorKey
                .currentContext,
            key: "Done_Succ",
          ),
        );

        SelectedMusic.clear();
      }
    } catch (e, stackTrace) {
      loading = false;

      print('❌ AddNewMusic Error: $e');
      print(stackTrace);
    }

    notifyListeners();
  }

  // ============================================================
  // SELECT MUSIC FILE
  // ============================================================

  void SelectMusicFile(dynamic value) {
    SelectedMusic.clear();

    if (value != null) {
      SelectedMusic.add(value);
    }

    notifyListeners();
  }

  // ============================================================
  // ADD SONGS
  // ============================================================

  void addsongs() {
    searchResult = List<SongModel>.from(SelectedMusic);

    notifyListeners();
  }

  // ============================================================
  // SEARCH
  // ============================================================

  TextEditingController NameController =
  TextEditingController();

  void Filtercity(String enteredKeyword) {
    print(enteredKeyword);

    if (enteredKeyword.isEmpty) {
      searchResult =
      List<SongModel>.from(SelectedMusic);

      notifyListeners();
      return;
    }

    searchResult = SelectedMusic.where(
          (user) => user.title
          .toLowerCase()
          .contains(
        enteredKeyword.toLowerCase(),
      ),
    ).toList();

    notifyListeners();
  }

  // ============================================================
  // CURRENT SONG
  // ============================================================

  int index = 0;

  String currentSongTitle = '';

  int currentIndex = 0;

  var songslost;

  var Crunnetdata;

  // ============================================================
  // PAUSE
  // ============================================================

  Future<void> pause() async {
    try {
      await player.stop();

      playerorno = false;

      notifyListeners();
    } catch (e) {
      print('❌ Pause Error: $e');
    }
  }

  // ============================================================
  // PLAY
  // ============================================================

  Future<void> play(dynamic url) async {
    try {
      if (url == null || url.toString().isEmpty) {
        print('❌ Play: URL is empty');
        return;
      }

      final AgoraViewmodel agora =
      Provider.of<AgoraViewmodel>(
        roomcontext,
        listen: false,
      );

      print('🎵 Playing: $url');

      // Stop previous listener
      await _playerStateSubscription?.cancel();

      // Pause current audio
      await player.pause();

      // Set audio
      await player.setFilePath(
        url.toString(),
      );

      // Keep original behavior
      await player.setVolume(0);

      // Start audio
      await player.play();

      playerorno = true;

      // Only one listener
      _playerStateSubscription =
          player.playerStateStream.listen(
                (event) async {
              try {
                if (event.processingState ==
                    ProcessingState.completed) {
                  print('🎵 Song completed');

                  if (SongsList.isEmpty) {
                    print(
                      '❌ SongsList is empty',
                    );
                    return;
                  }

                  if (agora.Rebeate == false) {
                    final currentAgoraIndex =
                        agora.index;

                    if (currentAgoraIndex < 0 ||
                        currentAgoraIndex >=
                            SongsList.length) {
                      print(
                        '❌ Invalid Agora index: '
                            '$currentAgoraIndex',
                      );
                      return;
                    }

                    final song =
                    SongsList[currentAgoraIndex];

                    await agora.StartAudioMexing(
                      filePath: song.data,
                      duration: song.duration!,
                      tittle: song.displayName,
                      indexsong: currentAgoraIndex,
                    );

                    notifyListeners();
                  } else {
                    final nextIndex =
                        agora.index + 1;

                    if (nextIndex < 0 ||
                        nextIndex >=
                            SongsList.length) {
                      print(
                        '🎵 No next song. '
                            'Reached end of playlist.',
                      );
                      return;
                    }

                    final song =
                    SongsList[nextIndex];

                    await agora.StartAudioMexing(
                      filePath: song.data,
                      duration: song.duration!,
                      tittle: song.displayName,
                      indexsong: nextIndex,
                    );

                    notifyListeners();
                  }
                }
              } catch (e, stackTrace) {
                print(
                  '❌ Player Listener Error: $e',
                );
                print(stackTrace);
              }
            },
          );

      notifyListeners();
    } catch (e, stackTrace) {
      print('❌ Play Error: $e');
      print(stackTrace);

      playerorno = false;

      notifyListeners();
    }
  }

  // ============================================================
  // SET INDEX
  // ============================================================

  void setindex({
    required dynamic value,
    required dynamic data,
  }) {
    Crunnetdata = data;
    index = value;

    notifyListeners();
  }

  // ============================================================
  // GET ALL MUSIC
  // ============================================================

  Future<List<SongModel>> GetAllMusic() async {
    try {
      if (kIsWeb) {
        print(
          '🌐 GetAllMusic: Web platform',
        );

        return [];
      }

      // Check permission
      bool permissionStatus =
      await audioQuery.permissionsStatus();

      print(
        '🎵 Current Audio Permission: '
            '$permissionStatus',
      );

      // Request permission if needed
      if (!permissionStatus) {
        print(
          '🎵 Requesting Audio Permission...',
        );

        final bool requested =
        await audioQuery.permissionsRequest();

        print(
          '🎵 Permission Request Result: '
              '$requested',
        );

        if (!requested) {
          print(
            '❌ Audio permission denied',
          );

          return [];
        }

        permissionStatus = true;
      }

      if (!permissionStatus) {
        print(
          '❌ No audio permission',
        );

        return [];
      }

      // Query songs only after permission
      final List<SongModel> songList =
      await audioQuery.querySongs(
        orderType: OrderType.ASC_OR_SMALLER,
        uriType: UriType.EXTERNAL,
        ignoreCase: true,
        sortType: SongSortType.TITLE,
      );

      print(
        '✅ Songs Loaded: ${songList.length}',
      );

      return songList;
    } catch (e, stackTrace) {
      print(
        '❌ GetAllMusic Error: $e',
      );

      print(stackTrace);

      return [];
    }
  }

  // ============================================================
  // INITIALIZE SONGS
  // ============================================================

  Future<void> Initsong() async {
    // Prevent multiple calls at the same time
    if (_isInitializingSongs) {
      print(
        '⚠️ Initsong already running',
      );

      return;
    }

    _isInitializingSongs = true;

    try {
      final SharedPreferences prefs =
      await SharedPreferences.getInstance();

      final List<String>? savedSongs =
      prefs.getStringList('Songs');

      print(
        'Saved Songs: $savedSongs',
      );

      print(
        'SongsSongsSongsSongsSongsSongsSongsSongsSongsSongs',
      );

      // Cancel previous current index listener
      await _currentIndexSubscription?.cancel();

      // Listen only once
      _currentIndexSubscription =
          player.currentIndexStream.listen(
                (index) {
              if (index != null &&
                  index >= 0 &&
                  index < SongsList.length) {
                _updateCurrentPlayingSongDetails(
                  index,
                );
              }
            },
          );

      // Get all device music
      final List<SongModel> musicList =
      await GetAllMusic();

      SelectedMusic =
      List<SongModel>.from(musicList);

      print(
        'SelectedMusic count: '
            '${SelectedMusic.length}',
      );

      // Restore selected songs
      SongsList.clear();

      if (savedSongs != null &&
          savedSongs.isNotEmpty) {
        for (final element in SelectedMusic) {
          if (savedSongs.contains(
            element.displayName,
          )) {
            SongsList.add(element);
          }
        }
      }

      print(
        'SongsList count: '
            '${SongsList.length}',
      );

      notifyListeners();
    } catch (e, stackTrace) {
      print(
        '❌ Initsong Error: $e',
      );

      print(stackTrace);

      SelectedMusic.clear();
      SongsList.clear();

      notifyListeners();
    } finally {
      _isInitializingSongs = false;
    }
  }

  // ============================================================
  // TOAST
  // ============================================================

  void toast(
      BuildContext context,
      String text,
      ) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius:
          BorderRadius.circular(50.0),
        ),
      ),
    );
  }

  // ============================================================
  // REQUEST STORAGE PERMISSION
  // ============================================================

  Future<void> requestStoragePermission() async {
    try {
      if (kIsWeb) {
        return;
      }

      bool permissionStatus =
      await audioQuery.permissionsStatus();

      print(
        '🎵 Current Permission: '
            '$permissionStatus',
      );

      if (!permissionStatus) {
        permissionStatus =
        await audioQuery.permissionsRequest();

        print(
          '🎵 Permission Result: '
              '$permissionStatus',
        );
      }

      if (!permissionStatus) {
        print(
          '❌ User denied music permission',
        );
      } else {
        print(
          '✅ Music permission granted',
        );
      }

      notifyListeners();
    } catch (e, stackTrace) {
      print(
        '❌ Permission Error: $e',
      );

      print(stackTrace);
    }
  }

  // ============================================================
  // CREATE PLAYLIST
  // ============================================================

  ConcatenatingAudioSource createPlaylist(
      List<SongModel> songs,
      ) {
    final List<AudioSource> sources = [];

    for (final song in songs) {
      if (song.uri != null &&
          song.uri!.isNotEmpty) {
        sources.add(
          AudioSource.uri(
            Uri.parse(song.uri!),
          ),
        );
      }
    }

    return ConcatenatingAudioSource(
      children: sources,
    );
  }

  // ============================================================
  // BACKGROUND COLOR
  // ============================================================

  Color bgColor = Colors.brown;

  // ============================================================
  // DECORATION
  // ============================================================

  BoxDecoration getDecoration(
      BoxShape shape,
      Offset offset,
      double blurRadius,
      double spreadRadius,
      ) {
    return BoxDecoration(
      color: bgColor,
      shape: shape,
      boxShadow: [
        BoxShadow(
          offset: -offset,
          color: whitecolor4,
          blurRadius: blurRadius,
          spreadRadius: spreadRadius,
        ),
        BoxShadow(
          offset: offset,
          color: Colors.black,
          blurRadius: blurRadius,
          spreadRadius: spreadRadius,
        ),
      ],
    );
  }

  BoxDecoration getRectDecoration(
      BorderRadius borderRadius,
      Offset offset,
      double blurRadius,
      double spreadRadius,
      ) {
    return BoxDecoration(
      borderRadius: borderRadius,
      color: bgColor,
      boxShadow: [
        BoxShadow(
          offset: -offset,
          color: whitecolor4,
          blurRadius: blurRadius,
          spreadRadius: spreadRadius,
        ),
        BoxShadow(
          offset: offset,
          color: Colors.black,
          blurRadius: blurRadius,
          spreadRadius: spreadRadius,
        ),
      ],
    );
  }

  // ============================================================
  // UPDATE CURRENT PLAYING SONG
  // ============================================================

  void _updateCurrentPlayingSongDetails(
      int index,
      ) {
    if (SongsList.isEmpty) {
      return;
    }

    if (index < 0 ||
        index >= SongsList.length) {
      print(
        '❌ Invalid song index: $index',
      );

      return;
    }

    currentSongTitle =
        SongsList[index].displayName;

    currentIndex = index;

    notifyListeners();
  }

  // ============================================================
  // DURATION STREAM
  // ============================================================

  Stream<DurationState>
  get durationStateStream =>
      Rx.combineLatest2<
          Duration,
          Duration?,
          DurationState>(
        player.positionStream,
        player.durationStream,
            (
            position,
            duration,
            ) =>
            DurationState(
              position: position,
              total:
              duration ?? Duration.zero,
            ),
      );

  // ============================================================
  // SEEK
  // ============================================================

  Future<void> seekToSec(int sec) async {
    final Duration newPos =
    Duration(seconds: sec);

    try {
      await player.seek(newPos);
    } catch (e) {
      print(
        '❌ Seek Error: $e',
      );
    }
  }

  // ============================================================
  // DISPOSE
  // ============================================================

  @override
  void dispose() {
    print(
      '🗑️ MusicViewModel dispose',
    );

    _playerStateSubscription?.cancel();
    _currentIndexSubscription?.cancel();

    NameController.dispose();

    player.dispose();

    super.dispose();
  }
}