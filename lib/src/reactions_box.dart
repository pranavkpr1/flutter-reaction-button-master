import 'package:flutter/material.dart';
import 'package:flutter_reaction_button/src/play_sound.dart';
import 'reactions_box_item.dart';
import 'reactions_position.dart';
import 'reaction.dart';
import 'extensions.dart';

class ReactionsBox extends StatefulWidget {
  final Offset buttonOffset;

  final Size buttonSize;

  final List<Reaction> reactions;

  final Position position;

  final Color color;

  final double elevation;

  final double radius;

  final Duration duration;

  final Color highlightColor;

  final Color splashColor;

  const ReactionsBox({
    @required this.buttonOffset,
    @required this.buttonSize,
    @required this.reactions,
    @required this.position,
    this.color = Colors.white,
    this.elevation = 5,
    this.radius = 50,
    this.duration = const Duration(milliseconds: 200),
    this.highlightColor,
    this.splashColor,
  })  : assert(buttonOffset != null),
        assert(buttonSize != null),
        assert(reactions != null),
        assert(position != null);

  @override
  _ReactionsBoxState createState() => _ReactionsBoxState();
}

class _ReactionsBoxState extends State<ReactionsBox>
    with TickerProviderStateMixin {
  AnimationController _scaleController;

  Animation<double> _scaleAnimation;

  double _scale = 0;

  Reaction _selectedReaction;

  @override
  void initState() {
    super.initState();

    _scaleController =
        AnimationController(vsync: this, duration: widget.duration);

    final Tween<double> startTween = Tween(begin: 0, end: 1);
    _scaleAnimation = startTween.animate(_scaleController)
      ..addListener(() {
        setState(() {
          _scale = _scaleAnimation.value;
        });
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.reverse)
          Navigator.of(context).pop(_selectedReaction);
      });

    _scaleController.forward();
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => GestureDetector(
        // Hide box when clicking out
        onTap: () {
          _scaleController.reverse();
        SoundUtility.playSound('box_down.mp3');},
        child: Container(
          height: double.infinity,
          color: Colors.transparent,
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Positioned(
                top: _getPosition(context),
                left:_getXPosition(),
                child: GestureDetector(
                  child: Transform.scale(
                    scale: _scale,
                    child: Card(
                      color: widget.color,
                      elevation: widget.elevation,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(widget.radius)),
                      child: Padding(
                        padding: EdgeInsets.only(left:8.0, right:8.0),

                      child: Wrap(
                        children: widget.reactions
                            .map(
                              (reaction) => ReactionsBoxItem(
                                onReactionClick: (reaction) {

                                  SoundUtility.playSound('icon_choose.mp3');

                                  if(reaction.reactionSoundEffect)
                                    SoundUtility.playSound('bell.mp3');

                                  _selectedReaction = reaction;
                                  _scaleController.reverse();
                                },
                                splashColor: widget.splashColor,
                                highlightColor: widget.highlightColor,
                                reaction: reaction,
                              ),
                            )
                            .toList(),
                      )),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );

  double _getXPosition() => widget.buttonOffset.dx+widget.buttonSize.width;

  double _getPosition(BuildContext context) =>
      (_getTopPosition() - widget.buttonSize.height * 2 < 0)
          ? _getBottomPosition()
          : (_getBottomPosition() + widget.buttonSize.height * 2 > context.getScreenSize().height)
              ? _getTopPosition()
              : widget.position == Position.TOP
                  ? _getTopPosition()
                  : _getBottomPosition();

  double _getTopPosition() =>
      widget.buttonOffset.dy - widget.buttonSize.height ;

  double _getBottomPosition() =>
      widget.buttonOffset.dy + widget.buttonSize.height;
}
