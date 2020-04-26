import 'package:flutter/material.dart';
import 'package:insta/constants/size.dart';
import 'package:insta/utils/profile_image_parser.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:insta/widgets/profile_side_menu.dart';

class Profile extends StatefulWidget {
  @override
  ProfileState createState() => ProfileState();
}

class ProfileState extends State<Profile> {
  bool _menuOpenState = false;   // 상단 햄버거 버튼 눌렀을때 사이드메뉴 오픈여부
  Size _size;                    // size변수
  double menuWidth;              // 메뉴가로길이
  int duration = 200;            // 사이드 메뉴가 열리고닫힐 시간
  AlignmentGeometry tabAlign = Alignment.centerLeft;
  

  @override
  Widget build(BuildContext context) {
    _size = MediaQuery.of(context).size;
    menuWidth = _size.width / 1.5;
    return Scaffold(
      body: Stack(
        children: <Widget>[
          _rightSideMenu(),
          _profile(),
        ],
      ),
    );
  }
  Widget _rightSideMenu() {
    return AnimatedContainer(
      width: menuWidth,
      curve: Curves.linear,
      color: Colors.grey[200],
      duration: Duration(milliseconds: duration),
      transform: Matrix4.translationValues(
          _menuOpenState ? _size.width - menuWidth : _size.width, 0, 0),
      child: SafeArea(
        child: SizedBox(
          width: menuWidth,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              FlatButton(
                onPressed: null,
                child: Text(
                  'userName',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                  ),
                ),
              ),
              ProfileSideMenu(),
            ],
          ),
        ),
      ),
    );
  }
  Widget _profile() {
    return AnimatedContainer(
      curve: Curves.linear,
      color: Colors.transparent,
      duration: Duration(milliseconds: duration),
      transform:
          Matrix4.translationValues(_menuOpenState ? -menuWidth : 0, 0, 0),
      child: SafeArea(
        child: Column(
          children: <Widget>[
            _appBar(),
            _profileHeader(),
          ],
        ),
      ),
    );
  }

  Row _appBar() {
    return Row(
      children: <Widget>[
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: common_gap),
            child: Text(
              'userName',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
              ),
            ),
          ),
        ),
        IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {
            setState(() {
              _menuOpenState = !_menuOpenState;
            });
          },
        )
      ],
    );
  }
  Expanded _profileHeader() {
    return Expanded(
      child: CustomScrollView(
        slivers: <Widget>[
          SliverList(
            delegate: SliverChildListDelegate([
              _header(),
              _userName(),
              _profileComment(),
              _editProfile(),
              _tabIcons(),
              _animatedBar(),
            ]),
          ),
          _getImageGrid(context),
        ],
      ),
    );
  }
  Row _header() {
    return Row(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(common_gap),
          child: CircleAvatar(
            radius: 40,
            backgroundImage: NetworkImage(getProfileImgPath('userName')),
          ),
        ),
        Expanded(
          child: Table(
            children: [
              TableRow(children: [
                _getStatusValue('473'),
                _getStatusValue('8k'),
                _getStatusValue('45k'),
              ]),
              TableRow(children: [
                _getStatusLabel('Posts'),
                _getStatusLabel('Followers'),
                _getStatusLabel('Following'),
              ])
            ],
          ),
        )
      ],
    );
  }
  Center _getStatusValue(String value) => Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: common_s_gap),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),
      );

  Center _getStatusLabel(String value) => Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: common_s_gap),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.w300),
            ),
          ),
        ),
      );
  
  Padding _userName() {
    return Padding(
      padding: const EdgeInsets.only(left: common_gap),
      child: Text(
        'userName',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }

  Padding _profileComment() {
    return Padding(
      padding: const EdgeInsets.only(left: common_gap),
      child: Text(
        '지연아사랑해',
        style: TextStyle(fontWeight: FontWeight.w400),
      ),
    );
  }

  Padding _editProfile() {
    return Padding(
      padding: const EdgeInsets.all(common_gap),
      child: SizedBox(
        height: 24,
        child: Container(
          color: Colors.white,
          child: OutlineButton(
            onPressed: () {},
            borderSide: BorderSide(color: Colors.black45),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              'Edit profile',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }
  Row _tabIcons() {
    return Row(
      children: <Widget>[
        Expanded(
          child: IconButton(
            icon: ImageIcon(AssetImage('assets/grid.png')),
            onPressed: () => _setTab(true),
            color: this.tabAlign == Alignment.centerRight
                ? Colors.grey[400]
                : Colors.black87,
          ),
        ),
        Expanded(
          child: IconButton(
            icon: ImageIcon(AssetImage('assets/saved.png')),
            onPressed: () => _setTab(false),
            color: this.tabAlign == Alignment.centerLeft
                ? Colors.grey[400]
                : Colors.black87,
          ),
        ),
      ],
    );
  }
  _setTab(bool tableLeft) {
    setState(() {
      if (tableLeft) {
        this.tabAlign = Alignment.centerLeft;
      } else {
        this.tabAlign = Alignment.centerRight;
      }
    });
  }
 
  Widget _animatedBar() {
    return AnimatedContainer(
      alignment: tabAlign,
      duration: Duration(microseconds: duration),
      curve: Curves.easeInOut,
      color: Colors.transparent,
      height: 1,
      width: _size.width,
      child: Container(
        height: 3,
        width: _size.width / 2,
        color: Colors.black87,
      ),
    );
  }
  SliverToBoxAdapter _getImageGrid(BuildContext context) {
    return SliverToBoxAdapter(
      child: Stack(
        children: <Widget>[
          AnimatedContainer(
            transform: Matrix4.translationValues(
              this.tabAlign == Alignment.centerLeft ? 
              0 : _size.width,
              0,
              0,
            ),
            duration: Duration(milliseconds: duration),
            curve: Curves.linear,
            child: _imageGrid(),
          ),
          AnimatedContainer(
            transform: Matrix4.translationValues(
              this.tabAlign == Alignment.centerLeft ? 
              -_size.width : 0,
              0,
              0,
            ),
            duration: Duration(milliseconds: duration),
            curve: Curves.linear,
            child: _imageGrid(),
          ),
        ],
      ),
    );
  }
  GridView _imageGrid() {
    return GridView.count(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      crossAxisCount: 3,
      childAspectRatio: 1,
      children: List.generate(30, (index) => _gridImgItem(index)),
    );
  }

  CachedNetworkImage _gridImgItem(int index) {
    return CachedNetworkImage(
      fit: BoxFit.cover,
      imageUrl: "https://picsum.photos/id/$index/100/100",
    );
  }
}