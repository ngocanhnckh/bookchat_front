import 'package:flutter_bookchat/data/data.dart';
import "package:http/http.dart" as http;

dynamic callAPI(String path, List<String> param, List<String> value) async{
  if (param!=null){
    int i=0;
    param.forEach((element) {
      if (i==0)
        path+="?" + element + "=" + value[i];
      else
        path+="&" + element + "=" + value[i];
    });
  }
  print('Getting ' + apiurl + path);
  final http.Response response = await http.get(
    Uri.parse(apiurl + path),
    headers: await getHeader(),
  );  
  //print(response.body);
  if (response.statusCode != 200) {
      print('API ${response.statusCode} response: ${response.body}');
      return null;
  } else {
      print('API ${response.statusCode} response: ${response.body}');
      var res = response.body;
      return res;
  }
}

dynamic deleteAPI(String path, List<String> param, List<String> value) async{
  if (param!=null){
    int i=0;
    param.forEach((element) {
      if (i==0)
        path+="?" + element + "=" + value[i];
      else
        path+="&" + element + "=" + value[i];
    });
  }
  print('Delete ' + apiurl + path);
  final http.Response response = await http.delete(
    Uri.parse(apiurl + path),
    headers: await getHeader(),
  );  
  //print(response.body);
  if (response.statusCode != 200) {
      print('API ${response.statusCode} response: ${response.body}');
      return null;
  } else {
      print('API ${response.statusCode} response: ${response.body}');
      var res = response.body;
      return res;
  }
}

dynamic postAPI(String path, dynamic body) async{
  print('Posting ' + apiurl + path);
  print(body);
  final http.Response response = await http.post(
    Uri.parse(apiurl + path),
    headers: await getHeader(),
    body: body,
  );  
  //print(response.body);
  if (response.statusCode != 200) {
      print('API ${response.statusCode} response: ${response.body}');
      return null;
  } else {
      print('API ${response.statusCode} response: ${response.body}');
      var res = response.body;
      return res;
  }
}

dynamic putAPI(String path, dynamic body) async{
  print('Posting ' + apiurl + path);
  final http.Response response = await http.put(
    Uri.parse(apiurl + path),
    
    headers: await getHeader(),
    body: body,
  );  
  //print(response.body);
  if (response.statusCode != 200) {
      print('API ${response.statusCode} response: ${response.body}');
      return null;
  } else {
      print('API ${response.statusCode} response: ${response.body}');
      var res = response.body;
      return res;
  }
}

dynamic postUploadAPI(String path, dynamic data) async{

}

