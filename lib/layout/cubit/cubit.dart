import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/layout/cubit/states.dart';
import 'package:shop_app/models/categories_model.dart';
import 'package:shop_app/models/change_favorites_model.dart';
import 'package:shop_app/models/favorites_model.dart';
import 'package:shop_app/models/home_model.dart';
import 'package:shop_app/models/user_model.dart';
import 'package:shop_app/modules/categories/categories_screen.dart';
import 'package:shop_app/modules/favorites/favorites_screen.dart';
import 'package:shop_app/modules/products/products_screen.dart';
import 'package:shop_app/modules/settings/settings_screen.dart';
import 'package:shop_app/shared/components/components.dart';
import 'package:shop_app/shared/components/constants.dart';
import 'package:shop_app/shared/network/remote/dio_helper.dart';
import 'package:shop_app/shared/network/remote/end_points.dart';

class AppCubit extends Cubit <AppStates>
{
 AppCubit() : super(AppInitialState());

 static AppCubit get(context)=> BlocProvider.of(context);

 int currentIndex = 0;
 List <Widget> bottomScreens =
 [
  const ProductsScreen(),
  const CategoriesScreen(),
  const FavoritesScreen(),
  SettingsScreen(),
 ];

 void changeBottom(int index)
 {
  currentIndex = index;
  emit(AppChangeBottomNavState());
 }

 HomeModel? homeModel;

 Map<int, bool> favorites = {};

 void getHomeData()
 {
  emit(AppLoadingHomeDataState());
  DioHelper.getData(
   url: HOME,
   token: Token,
  ).then((value)
  {
   homeModel = HomeModel.fromJson(value.data);
   for (var element in homeModel!.data.products) {
    favorites.addAll({
     element.id: element.inFavorites
    });
   }
   emit(AppSuccessHomeDataDataState());
  }).catchError((error)
  {
   emit(AppErrorHomeDataState());
  });
 }


 CategoriesModel? categoriesModel;

 void getCategoriesData()
 {
  DioHelper.getData(
   url: GET_CATEGORY,
   token: Token,
  ).then((value)
  {
   categoriesModel = CategoriesModel.fromJson(value.data);
   emit(AppSuccessCategoriesState());
  }).catchError((error)
  {
   emit(AppErrorCategoriesState());
  });
 }

 ChangeFavoritesModel? changeFavoritesModel;

 void changeFavorites(int productId)
 {
  favorites[productId] = !(favorites[productId]??false);
  emit(AppChangeFavoritesState());

  DioHelper.postData(
   url: FAVORITES,
   data:
   {
    'product_id': productId
   },
   token: Token,
  ).then((value){
   changeFavoritesModel = ChangeFavoritesModel.fromJson(value.data);
   if(!changeFavoritesModel!.status)
    {
     favorites[productId] = !(favorites[productId]??false);
    }else
     {
      getFavoritesData();
     }
   showToast(
    message: 'Successfully',
    state: ToastStates.SUCCESS,
   );
   emit(AppSuccessChangeFavoritesState(changeFavoritesModel!));
  }).catchError((error)
  {
   showToast(
    message: 'Error while change favorite',
    state: ToastStates.ERROR,
   );
   emit(AppErrorChangeFavoritesState());
  });
 }

 FavoritesModel? favoritesModel;
 bool isFavError=false;
 void getFavoritesData()
 {
  emit(AppLoadingGetFavoritesState());
  DioHelper.getData(
   url: FAVORITES,
   token: Token,
  ).then((value)
  {
   isFavError=false;
   favoritesModel = FavoritesModel.fromJson(value.data);
   emit(AppSuccessGetFavoritesState());
  }).catchError((error)
  {
   emit(AppErrorGetFavoritesState());
   isFavError=true;
  });
 }

 ProfileModel? profileModel;
 void getProfile()
 {
  emit(AppLoadingGetUserDataState());
  DioHelper.getData(
      url: PROFILE,
      token: Token
  ).then((value){
   profileModel = ProfileModel.fromJson(value.data);
  }).then((value){
   emit(AppSuccessGetUserDataState());
  }).catchError((error){
   emit(AppErrorGetUserDataState());
  });
 }

 void updateUserProfile({
 required String name,
 required String email,
 required String phone,
})
{
  emit(AppLoadingUpdateUserState());
  DioHelper.putData(
      url: UPDATE,
      token: Token,
      data:
      {
       'name': name,
       'email': email,
       'phone': phone,
      }).then((value){
   profileModel = ProfileModel.fromJson(value.data);
   emit(AppSuccessUpdateUserState());
   showToast(
       message: 'Updated Successfully',
       state: ToastStates.SUCCESS
   );
  }).catchError((error){
   emit(AppErrorUpdateUserState());
   showToast(
       message: 'Wrong Data',
       state: ToastStates.ERROR,
   );
  });
 }
}

