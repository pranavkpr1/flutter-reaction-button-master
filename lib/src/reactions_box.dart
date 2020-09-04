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
                top: _getYPosition(context),
                left:_getXPosition(),
                child: GestureDetector(
                  child: Stack(children: <Widget>[
                    Container(
                      height: 50,
                      width:300,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(widget.radius),
                        border: Border.all(color: Colors.grey[300], width: 0.3),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.grey,
                              blurRadius: 5.0,
                              // LTRB
                              offset: Offset.lerp(Offset(0.0, 0.0), Offset(0.0, 0.5), 10.0)),
                        ],
                      ),
                      child: Padding(
                          padding: EdgeInsets.only(left:8.0, right:8.0),
                      )),
                    Container(
                        height: 120,
                        width:300,
                           child:Row(
                              children:widget.reactions
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
                          )
                    )

                   /* Transform.scale(
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
                      )
                      ),
                    ),
                  ),*/
                    //SizedBox(height:14)
                  ])
                ),
              ),
            ],
          ),
        ),
      );

  double _getXPosition() => widget.buttonOffset.dx+widget.buttonSize.width-20;

  double _getYPosition(BuildContext context) =>
      (_getTopPosition() - widget.buttonSize.height * 3 < 0)
          ? _getBottomPosition()
          : (_getBottomPosition() + widget.buttonSize.height * 2 > context.getScreenSize().height)
              ? _getTopPosition()
              : widget.position == Position.TOP
                  ? _getTopPosition()
                  : _getBottomPosition();

  double _getTopPosition() =>
      widget.buttonOffset.dy- widget.buttonSize.height;

  double _getBottomPosition() =>
      widget.buttonOffset.dy + widget.buttonSize.height;
}
