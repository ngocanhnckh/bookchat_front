import 'package:flutter/material.dart';
import 'package:flutter_bookchat/models/ads_model.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:url_launcher/url_launcher.dart';

class AdsSlider extends StatefulWidget {

  final List<AdsBanner> adsList;

  const AdsSlider ({ Key key,
    this.adsList,
   }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _CarouselWithIndicatorState();
  }
  
}

class _CarouselWithIndicatorState extends State<AdsSlider> {
  Future<void> _launchInBrowser(String url) async {
    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: false,
        forceWebView: false,
        headers: <String, String>{'my_header_key': 'my_header_value'},
      );
    } else {
      throw 'Could not launch $url';
    }
  }
  int _current = 0;
  
  final CarouselController _controller = CarouselController();

  @override
  Widget build(BuildContext context) {
    return 
    Container(
  
      height: 150,
      child:

      new Stack(
        children: <Widget>[
          new Container(
            child: 
            
            CarouselSlider(
            items: widget.adsList.map((i) {
                  return Builder(
                    builder: (BuildContext context) {
                      return 
                      GestureDetector(
                        onTap: (){
                          _launchInBrowser(i.adsURL);
                        },
                        child: Container(
                        
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.symmetric(horizontal: 0.0),
                        decoration: new BoxDecoration(
                          image: new DecorationImage(
                            fit: BoxFit.fitWidth,
                            alignment: FractionalOffset.topCenter,
                            image: new NetworkImage(i.bannerURL),
                          ),),
                        child: 
                        Center(child: Text(i.text, style: TextStyle(fontSize: 16.0, color: Colors.white),),)
                      ),
                      );
                      
                    },
                  );
                }).toList(),
            carouselController: _controller,
            options: CarouselOptions(
                height: MediaQuery.of(context).size.height,
                autoPlay: true,
                viewportFraction: 1.0,
                //enlargeCenterPage: true,
                //aspectRatio: 2.0,
                onPageChanged: (index, reason) {
                  setState(() {
                    _current = index;
                  });
                }),
          ), 
          
          ),
          Positioned(
            top: 150,
            right: 0.0,
               left: 0.0,
            child: 
            Column(children: [
                Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: widget.adsList.asMap().entries.map((entry) {
                  return GestureDetector(
                    onTap: () => _controller.animateToPage(entry.key),
                    child: Container(
                      width: 9.0,
                      height: 9.0,
                      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white
                              .withOpacity(_current == entry.key ? 0.9 : 0.4)),
                    ),
                  );
                }).toList(),
              ),
            ],)
            
          )
        ]
      ) 
      
      
      );
  }
}

