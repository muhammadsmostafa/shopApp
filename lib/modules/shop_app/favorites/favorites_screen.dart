import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/layout/shop_app/cubit/cubit.dart';
import 'package:shop_app/layout/shop_app/cubit/states.dart';
import 'package:shop_app/shared/components/components.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit,ShopStates>(
      listener: (context, state) {},
      builder: (context, state){
        return ShopCubit.get(context).isFavError
        ?
        noFavData()
        :
        ShopCubit.get(context).favoritesModel==null
        ?
        const Center(child: CircularProgressIndicator())
        :
        state is ShopErrorGetFavoritesState
        ?
        noFavData()
        :
        ListView.separated(
            itemBuilder: (context,index) => buildListProduct(ShopCubit.get(context).favoritesModel!.data.data[index].product, context),
            separatorBuilder: (context,index) => myDivider(),
            itemCount: ShopCubit.get(context).favoritesModel!.data.data.length,
        );
      },
    );
  }
  Widget noFavData() => Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisAlignment: MainAxisAlignment.center,
    children: const [
      Padding(
        padding: EdgeInsets.all(10.0),
        child: Text(
          'You didn\'t add any product to favorites',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
    ],
  );
}
