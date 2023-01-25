import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clone1/provider/user_provider.dart';
import 'package:instagram_clone1/resources/firestore_method.dart';
import 'package:instagram_clone1/utils/colors.dart';
import 'package:instagram_clone1/utils/image_picker.dart';
import 'package:instagram_clone1/utils/snackbar.dart';
import 'package:provider/provider.dart';

class AddPost extends StatefulWidget {
  const AddPost({super.key});

  @override
  State<AddPost> createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  Uint8List? _image;
  final TextEditingController discriptionController = TextEditingController();
  bool isLoading = false;

  @override
  void dispose() {
    super.dispose();
    discriptionController.dispose();
  }

//showing galley or camera option using dialog box
  _selectImage(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: const Text("create a post"),
            children: [
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                onPressed: () async {
                  Navigator.of(context).pop();
                  Uint8List file = await pickImage(ImageSource.camera);
                  setState(() {
                    _image = file;
                  });
                },
                child: const Text("take photo"),
              ),
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                onPressed: () async {
                  Navigator.of(context).pop();
                  Uint8List file = await pickImage(ImageSource.gallery);
                  setState(() {
                    _image = file;
                  });
                },
                child: const Text("select image from gallery"),
              ),

              //cancel
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("cancel"),
              )
            ],
          );
        });
  }

  //post image function
  void postImage(String username, String uid, String profileImage) async {
    setState(() {
      isLoading = true;
    });
    try {
      String res = await FireStoreMethods().uploadPost(
          discriptionController.text, uid, _image, username, profileImage);
      if (res == 'success') {
        setState(() {
          isLoading = false;
        });
        showSnackBar("posted", context);
        clearImage();
      } else {
        showSnackBar(res, context);
      }
    } catch (err) {
      showSnackBar(err.toString(), context);
    }
  }

  void clearImage() {
    discriptionController.clear();
    setState(() {
      _image = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);
    return _image == null
        ? Center(
            child: IconButton(
              icon: const Icon(
                Icons.add_to_photos,
                size: 50,
              ),
              onPressed: () => _selectImage(context),
            ),
          )
        : Scaffold(
            appBar: AppBar(
              backgroundColor: mobileBackgroundColor,
              leading: IconButton(
              onPressed: () => clearImage(),
              icon: const Icon(Icons.arrow_back)),
              title: const Text('post to'),
              actions: [
                TextButton(
                    onPressed: () => postImage(
                        userProvider.getUser.username,
                        userProvider.getUser.uid,
                        userProvider.getUser.photoURL),
                    child: const Text(
                      "post",
                      style: TextStyle(
                        color: blueColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ))
              ],
            ),
            body: Column(
              children: [
                isLoading
                    ? const LinearProgressIndicator()
                    : const Padding(padding: EdgeInsets.only(top: 0)),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      backgroundImage:
                          NetworkImage(userProvider.getUser.photoURL),
                      radius: 22,
                    ),

                    //caption for the post
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.45,
                      child: TextField(
                        decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: "enter your caption..."
                            ),
                        maxLines: 10,
                        controller: discriptionController,
                      ),
                    ),
                    SizedBox(
                      height: 65,
                      width: 65,
                      child: AspectRatio(
                        aspectRatio: 457 / 451,
                        child: Container(
                          decoration: BoxDecoration(
                              image: DecorationImage(
                            image: MemoryImage(_image!),
                            fit: BoxFit.fill,
                            alignment: FractionalOffset.topCenter,
                          )),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ));
  }
}
