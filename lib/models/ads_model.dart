import 'package:meta/meta.dart';

class AdsBanner{
  final String name;
  final String text; 
  final String bannerURL;
  final String adsURL;
  final int id;
  const AdsBanner({
    @required this.name, 
    @required this.text,
    @required this.bannerURL, 
    @required this.adsURL,
    @required this.id
  });
}