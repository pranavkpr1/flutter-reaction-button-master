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
  Widget build(BuildContext context) {
    double _yStartBox=_getYPosition(context);
    double _xStartBox=_getXPosition();
    return GestureDetector(
      // Hide box when clicking out
      onTap: () {
        _scaleController.reverse();
        SoundUtility.playSound('box_down.mp3');
      },
      child: Container(
        height: double.infinity,
        color: Colors.transparent,
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Positioned(
              top: _yStartBox,
              left: _xStartBox,
              child: GestureDetector(
                  onHorizontalDragUpdate: (DragUpdateDetails dragUpdateDetail) {
                    //_scaleController.forward();

                    if (dragUpdateDetail.globalPosition.dy >=
                        _yStartBox &&
                        dragUpdateDetail.globalPosition.dy <=
                            _yStartBox+80) {
                      if (dragUpdateDetail.globalPosition.dx >=
                          _xStartBox -7 &&
                          dragUpdateDetail.globalPosition.dx <
                              _xStartBox + 40) {
                        //SoundUtility.playSound("icon_focus.mp3");
                        setState(() {
                          SoundUtility.reactionId = 1;
                        });
                      } else if (dragUpdateDetail.globalPosition.dx >=
                          _xStartBox + 40 &&
                          dragUpdateDetail.globalPosition.dx <
                              _xStartBox + 80) {
                        //SoundUtility.playSound("icon_focus.mp3");
                        setState(() {
                          SoundUtility.reactionId = 2;
                        });
                      }
                      else if (dragUpdateDetail.globalPosition.dx >=
                          _xStartBox + 80 &&
                          dragUpdateDetail.globalPosition.dx <
                              _xStartBox + 120) {
                        //SoundUtility.playSound("icon_focus.mp3");
                        setState(() {
                          SoundUtility.reactionId = 3;
                        });
                      }
                      else if (dragUpdateDetail.globalPosition.dx >=
                          _xStartBox + 120 &&
                          dragUpdateDetail.globalPosition.dx <
                              _xStartBox + 160) {
                        //SoundUtility.playSound("icon_focus.mp3");
                        setState(() {
                          SoundUtility.reactionId = 4;
                        });
                      }
                      else if (dragUpdateDetail.globalPosition.dx >=
                          _xStartBox + 160 &&
                          dragUpdateDetail.globalPosition.dx <
                              _xStartBox + 200) {
                       // SoundUtility.playSound("icon_focus.mp3");
                        setState(() {
                          SoundUtility.reactionId = 5;
                        });
                      }
                      else {
                        setState(() {
                          SoundUtility.reactionId = 0;
                        });
                      }
                    }
                  },
                  onHorizontalDragEnd: (DragEndDetails dragEndDetail) {

                    SoundUtility.playSound('icon_choose.mp3');

                    if (SoundUtility.reactionId==2)
                      SoundUtility.playSound('bell.mp3');

                    if(SoundUtility.reactionId>=1)
                    _selectedReaction = widget.reactions.elementAt(SoundUtility.reactionId-1);

                    _scaleController.reverse();

                    setState(() {
                      SoundUtility.reactionId = 0;
                    });
                  },

                  child: Stack(children: <Widget>[
                    Container(
                        height: 50,
                        width: 250,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(widget.radius),
                          border: Border.all(
                              color: Colors.grey[300], width: 0.3),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey,
                                blurRadius: 5.0,
                                // LTRB
                                offset: Offset.lerp(
                                    Offset(0.0, 0.0), Offset(0.0, 0.5), 10.0)),
                          ],
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(left: 0.0, right: 0.0),
                        )),
                    Container(
                      //height: 50,
                        width: 250,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: widget.reactions
                              .map(
                                (reaction) =>
                                ReactionsBoxItem(
                                  onReactionClick: (reaction) {
                                    SoundUtility.playSound('icon_choose.mp3');

                                    if (reaction.reactionSoundEffect)
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

                  ])
              ),
            ),
          ],
        ),
      ),
    );
  }

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

