
import 'package:coach_student/services/api/api.dart';
import 'package:flutter/cupertino.dart';

class AddCoachPovider extends ChangeNotifier{

  getCoachData(String code)async{
    String finalUrl = "/student/add-coach?passcode=$code";
    final result = await DioApi.get(path: finalUrl);


    if(result.response != null){

    }else{

    }

  }

}