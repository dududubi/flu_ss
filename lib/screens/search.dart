import 'package:flutter/material.dart';
import 'package:insta/constants/size.dart';
import 'package:cached_network_image/cached_network_image.dart';

class Search extends StatefulWidget {
  @override
  SearchState createState() => SearchState();
}

class SearchState extends State<Search> {
  var _searchData = '';
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: <Widget>[
          _searchInput(),
          _scrollImage(),
        ],
      ),
    );
  }
  SizedBox _searchInput() {
    return SizedBox(
      height: 40,
      child: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.only(left: common_xs_gap),
          child: TextFormField(
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
            decoration: InputDecoration(
              labelText: _searchData.length > 0 ? '' : '검색',
            ),
            onFieldSubmitted: (data) {
              setState(() {
                _searchData = data;
              });
            },
          ),
        ),
      ),
    );
  }
  
  Expanded _scrollImage() {
    return Expanded(
      child: CustomScrollView(
        slivers: <Widget>[
          SliverToBoxAdapter(
            child: GridView.count(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              crossAxisCount: 3,
              childAspectRatio: 1,
              children: List.generate(30, (index) => _gridImgItem(index)),
            ),
          ),
        ],
      ),
    );
  }
  CachedNetworkImage _gridImgItem(int index) {
    return CachedNetworkImage(
      fit: BoxFit.cover,
      imageUrl: "https://picsum.photos/id/$index/100/100",
    );
  }
}