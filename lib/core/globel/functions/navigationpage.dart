import 'package:flutter/material.dart';

navigationPage(context,page){
  Navigator.of(context).push(MaterialPageRoute(builder: (context)=>page));
}

navigationReplacePage(context,page){
  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>page));
}


navigationPageAndRemoveAll(context,page){
  Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>page), (route) => false);
}

navigationNamePage(context,namePage,[Object? arguments]){
  Navigator.of(context).pushNamed(namePage,arguments: arguments);
}

navigationNamePageAndRemoveAll(context,namepage,[Object? arguments]){
  Navigator.of(context).pushNamedAndRemoveUntil(namepage,arguments: arguments, (route) => false);
}