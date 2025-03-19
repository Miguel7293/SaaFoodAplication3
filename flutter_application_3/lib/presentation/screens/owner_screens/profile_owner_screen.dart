import 'package:flutter/material.dart';

class OwnerProfileScreen extends StatefulWidget {
  const OwnerProfileScreen({super.key});

  @override
  State<OwnerProfileScreen> createState() => _OwnerProfileScreenState();
}

class _OwnerProfileScreenState extends State<OwnerProfileScreen> {
  final double coverHeight = 280;
  final double profileHeight = 144;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          buildTop(),
          buildContent(),
        ],
      ), 
    );
  }
  Widget buildCoverImage()=> Container(
    color: Colors.grey,
    child: Image.network(
      'https://w.wallhaven.cc/full/o3/wallhaven-o3715l.png',
      width: double.infinity,
      height:coverHeight,
      fit: BoxFit.cover,
    ),
  );
  Widget buildProfileImage()=>CircleAvatar(
    radius: profileHeight/2,
    backgroundColor:Colors.grey.shade800,
    backgroundImage: NetworkImage(
      'https://w.wallhaven.cc/full/1p/wallhaven-1pk8r9.jpg'
    )
  );
  Widget buildTop(){
    final bottom = profileHeight/2;
    final top = coverHeight-profileHeight/2;
    return Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          Container(
            margin: EdgeInsets.only(bottom : bottom),
            child:  buildCoverImage(),
          ),
          Positioned(
            top: top,
            child: buildProfileImage(),
          )
        ]
      );
  }

   Widget buildContent() => Column(
      children: [

        const SizedBox(height: 8),
        Text(
          'MAkima Himeragi',
          style: TextStyle(fontSize: 28,fontWeight: FontWeight.bold,),
        ),
        const SizedBox(height: 8),
        Text(
          'Flutter Enginer',
          style: TextStyle(fontSize: 20,color: Colors.black12),
        )
         
      ]
  ) ;


}