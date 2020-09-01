import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_reaction_button/src/play_sound.dart';
import 'reactions_position.dart';
import 'reactions_box.dart';
import 'reaction.dart';
import 'extensions.dart';

class FlutterReactionButtonCheck extends StatefulWidget {
  /// This triggers when reaction button value changed.
  final Function(Reaction, bool) onReactionChanged;

  /// Default reaction button widget if [isChecked == false]
  final Reaction initialReaction;

  /// Default reaction button widget if [isChecked == true]
  final Reaction selectedReaction;

  final List<Reaction> reactions;

  final Color highlightColor;

  final Color splashColor;

  /// Position reactions box for the button [default = TOP]
  final Position boxPosition;

  /// Reactions box color [default = white]
  final Color boxColor;

  /// Reactions box elevation [default = 5]
  final double boxElevation;

  /// Reactions box radius [default = 50]
  final double boxRadius;

  /// Reactions box show/hide duration [default = 200 milliseconds]
  final Duration boxDuration;

  FlutterReactionButtonCheck({
    Key key,
    @required this.onReactionChanged,
    @required this.reactions,
    this.initialReaction,
    this.selectedReaction,
    this.highlightColor,
    this.splashColor,
    this.boxPosition = Position.TOP,
    this.boxColor = Colors.white,
    this.boxElevation = 5,
    this.boxRadius = 50,
    this.boxDuration = const Duration(milliseconds: 200),
  })  : assert(reactions != null),
        super(key: key);

  @override
  _FlutterReactionButtonCheckState createState() =>
      _FlutterReactionButtonCheckState();
}

class _FlutterReactionButtonCheckState
    extends State<FlutterReactionButtonCheck> {
  final GlobalKey _buttonKey = GlobalKey();

  final int _maxTick = 2;

  Timer _timer;

  Reaction _selectedReaction;

  bool _isChecked = false;

  _FlutterReactionButtonCheckState();

  @override
  void initState() {
    super.initState();
    _selectedReaction = widget.initialReaction;
  }

  @override
  Widget build(BuildContext context) => InkWell(
        key: _buttonKey,
        highlightColor: widget.highlightColor,
        splashColor: widget.splashColor,
        onTap: () {
          SoundUtility.playSound('short_press_like.mp3');
          _onClickReactionButton();
        },
        onLongPress: () {
          _onTapReactionButton(context);
        },
        child: Row(
            children: <Widget>[
              (_selectedReaction ?? widget.reactions[0]).icon,
                Text(" "+(_selectedReaction ?? widget.reactions[0]).reactionText)
           ],
      ));

  void _onTapReactionButton(BuildContext context) {
    _timer = Timer.periodic(Duration(milliseconds: 100), (timer) {
      if (_timer.tick >= _maxTick) {
        _showReactionButtons(context);
        _timer.cancel();
      }
      return _timer;
    });
  }

  void _onClickReactionButton() {
    _isChecked = !_isChecked;
    _updateReaction(
      _isChecked
          ? (widget.selectedReaction ?? widget.reactions[0])
          : widget.initialReaction,
    );
  }

  void _showReactionButtons(BuildContext context) async {
    final buttonOffset = _buttonKey.getButtonOffset();
    final buttonSize = _buttonKey.getButtonSize();
    SoundUtility.playSound('box_up.mp3');
    final reactionButton = await Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        transitionDuration: Duration(milliseconds: 200),
        pageBuilder: (context, _, __) => ReactionsBox(
          buttonOffset: buttonOffset,
          buttonSize: buttonSize,
          reactions: widget.reactions,
          position: widget.boxPosition,
          color: widget.boxColor,
          elevation: widget.boxElevation,
          radius: widget.boxRadius,
          duration: widget.boxDuration,
          highlightColor: widget.highlightColor,
          splashColor: widget.splashColor,
        ),
      ),
    );
    if (reactionButton != null) {
      _updateReaction(reactionButton, true);
    }
  }

  void _updateReaction(Reaction reaction, [bool isSelectedFromDialog = false]) {
    _isChecked = isSelectedFromDialog ? true : reaction != widget.initialReaction;
    widget.onReactionChanged(reaction, _isChecked);
    setState(() {
      _selectedReaction = reaction;
    });
  }


}
