import 'package:flutter/material.dart';
import 'package:flutter_application_1/constants.dart';
import 'package:flutter_application_1/models/api_response.dart';
import 'package:flutter_application_1/models/post.dart';
import 'package:flutter_application_1/screens/login.dart';
import 'package:flutter_application_1/services/post_service.dart';
import 'package:flutter_application_1/services/user_service.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({super.key});

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  List<dynamic> _postList = [];
  int userId = 0;
  bool _loading = true;

  //get all posts
  Future<void> retrievePosts() async {
    userId = await getUserId();
    ApiResponse response = await getPosts();

    if (response.error == null) {
      setState(() {
        _postList = response.data as List<dynamic>;
        _loading = _loading ? !_loading : _loading;
      });
    } else if (response.error == unauthorized) {
      logout().then((value) => {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => Login()),
                (route) => false)
          });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('${response.error}'),
      ));
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    retrievePosts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _loading
        ? Center(child: CircularProgressIndicator())
        : ListView.builder(
            itemCount: _postList.length,
            itemBuilder: (BuildContext context, int index) {
              Post post = _postList[index];
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 4, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 6),
                          child: Row(
                            children: [
                              Container(
                                width: 38,
                                height: 38,
                                decoration: BoxDecoration(
                                    image: post.user!.image != null
                                        ? DecorationImage(
                                            image: NetworkImage(
                                                '${post.user!.image}'))
                                        : null,
                                    borderRadius: BorderRadius.circular(25),
                                    color: Colors.amber),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                '${post.user!.name}',
                                style: TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 17),
                              )
                            ],
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              );
            });
  }
}
