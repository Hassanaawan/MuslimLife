import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../constants/colors_constants.dart';
import '../../constants/images_constants.dart';
import '../../models/al_quran_surah/full_surah_details_model.dart';
import '../../viewmodel/surah_details_controller.dart';
import '../widgets/loading_dialog_widget.dart';
import '../widgets/app_background_widget.dart';
import '../widgets/app_bar_widget.dart';
import '../widgets/first_surah_ayat_card.dart';
import '../widgets/second_surah_ayah_card.dart';

class QuranDetailsScreen extends StatefulWidget {
  const QuranDetailsScreen({
    Key? key,
    required this.surahName,
    required this.surahNumber,
  }) : super(key: key);

  final String surahName;
  final int surahNumber;

  @override
  State<QuranDetailsScreen> createState() => _QuranDetailsScreenState();
}

class _QuranDetailsScreenState extends State<QuranDetailsScreen> {
  int selectedCardIndex = -1;
  final AudioPlayer _audioPlayer = AudioPlayer();
  int _currentIndex = 0;
  bool _isAudioPlaying = false;
  List<String> surahUrlsList = [];

  // Play audio method

  void _initAudioPlayer() {
    _audioPlayer.onPlayerComplete.listen((event) {
      setState(() {
        _isAudioPlaying = false;
        if (_currentIndex < surahUrlsList.length - 1) {
          _currentIndex++;
          _playAudio(surahUrlsList[_currentIndex]);
        }
      });
    });
  }

  /// Audio play method
  Future<void> _playAudio(String url) async {
    await _audioPlayer.play(UrlSource(url));
    setState(() {
      _isAudioPlaying = true;

    });
  }

  /// Audio pause method
  Future<void> _pauseAudio() async {
    await _audioPlayer.pause();
    setState(() {
      _isAudioPlaying = false;
    });
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await Get.find<SurahDetailsController>()
          .getFullSurahDetails(widget.surahNumber);
    });
    super.initState();
    // Play audio method
    _initAudioPlayer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          AppBackgroundWidget(
            bgImagePath: AppImages.backgroundSolidColorSVG,
          ),
          AppBarWidget(
            screenTitle: widget.surahName,
          ),
          GetBuilder<SurahDetailsController>(
            builder: (fullSurahDetailsController) {
              if (fullSurahDetailsController.fullSurahFetchInProgress) {
                return const LoadingDialogWidget();
              }
              final List<Verses> versesDataList =
                  fullSurahDetailsController.versesList!;
              surahUrlsList.clear();
              for (int i = 0; i < versesDataList.length; i++) {
                surahUrlsList.add(versesDataList[i].audio!.primary!);
              }
              return Padding(
                padding: const EdgeInsets.only(top: 97),
                child: ListView.separated(
                  padding: const EdgeInsets.only(top: 0),
                  itemCount: versesDataList.length,
                  itemBuilder: (context, index) {
                    final verse = versesDataList[index];
                    if (index == 0) {
                      return FirstSurahAyahCard(
                        arabic: verse.text?.arab ?? '',
                        english: verse.translation?.en ?? '',
                        surahName: widget.surahName,
                        onIconTap: () {
                          if (selectedCardIndex == -1) {
                            if (_isAudioPlaying) {
                              _pauseAudio();
                            } else {
                              _playAudio(surahUrlsList[_currentIndex]);
                            }
                          }
                        },
                        isAudioPlaying: _isAudioPlaying,
                      );
                    } else {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedCardIndex =
                                selectedCardIndex == index ? -1 : index;
                            _currentIndex = selectedCardIndex;
                            _pauseAudio();
                            if (selectedCardIndex == -1) {
                              _currentIndex = 0;
                            }
                          });
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.h),
                          child: Container(
                            padding: EdgeInsets.zero,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: selectedCardIndex == index
                                    ? AppColors.colorWarning
                                    : Colors.transparent,
                                width: selectedCardIndex == index ? 1 : 0,
                              ),
                              borderRadius: BorderRadius.circular(24),
                            ),
                            child: SecondSurahAyahCard(
                              surahEnglish: verse.translation?.en ?? '',
                              surahArabic: verse.text?.arab ?? '',
                            ),
                          ),
                        ),
                      );
                    }
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return const SizedBox(
                      height: 8,
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
      floatingActionButton: selectedCardIndex != -1
          ? FloatingActionButton(
        backgroundColor: AppColors.colorWhiteHighEmp,
              onPressed: () {
                setState(() {
                  if (_isAudioPlaying) {
                    _pauseAudio();
                  } else {
                    _playAudio(surahUrlsList[_currentIndex]);
                  }
                });
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50),
              ),
              child: Icon(
                _isAudioPlaying ? Icons.pause : Icons.play_arrow,
                color: AppColors.colorPrimary,
              ),
            )
          : null,
    );
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }
}
