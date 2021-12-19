import 'package:shop_app/models/change_favorites_model.dart';

abstract class AppStates {}

class AppInitialState extends AppStates {}

class AppChangeBottomNavState extends AppStates {}

class AppLoadingHomeDataState extends AppStates {}

class AppSuccessHomeDataDataState extends AppStates {}

class AppErrorHomeDataState extends AppStates {}

class AppLoadingCategoriesState extends AppStates {}

class AppSuccessCategoriesState extends AppStates {}

class AppErrorCategoriesState extends AppStates {}

class AppSuccessChangeFavoritesState extends AppStates
{
  final ChangeFavoritesModel model;

  AppSuccessChangeFavoritesState(this.model);
}

class AppChangeFavoritesState extends AppStates {}

class AppErrorChangeFavoritesState extends AppStates {}

class AppSuccessGetFavoritesState extends AppStates {}

class AppLoadingGetFavoritesState extends AppStates {}

class AppErrorGetFavoritesState extends AppStates {}

class AppSuccessGetUserDataState extends AppStates {}

class AppLoadingGetUserDataState extends AppStates {}

class AppErrorGetUserDataState extends AppStates {}

class AppSuccessUpdateUserState extends AppStates {}

class AppLoadingUpdateUserState extends AppStates {}

class AppErrorUpdateUserState extends AppStates {}