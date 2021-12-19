import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/layout/shop_layout.dart';
import 'package:shop_app/modules/login/cubit/cubit.dart';
import 'package:shop_app/modules/login/login_screen.dart';
import 'package:shop_app/shared/components/components.dart';
import 'package:shop_app/shared/components/constants.dart';
import 'package:shop_app/shared/network/local/cashe_helper.dart';
import 'cubit/cubit.dart';
import 'cubit/states.dart';

class RegisterScreen extends StatelessWidget {
  var formKey = GlobalKey<FormState>();
  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var confirmPasswordController = TextEditingController();
  var phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (BuildContext context) => RegisterCubit(),),
        BlocProvider(create: (BuildContext context) => LoginCubit(),),
        ],
        child: BlocConsumer<RegisterCubit,RegisterStates>(
          listener: (context,state)
          {
            if(state is RegisterSuccessState)
            {
              showToast(
                message: state.loginModel.message,
                state: ToastStates.SUCCESS,
              );
              CasheHelper.saveData(key: 'token', value: state.loginModel.data!.token).then((value)
              {
                Token = state.loginModel.data!.token;
                navigateAndFinish
                  (
                  context,
                  const AppLayout(),
                );
              });
            } else if (state is RegisterErrorState)
            {
              showToast(
                message:'Wrong Data',
                state: ToastStates.ERROR,
              );
            }
          },
          builder: (context,state)
          {
            return Scaffold(
              body: Center (
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Form(
                      key: formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'REGISTER',
                            style: Theme.of(context).textTheme.headline4!.copyWith(
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            'Register now to browse our hot offers',
                            style: Theme.of(context).textTheme.bodyText1!.copyWith(
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          defaultFormField(
                            controller: nameController,
                            type: TextInputType.name,
                            validate: (String? value)
                            {
                              if (value!.isEmpty)
                              {
                                return 'please enter your name address';
                              }
                            },
                            label: 'Name',
                            prefix: Icons.person,
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          defaultFormField(
                            controller: emailController,
                            type: TextInputType.emailAddress,
                            validate: (String? value)
                            {
                              if (value!.isEmpty)
                              {
                                return 'please enter your email address';
                              }
                            },
                            label: 'Email Address',
                            prefix: Icons.email_outlined,
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          defaultFormField(
                            controller: phoneController,
                            type: TextInputType.phone,
                            validate: (String? value)
                            {
                              if (value!.isEmpty)
                              {
                                return 'please enter your phone address';
                              }
                            },
                            label: 'Phone Number',
                            prefix: Icons.phone,
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          defaultFormField(
                            controller: passwordController,
                            type: TextInputType.visiblePassword,
                            validate: (String? value)
                            {
                              if (value!.isEmpty)
                              {
                                return 'password is too short';
                              }
                            },
                            isPassword: RegisterCubit.get(context).isPassword,
                            label: 'Password',
                            prefix: Icons.lock_outline,
                            suffix: RegisterCubit.get(context).suffix,
                            suffixPressed: ()
                            {
                              RegisterCubit.get(context).changePasswordVisibility();
                            },
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          defaultFormField(
                            controller: confirmPasswordController,
                            type: TextInputType.visiblePassword,
                            validate: (String? value)
                            {
                              if (value!.isEmpty)
                              {
                                return 'you should confirm your password';
                              }
                              if (passwordController.text!=value)
                              {
                                return 'password not match';
                              }
                            },
                            isPassword: RegisterCubit.get(context).isConfirmPassword,
                            label: 'Confirm password',
                            prefix: Icons.lock_outline,
                            suffix: RegisterCubit.get(context).suffixConfirm,
                            suffixPressed: ()
                            {
                              RegisterCubit.get(context).changeConfirmPasswordVisibility();
                            },
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                            state is RegisterLoadingState
                              ?
                            const Center(child: CircularProgressIndicator())
                                :
                            defaultButton(
                              function: () {
                                if(formKey.currentState!.validate())
                                {
                                  RegisterCubit.get(context).userRegister(
                                    name: nameController.text,
                                    email: emailController.text,
                                    password: passwordController.text,
                                    phone: phoneController.text,
                                  );
                                }
                              },
                              text: 'register',
                            ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'Already have an account?',
                              ),
                              defaultTextButton(
                                  function: () {
                                    navigateAndFinish(
                                        context,
                                        LoginScreen());
                                  },
                                  text: 'login'
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
    );
  }
}
