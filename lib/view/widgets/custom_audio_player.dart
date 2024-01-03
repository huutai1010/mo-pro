import 'package:audioplayers/audioplayers.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:etravel_mobile/const/const.dart';
import 'package:etravel_mobile/view/widgets/custom_confirm_dialog.dart';
import 'package:etravel_mobile/view_model/tourtracking_viewmodel.dart';
import 'package:flutter/material.dart';
import '../../view_model/audio_viewmodel.dart';
import '../../res/colors/app_color.dart';
import 'custom_yes_no_dialog.dart';

class CustomAudioPlayer extends StatefulWidget {
  final int indexPlace;
  final TourTrackingViewModel tourTrackingViewModel;
  final AudioViewModel audioVm;
  final int bookingPlaceId;
  final bool checkInNeeded;
  final Function(DateTime) onCheckRefresh;
  const CustomAudioPlayer({
    super.key,
    required this.indexPlace,
    required this.tourTrackingViewModel,
    required this.bookingPlaceId,
    required this.audioVm,
    required this.checkInNeeded,
    required this.onCheckRefresh,
  });

  @override
  State<CustomAudioPlayer> createState() => _CustomAudioPlayerState();
}

class _CustomAudioPlayerState extends State<CustomAudioPlayer> {
  bool _checkInNeeded = true;

  void _seek({bool isForward = true}) async {
    final audioVm = widget.audioVm;
    if (!audioVm.canPlay) {
      return;
    }
    var seekSliderValue = audioVm.sliderValue + kSeekTimeInMilliseconds;
    if (!isForward) {
      seekSliderValue = audioVm.sliderValue - kSeekTimeInMilliseconds;
      if (audioVm.sliderValue <= kSeekTimeInMilliseconds) {
        seekSliderValue = 0.0;
      }
    }
    await audioVm.seek(seekSliderValue);
  }

  _onPlayAudio(BuildContext context) async {
    if (!widget.audioVm.canPlay) {
      showDialog(
        context: context,
        builder: (ctx) {
          return CustomConfirmDialog(
            yesContent: 'OK',
            title: ctx.tr('voice_file_error'),
            content: ctx.tr('voice_file_error_content'),
            icon: const Icon(
              Icons.warning,
              color: AppColors.primaryColor,
              size: 70,
            ),
            onYes: () {
              Navigator.of(context).pop();
            },
          );
        },
      );
      return;
    }
    if (!_checkInNeeded) {
      await widget.audioVm.togglePlay();
    } else {
      final willExpireDateTime = DateFormat(kDateTimeFormat).format(
        DateTime.now()
            .add(
              const Duration(days: 7),
            )
            .toLocal(),
      );
      showDialog<bool>(
        context: context,
        builder: (context) {
          return CustomYesNoDialog(
            yesContent: context.tr('yes'),
            noContent: context.tr('no'),
            onYes: () {
              Navigator.of(context).pop(true);
            },
            onNo: () {
              Navigator.of(context).pop(false);
            },
            content:
                '${context.tr('confirm_enable_voice_file')} $willExpireDateTime',
            title: context.tr('confirmation'),
            icon: const Icon(
              Icons.task_alt,
              color: AppColors.primaryColor,
              size: 70,
            ),
          );
        },
      ).then((isConfirmed) {
        if (isConfirmed == null) {
          return;
        }
        if (isConfirmed) {
          widget.tourTrackingViewModel
              .checkInPlace(widget.bookingPlaceId, widget.indexPlace, context)
              .then((value) {
            widget.onCheckRefresh(DateTime.parse(value['startTime']));
            setState(() {
              _checkInNeeded = false;
            });
            widget.audioVm.togglePlay();
          });
        }
      });
    }
  }

  @override
  void initState() {
    _checkInNeeded = widget.checkInNeeded;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              overlayShape: SliderComponentShape.noOverlay,
            ),
            child: Slider(
              min: 0,
              max: widget.audioVm.isLoading ? 0 : widget.audioVm.max,
              inactiveColor: AppColors.gray5,
              value: widget.audioVm.sliderValue,
              onChanged: widget.audioVm.seek,
            ),
          ),
          const SizedBox(
            height: 2,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(widget.audioVm.sliderDurationInString),
                Text('-${widget.audioVm.durationLeftInString}'),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(
                  Icons.skip_previous,
                ),
                color: AppColors.primaryColor,
                disabledColor: AppColors.gray5,
                iconSize: 50,
                onPressed: widget.audioVm.playerState == PlayerState.disposed
                    ? null
                    : () => _seek(isForward: false),
              ),
              IconButton(
                icon: Icon(
                  widget.audioVm.isPlaying
                      ? Icons.pause_circle
                      : Icons.play_circle,
                ),
                color: AppColors.primaryColor,
                disabledColor: AppColors.gray5,
                iconSize: 75,
                onPressed: widget.audioVm.playerState == PlayerState.disposed
                    ? null
                    : widget.audioVm.isPlaying
                        ? widget.audioVm.togglePlay
                        : () => _onPlayAudio(context),
              ),
              IconButton(
                color: AppColors.primaryColor,
                disabledColor: AppColors.gray5,
                icon: const Icon(
                  Icons.skip_next,
                ),
                iconSize: 50,
                onPressed: widget.audioVm.playerState == PlayerState.disposed
                    ? null
                    : () => _seek(isForward: true),
              ),
            ],
          )
        ],
      ),
    );
  }
}
