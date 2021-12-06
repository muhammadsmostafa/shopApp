import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/layout/shop_app/shop_layout.dart';
import 'package:shop_app/modules/shop_app/login/shop_login_screen.dart';
import 'package:shop_app/modules/shop_app/on_boarding/on_boarding_screen.dart';
import 'package:shop_app/shared/bloc_observer.dart';
import 'package:shop_app/shared/components/constants.dart';
import 'package:shop_app/shared/network/local/cashe_helper.dart';
import 'package:shop_app/shared/network/remote/dio_helper.dart';
import 'package:shop_app/shared/styles/themes.dart';
import 'layout/shop_app/cubit/cubit.dart';


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
        widget = const ShopLayout();
      } else {
        widget = ShopLoginScreen();
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
          create: (BuildContext context) => ShopCubit()..getHomeData()..getCategoriesData()..getFavoritesData()..getProfile(),
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