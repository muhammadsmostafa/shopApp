import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/shared/components/components.dart';

import 'cubit/cubit.dart';
import 'cubit/states.dart';

class SearchScreen extends StatelessWidget
{
  var formKey = GlobalKey<FormState>();
  var searchController = TextEditingController();
  SearchScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => SearchCubit(),
      child: BlocConsumer<SearchCubit,SearchStates>(
        listener: (context, state){},
        builder: (context, state){
          return Scaffold(
            appBar: AppBar(),
            body: Form(
              key: formKey,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                children:
                [
                  defaultFormField(
                      controller: searchController,
                      type: TextInputType.text,
                      validate:(String? value)
                      {
                        if(value!.isEmpty)
                          {
                            return 'Enter text to search';
                          }
                        return null;
                      },
                      label: 'Search',
                      prefix: Icons.search,
                    onSubmit: (String text)
                      {
                        SearchCubit.get(context).search(text);
                      },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  if(state is SearchLoadingState)
                  const LinearProgressIndicator(),
                  const SizedBox(
                    height: 10,
                  ),
                  if (state is SearchSuccessState)
                  Expanded(
                    child: ListView.separated(
              itemBuilder: (context,index) => buildListProduct(SearchCubit.get(context).model!.data.data[index], context, isOldPrice : false),
              separatorBuilder: (context,index) => myDivider(),
              itemCount: SearchCubit.get(context).model!.data.data.length,
            ),
                  ),
                ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
