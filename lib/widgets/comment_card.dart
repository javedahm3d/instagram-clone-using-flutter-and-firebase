import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone1/model/user.dart';
import 'package:instagram_clone1/provider/user_provider.dart';
import 'package:instagram_clone1/resources/firestore_method.dart';
import 'package:instagram_clone1/utils/colors.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CommentsCard extends StatefulWidget {
  final snap;
  const CommentsCard({super.key, required this.snap});

  @override
  State<CommentsCard> createState() => _CommentsCardState();
}

class _CommentsCardState extends State<CommentsCard> {
  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<UserProvider>(context).getUser;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 20,
            backgroundImage: NetworkImage(widget.snap['profileImage']),
          ),
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text(
                      widget.snap['username'],
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text(
                      DateFormat.yMMMd().format(widget.snap['date'].toDate()),
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          color: secondaryColor),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ExpandableText(
                  widget.snap['comment'],
                  expandText: 'show more',
                  collapseText: 'show less',
                  maxLines: 3,
                  linkColor: Colors.blue,
                ),
              ),
            ],
          )),


          Row(
            children: [
              Stack(
                children: [

                   IconButton(
                   onPressed: () async {
                     await FireStoreMethods().likeComment(widget.snap['postId'],
                         widget.snap['commentId'], user.uid, widget.snap['likes']);
                    },
                   icon: widget.snap['likes'].contains(user.uid)? const Icon(
                   Icons.favorite,
                   color: Colors.red,
                   size: 20,
                   )
                  : const Icon(
                   Icons.favorite_border,
                    size: 20,
                   ),
            alignment: Alignment.topRight,
          ),

          Positioned(   
            bottom: 6,
            left: 26,  
            child: Text("${widget.snap['likes'].length}" , style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.end,
              ),
            )


          ],
          ),
              
              
            ],
          )
         
        ],
      ),
    );
  }
}
