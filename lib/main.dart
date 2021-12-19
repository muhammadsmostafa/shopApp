import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/shared/bloc_observer.dart';
import 'package:shop_app/shared/components/constants.dart';
import 'package:shop_app/shared/network/local/cashe_helper.dart';
import 'package:shop_app/shared/network/remote/dio_helper.dart';
import 'package:shop_app/shared/styles/themes.dart';
import 'layout/cubit/cubit.dart';
import 'layout/shop_layout.dart';
import 'modules/login/login_screen.dart';
import 'modules/on_boarding/on_boarding_screen.dart';

void main() async
{
  WidgetsFlutterBinding
      .ensureInitialized(); //to be sure that every thing on the method done and then open the app

  Bloc.observer = MyBlocObserver();
  DioHelper.init();
  await CasheHelper.init();

  Widget widget;

  bool? onBoarding = CasheHelper.getData(key: 'onBoarding');
  Token = CasheHelper.getData(key: 'token');

  if (onBoarding != null)
    {
      if(Token != null) {
        widget = const AppLayout();
      } else {
        widget = LoginScreen();
      }
    } else{
    widget = const OnBoardingScreen();
  }


  runApp(MyApp(
    startWidget: widget,
  ));
}

class MyApp extends StatelessWidget {
  final Widget startWidget;
  const MyApp({Key? key, required this.startWidget}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
        return BlocProvider(
          create: (BuildContext context) => AppCubit()..getHomeData()..getCategoriesData()..getFavoritesData()..getProfile(),
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: lightTheme,
            darkTheme: darkTheme,
            themeMode: ThemeMode.light,
            home: startWidget,
          ),
        );
      }
}