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
  Widget build(BuildContext context) => IgnorePointer(
        ignoring: !widget.reaction.enabled,
        child: Transform.scale(
          scale: SoundUtility.reactionId==widget.reaction.id?_scale:1,
          child: GestureDetector(
            onHorizontalDragStart: (DragStartDetails dragStartDetail){
              _scaleController.forward();
              //SoundUtility.playSound('icon_focus.mp3');
              setState(() {
                SoundUtility.reactionId=widget.reaction.id;
                _iconInFocus=true;
              });
            },
            onHorizontalDragUpdate: (DragUpdateDetails dragUpdateDetail){
              _scaleController.forward();
              //SoundUtility.playSound('icon_focus.mp3');

              setState(() {
                SoundUtility.reactionId=widget.reaction.id;
                _iconInFocus=true;
              });
            },
           onHorizontalDragCancel: (){
              _scaleController.reverse();
              setState(() {
                _iconInFocus=false;
                //_scale=1;
                SoundUtility.reactionId=0;
              });
            },
            onHorizontalDragEnd: (DragEndDetails dragEndDetail){
              _scaleController.reverse();
              setState(() {
                _iconInFocus=false;
                //_scale=1;
                SoundUtility.reactionId=0;
              });
            },
            onHorizontalDragDown: (DragDownDetails dragDownDetail){
              _scaleController.reverse();
              setState(() {
                _iconInFocus=false;
                //_scale=1;
                SoundUtility.reactionId=0;
              });
            },
            onTap: () {
              _scaleController.forward();
              setState(() {
                _iconInFocus=true;
              });
              widget.onReactionClick(widget.reaction);
            },

            /*onHover:(value){
              if(value) {
                _scaleController.forward();
                SoundUtility.playSound('icon_focus.mp3');
                setState(() {
                  _iconInFocus=true;
                });
              }
            },*/
           /* onFocusChange: (value){
              _scaleController.forward();
              SoundUtility.playSound('icon_focus.mp3');
              setState(() {
                _iconInFocus=true;
              });
            },*/

            onTapDown: (_) {
              setState(() {
                _iconInFocus=false;
              });
              _scaleController.reverse();
            },
            onTapCancel: () {
              setState(() {
                _iconInFocus=false;
              });
              _scaleController.reverse();
            },
            //splashColor: widget.splashColor,
            //highlightColor: widget.highlightColor,
            child:Container(
            child: Column(
                children: <Widget>[
            _iconInFocus && SoundUtility.reactionId==widget.reaction.id?
            Container(
              child:Material(
                  type: MaterialType.transparency,
              child: Text(
                  widget.reaction.reactionText,
                  style: TextStyle(fontSize: 8.0, color: Colors.white),
                  maxLines:1
              )),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0), color: Colors.black.withOpacity(0.3)),
              padding: EdgeInsets.only(left: 7.0, right: 7.0, top: 2.0, bottom: 2.0),
              margin: EdgeInsets.only(bottom: 8.0),
            ):Container(),
            widget.reaction.previewIcon,

             ]),
              //width: 40.0,
              //height:  _iconInFocus && SoundUtility.reactionId==widget.reaction.id ? 100.0 : 40.0,
                //push focus icon above
                margin: _iconInFocus && SoundUtility.reactionId==widget.reaction.id?EdgeInsets.only(bottom:35):EdgeInsets.only(bottom:0),
            ),

          ),
        ),
      );
}
