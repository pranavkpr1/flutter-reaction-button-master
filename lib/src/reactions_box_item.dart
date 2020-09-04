import 'package:flutter/material.dart';
import 'package:flutter_reaction_button/src/play_sound.dart';
import '../flutter_reaction_button.dart';

class ReactionsBoxItem extends StatefulWidget {
  final Function(Reaction) onReactionClick;

  final Reaction reaction;

  final Color highlightColor;

  final Color splashColor;

  const ReactionsBoxItem({
    Key key,
    @required this.reaction,
    @required this.onReactionClick,
    this.highlightColor,
    this.splashColor,
  }) : super(key: key);

  @override
  _ReactionsBoxItemState createState() => _ReactionsBoxItemState();
}

class _ReactionsBoxItemState extends State<ReactionsBoxItem>
    with TickerProviderStateMixin {
  AnimationController _scaleController;

  Animation<double> _scaleAnimation;

  double _scale = 1;
  bool _iconInFocus=false;

  @override
  void initState() {
    super.initState();

    // Start animation
    _scaleController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 100));

    final Tween<double> startTween = Tween(begin: 1, end: 1.8);
    _scaleAnimation = startTween.animate(_scaleController)
      ..addListener(() {
        setState(() {
          _scale = _scaleAnimation.value;
        });
      });
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if(SoundUtility.reactionId == widget.reaction.id)
    _scaleController.forward();

    return IgnorePointer(
      ignoring: !widget.reaction.enabled,
      child: Transform.scale(
        scale: SoundUtility.reactionId == widget.reaction.id ? _scale : 1,
        child: GestureDetector(

          onTap: () {
            _scaleController.reverse();
            widget.onReactionClick(widget.reaction);
            setState(() {
              SoundUtility.reactionId = 0;
            });
          },

          onTapDown: (_) {
            setState(() {
              SoundUtility.reactionId = 0;
            });
            _scaleController.reverse();
          },
          onTapCancel: () {
            setState(() {
              SoundUtility.reactionId = 0;
            });
            _scaleController.reverse();
          },
          //splashColor: widget.splashColor,
          //highlightColor: widget.highlightColor,
          child: Container(
            child: Column(
                children: <Widget>[
                  SoundUtility.reactionId == widget.reaction.id ?
                  Container(
                    child: Material(
                        type: MaterialType.transparency,
                        child: Text(
                            widget.reaction.reactionText,
                            style: TextStyle(
                                fontSize: 8.0, color: Colors.white),
                            maxLines: 1
                        )),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: Colors.black.withOpacity(0.3)),
                    padding: EdgeInsets.only(
                        left: 7.0, right: 7.0, top: 2.0, bottom: 2.0),
                    margin: EdgeInsets.only(bottom: 8.0),
                  ) : Container(),
                  widget.reaction.previewIcon,

                ]),
            width: 40.0,
            //height:  _iconInFocus && SoundUtility.reactionId==widget.reaction.id ? 100.0 : 40.0,
            //push focus icon above
            padding: SoundUtility.reactionId == widget.reaction.id ? EdgeInsets.only(bottom: 80) : (SoundUtility.reactionId ==0?EdgeInsets.only(bottom: 0):EdgeInsets.only(bottom: 94)),
          ),

        ),
      ),
    );
  }
}
