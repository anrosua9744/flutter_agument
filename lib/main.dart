import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return MaterialApp(

      title: 'Navigation with arguments', // 타이틀 설정
      home: HomeScreen(), // 첫번째 라우트로 HomeScreen 설정

      // 라우트 설정
      // ExtractArgumentsScreen의 라우트만 등록, PassArgumentsScreen은 등록안됨
      routes: {
        // '/extractArguments':(context)=>ExtractArgumentsScreen() 를 의미함
        ExtractArgumentsScreen.routeName:(context)=>ExtractArgumentsScreen()
      },

      /**
       * onGenerateRoute: 앱이 이름이 부여된 라우트를 네비게이팅할 때 호출됨. RouteSettings 가 전달됨
       * RouteSettings: 다음과 같은 구조를 가짐
       * const RouteSettings({
          String name,  // 라우터 이름
          bool isInitialRoute: false, // 초기 라우터인지 여부
          Object arguments  // 파라미터
          })

       * routes 테이블에 PassArgumentsScreen이 등록되지 않았지만 onGenerateRoute 함수에 의해 라우터 호출이 가능함
       */
      onGenerateRoute: (routeSettings){ // Navigator.pushNamed() 가 호출된 때 실행됨

        // 라우트 이름이 PassArgementScreen의 routeName과 같은 라우트가 생성될 수 있도록 함
        if(routeSettings.name == PassArgumentsScreen.routeName){
          // 라우트세팅에서 파라미터 추출
          final ScreenArguments args = routeSettings.arguments;

          return MaterialPageRoute(
              builder: (context){
                // 추출한 파라미터를 PassArgumentScreen의 아규먼트로 직접 전달하면서 라우트 생성 후 반환
                return PassArgumentsScreen(
                  title: args.title,
                  message: args.message,
                );
              }
          );
        }
      },
    );
  }
}
// 앱 실행시 출력되는 라우트
  class HomeScreen extends StatelessWidget{
  @override
  Widget build(BuildContext context){

    return Scaffold(
        appBar: AppBar(
          title: Text('Home Screen'),
        ),
      body: Center( // 가운데
        child: Column( // 컬룸 추가
          mainAxisAlignment: MainAxisAlignment.center,  // 자식들은 가운데 정렬
          children: <Widget>[
            // 첫번째 자식. 파라미터를 명시적으로 전달하는 방식으로 라우트 호출
            RaisedButton(
              child: Text("Navigate to screen that extracts arguments"),
              onPressed: (){
                Navigator.pushNamed(
                  context,
                  ExtractArgumentsScreen.routeName,
                  arguments: ScreenArguments(
                      'Extract Arguments Screen',
                      'This message is extracted in the build method.'
                  )
                );
              },
            ),
            RaisedButton(
              child: Text('Navigate to a named that accpts arguments'),
              onPressed: () {
                Navigator.pushNamed(
                    context,
                    PassArgumentsScreen.routeName,
                  arguments: ScreenArguments(
                      'Accept Arguments Screen',
                      'This message is extracted in the onGenerateRoute function.'
                  )
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
// 넘겨받은 context에서 아규먼트를 추철하여 라우트를 동적 구성하는 클래스
  class ExtractArgumentsScreen extends StatelessWidget {
    static const routeName = '/extractArguments';

  @override
  Widget build(BuildContext context) {
    // context로 부터 setting.orguments값을 추출하여 org로 저장
    final ScreenArguments args = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text(args.title),
      ),
      body: Center(
        child: Text(args.message),
      ),
    );
  }
}
  //전달받은 아규먼트를 이용하여 라우트를 동적 구성하는 클래스
  class PassArgumentsScreen extends StatelessWidget{
    //라우트의 이름 설정
    static const routeName = '/passArguments';

    final String title;
    final String message;
  // 생성자 , 라우트 생성시 전달한 파라미터를 아규먼트로 넘겨 받아 필드에 저장
    const PassArgumentsScreen({
      Key key,
      @required this.title,
      @required this.message

  }):super(key:key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: Text(message),
      ),
    );
  }

}
  //라우트 생성시 전달할 아규먼트 클래스
  class ScreenArguments{
    final String title;
    final String message;


    //생성자
  ScreenArguments(this.title, this.message);
  }