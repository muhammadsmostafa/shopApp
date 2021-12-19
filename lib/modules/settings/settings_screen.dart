import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/layout/cubit/cubit.dart';
import 'package:shop_app/layout/cubit/states.dart';
import 'package:shop_app/modules/login/login_screen.dart';
import 'package:shop_app/shared/components/components.dart';
import 'package:shop_app/shared/network/local/cashe_helper.dart';

class SettingsScreen extends StatelessWidget
{
  var formKey = GlobalKey<FormState>();
  var nameController =TextEditingController();
  var emailController =TextEditingController();
  var phoneController =TextEditingController();

  SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppStates>(
      listener: (context,state) {
        var model = AppCubit.get(context).profileModel!.data;
        nameController.text = model.name;
        emailController.text = model.email;
        phoneController.text = model.phone;
      },
      builder: (context,state) {
        return AppCubit.get(context).profileModel == null
        ?
        const Center(child: CircularProgressIndicator())
        :
        Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  if(state is AppLoadingUpdateUserState)
                  const LinearProgressIndicator(),
                  const SizedBox(
                    height: 20,),
                  defaultFormField(
                    controller: nameController,
                    type: TextInputType.name,
                    validate: (String? value)
                    {
                      if(value!.isEmpty)
                      {
                        return 'name must not be empty';
                      }
                      return null;
                    },
                    label: 'Name',
                    prefix: Icons.person,
                  ),
                  const SizedBox(
                      height:20
                  ),
                  defaultFormField(
                    controller: emailController,
                    type: TextInputType.emailAddress,
                    validate: (String? value)
                    {
                      if(value!.isEmpty)
                      {
                        return 'email must not be empty';
                      }
                      return null;
                    },
                    label: 'Email Address',
                    prefix: Icons.email,
                  ),
                  const SizedBox(
                      height:20
                  ),
                  defaultFormField(
                    controller: phoneController,
                    type: TextInputType.number,
                    validate: (String? value)
                    {
                      if(value!.isEmpty)
                      {
                        return 'phone must not be empty';
                      }
                      return null;
                    },
                    label: 'Phone',
                    prefix: Icons.phone,
                  ),
                const SizedBox(
                  height: 20,
                ),
                  defaultButton(
                      function: ()
                      {
                        if(formKey.currentState!.validate())
                          {
                            AppCubit.get(context).updateUserProfile(
                              name: nameController.text,
                              email: emailController.text,
                              phone: phoneController.text,
                            );
                          }
                      },
                      text: 'update'
                  ),
                const Spacer(),
                defaultButton(
                  background: Colors.red,
                    function: ()
                    {
                      CasheHelper.removeData(key: 'token').then((value)
                      {
                        if(value)
                        {
                          navigateAndFinish(
                            context,
                            LoginScreen(),
                          );
                        }
                      });
                    },
                    text: 'Logout'
                ),
                ],
              ),
            ),
          );
    },
    );
  }
}
