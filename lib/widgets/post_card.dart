import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone1/model/user.dart' as model;
import 'package:instagram_clone1/provider/user_provider.dart';
import 'package:instagram_clone1/resources/firestore_method.dart';
import 'package:instagram_clone1/screens/comment_screen.dart';
import 'package:instagram_clone1/utils/snackbar.dart';
import 'package:instagram_clone1/widgets/like_animtion.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:zoom_pinch_overlay/zoom_pinch_overlay.dart';

class PostCard extends StatefulWidget {
  final snap;
  const PostCard({super.key, required this.snap});

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool isAnimating = false;
  int numberOfComments = 0;

  @override
  void initState() {
    super.initState();
    getComments();
  }

  void getComments() async {
    // StreamBuilder(
    //   stream: FirebaseFirestore.instance
    //       .collection('posts')
    //       .doc(widget.snap['postId'])
    //       .collection('comments')
    //       .snapshots(),
    //   builder: (context, snapshot) {
    //     if (snapshot.hasData) {
    //       numberOfComments = snapshot.data!.docs.length;
    //       print(numberOfComments);
    //     }
    //     return const CircularProgressIndicator();
    //   },
    // );

    final QuerySnapshot snap = await FirebaseFirestore.instance
        .collection('posts')
        .doc(widget.snap['postId'])
        .collection('comments')
        .get();

    numberOfComments = snap.docs.length;
    // print(numberOfComments);
  }

  @override
  Widget build(BuildContext context) {
    final model.User user = Provider.of<UserProvider>(context).getUser;
  
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 1),
      child: Column(children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16)
              .copyWith(right: 0),
          color: Colors.white,
          //headerbar
          child: Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage(widget.snap['profileImage']),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.snap['username'],
                        style: const TextStyle(fontSize: 15),
                      ),
                    ],
                  ),
                ),
              ),
              IconButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) => Dialog(
                              // backgroundColor: Colors.white10,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16)),
                              elevation: 0,
                              child: ListView(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                shrinkWrap: true,
                                children: ["Delete", "edit"]
                                    .map((e) => InkWell(
                                          onTap: () async {
                                            String res =
                                                await FireStoreMethods()
                                                    .deletePost(
                                                        widget.snap['postId']);
                                            showSnackBar(res, context);
                                            Navigator.pop(context);
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 12, horizontal: 16),
                                            child: Center(child: Text(e)),
                                          ),
                                        ))
                                    .toList(),
                              ),
                            ));
                  },
                  icon: const Icon(
                    Icons.more_vert,
                  ))
            ],
          ),
        ),
        GestureDetector(
          onDoubleTap: () async {
            FireStoreMethods().likePost(widget.snap['postId'],
                user.uid, widget.snap['likes']);
            setState(() {
              isAnimating = true;
            });
          },
          child: ZoomOverlay(
            modalBarrierColor: Colors.black12, // optional
            minScale: 0.5, // optional
            maxScale: 3.0, // optional
            twoTouchOnly: true,
            animationDuration: const Duration(milliseconds: 300),
            animationCurve: Curves.fastOutSlowIn,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.45,
                  child: Image(
                    image: NetworkImage(widget.snap['postURL']),
                    fit: BoxFit.cover,
                  ),
                ),
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 200),
                  opacity: isAnimating ? 1 : 0,
                  child: LikeAnimation(
                    child: const Icon(
                      Icons.favorite,
                      color: Color.fromRGBO(255, 255, 255, 1),
                      size: 130,
                    ),
                    isAnimating: isAnimating,
                    duration: const Duration(
                      milliseconds: 400,
                    ),
                    onEnd: () {
                      setState(() {
                        isAnimating = false;
                      });
                    },
                  ),
                )
              ],
            ),
          ),
        ),

        //like comment save section
        Row(
          children: [
            //like
            LikeAnimation(
              isAnimating: widget.snap['likes'].contains(user.uid),
              smallLike: true,
              child: IconButton(
                  onPressed: () async {
                    await FireStoreMethods().likePost(widget.snap['postId'],
                       user.uid, widget.snap['likes']);
                    setState(() {
                      isAnimating = true;
                    });
                  },
                  icon: widget.snap['likes'].contains(user.uid)
                      ? const Icon(
                          Icons.favorite,
                          color: Colors.red,
                          size: 32,
                        )
                      : Icon(
                          CupertinoIcons.heart,
                          size: 32,
                        )),
            ),

            //comment
            IconButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => CommentScreen(snap: widget.snap)));
                },
                icon: const Icon(
                  CupertinoIcons.chat_bubble,
                  size: 30,
                )),

            //share
            IconButton(
                onPressed: () {},
                icon: const Icon(
                  CupertinoIcons.paperplane,
                  size: 30,
                )),

            Spacer(),
            //bookmark
            IconButton(
                onPressed: () {},
                icon: Icon(
                  CupertinoIcons.bookmark,
                  size: 30,
                ))
          ],
        ),

        //number of likes , description and number of comments
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            //number of likes
            Row(
              children: [
                DefaultTextStyle(
                  style: Theme.of(context).textTheme.subtitle2!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                  child: Text(
                    '${widget.snap['likes'].length} likes',
                  ),
                ),

                const Spacer(),

                //published date
                Text(
                  DateFormat.yMMMd().format(
                    widget.snap['datePublished'].toDate(),
                  ),
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),

            SizedBox(
              height: 8,
            ),

            Column(
              children: <Widget>[
                ExpandableText(
                  widget.snap['discription'],
                  prefixText: widget.snap['username'],
                  prefixStyle: const TextStyle(fontWeight: FontWeight.bold),
                  expandText: 'show more',
                  collapseText: 'show less',
                  maxLines: 3,
                  linkColor: Colors.blue,
                ),
              ],
            ),

            //number of comments
            InkWell(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => CommentScreen(snap: widget.snap)));
              },
              child: Container(
                  padding: EdgeInsets.symmetric(vertical: 5),
                  child: Text(
                    'View all ${numberOfComments} comments..',
                    style: TextStyle(color: Colors.grey.shade700, fontSize: 15),
                  )),
            )
          ]),
        )
      ]),
    );
  }
}
