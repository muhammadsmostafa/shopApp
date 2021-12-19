import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/layout/cubit/cubit.dart';
import 'package:shop_app/layout/cubit/states.dart';
import 'package:shop_app/shared/components/components.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppStates>(
      listener: (context, state) {},
      builder: (context, state){
        return AppCubit.get(context).isFavError
        ?
        noFavData()
        :
        AppCubit.get(context).favoritesModel==null
        ?
        const Center(child: CircularProgressIndicator())
        :
        state is AppErrorGetFavoritesState
        ?
        noFavData()
        :
        ListView.separated(
            itemBuilder: (context,index) => buildListProduct(AppCubit.get(context).favoritesModel!.data.data[index].product, context),
            separatorBuilder: (context,index) => myDivider(),
            itemCount: AppCubit.get(context).favoritesModel!.data.data.length,
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
