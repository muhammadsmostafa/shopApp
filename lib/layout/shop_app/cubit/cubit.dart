import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/layout/shop_app/cubit/states.dart';
import 'package:shop_app/models/shop_app/categories_model.dart';
import 'package:shop_app/models/shop_app/change_favorites_model.dart';
import 'package:shop_app/models/shop_app/favorites_model.dart';
import 'package:shop_app/models/shop_app/home_model.dart';
import 'package:shop_app/models/shop_app/user_model.dart';
import 'package:shop_app/modules/shop_app/categories/categories_screen.dart';
import 'package:shop_app/modules/shop_app/favorites/favorites_screen.dart';
import 'package:shop_app/modules/shop_app/products/products_screen.dart';
import 'package:shop_app/modules/shop_app/settings/settings_screen.dart';
import 'package:shop_app/shared/components/components.dart';
import 'package:shop_app/shared/components/constants.dart';
import 'package:shop_app/shared/network/remote/dio_helper.dart';
import 'package:shop_app/shared/network/remote/end_points.dart';

class ShopCubit extends Cubit <ShopStates>
{
 ShopCubit() : super(ShopInitialState());

 static ShopCubit get(context)=> BlocProvider.of(context);

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
  emit(ShopChangeBottomNavState());
 }

 HomeModel? homeModel;

 Map<int, bool> favorites = {};

 void getHomeData()
 {
  emit(ShopLoadingHomeDataState());
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
   emit(ShopSuccessHomeDataDataState());
  }).catchError((error)
  {
   emit(ShopErrorHomeDataState());
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
   emit(ShopSuccessCategoriesState());
  }).catchError((error)
  {
   emit(ShopErrorCategoriesState());
  });
 }

 ChangeFavoritesModel? changeFavoritesModel;

 void changeFavorites(int productId)
 {
  favorites[productId] = !(favorites[productId]??false);
  emit(ShopChangeFavoritesState());

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
   emit(ShopSuccessChangeFavoritesState(changeFavoritesModel!));
  }).catchError((error)
  {
   showToast(
    message: 'Error while change favorite',
    state: ToastStates.ERROR,
   );
   emit(ShopErrorChangeFavoritesState());
  });
 }

 FavoritesModel? favoritesModel;
 bool isFavError=false;
 void getFavoritesData()
 {
  emit(ShopLoadingGetFavoritesState());
  DioHelper.getData(
   url: FAVORITES,
   token: Token,
  ).then((value)
  {
   isFavError=false;
   favoritesModel = FavoritesModel.fromJson(value.data);
   emit(ShopSuccessGetFavoritesState());
  }).catchError((error)
  {
   emit(ShopErrorGetFavoritesState());
   isFavError=true;
  });
 }

 ProfileModel? profileModel;
 void getProfile()
 {
  emit(ShopLoadingGetUserDataState());
  DioHelper.getData(
      url: PROFILE,
      token: Token
  ).then((value){
   profileModel = ProfileModel.fromJson(value.data);
   emit(ShopSuccessGetUserDataState());
  }).catchError((error){
   emit(ShopErrorGetUserDataState());
  });
 }

 void updateUserProfile({
 required String name,
 required String email,
 required String phone,
})
{
  emit(ShopLoadingUpdateUserState());
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
   emit(ShopSuccessUpdateUserState());
   showToast(
       message: 'Updated Successfully',
       state: ToastStates.SUCCESS
   );
  }).catchError((error){
   emit(ShopErrorUpdateUserState());
   showToast(
       message: 'Wrong Data',
       state: ToastStates.ERROR,
   );
  });
 }
}

