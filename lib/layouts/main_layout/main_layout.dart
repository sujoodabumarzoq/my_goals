import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_goals/layouts/main_layout/components/goal_item.dart';
import 'package:my_goals/layouts/main_layout/cubit/main_cubit.dart';
import 'package:my_goals/layouts/main_layout/cubit/main_states.dart';

class MainLayout extends  StatelessWidget {
  const MainLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MainCubit()..initSql()..getData(),
      child: BlocConsumer<MainCubit , MainStates>(
        listener: (context, state) {

        },
        builder: (context, state ){
          return Scaffold(
            // backgroundColor: Colors.blue[900],
            backgroundColor: Colors.white,

            appBar: AppBar(
              backgroundColor: Colors.white,
elevation: 0,
              title:  Center(
                child: Container(

                   width: 200,
                  decoration: BoxDecoration(
                    color: Colors.blue[900],
borderRadius: BorderRadius.circular(15)
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'GOALS',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          // letterSpacing: 4,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 37,
                        ),
                      ),
                      Text(
                        '💡',style: TextStyle(
                        fontSize: 30
                      ),
                      ),

                    ],
                  ),
                ),
              ),
            ),
            body: ListView.builder(
              itemCount: MainCubit.get(context).goalsList.length,
              itemBuilder:(context , index)=>goalItem(context,
                  MainCubit.get(context).goalsList[index]['id'],
                  MainCubit.get(context).goalsList[index]['name']),

            ),
            floatingActionButton: FloatingActionButton(
              focusColor: Colors.orange,
              backgroundColor: Colors.blue[900],
              onPressed: (){
                showDialog(context: context,
                    builder: (_)=>AlertDialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),

                      ),
                      content: SizedBox(
                        height: 140,
                        child: Column(
                          children: [
                            Container(
                              color: Colors.blue[900],
                              height: 30,
                              child: const Center(
                                child: Text('Write your Goal:',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 5,),
                            TextFormField(
                              controller: MainCubit.get(context).addTextController,
                              decoration:InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                label: const Text('Write Here...'),
                                floatingLabelBehavior: FloatingLabelBehavior.never,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(3),
                                ),
                                contentPadding: const EdgeInsets.all(5),
                              ) ,

                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                      style: ButtonStyle(
                                          backgroundColor: MaterialStateProperty
                                              .all(Colors.red)
                                      ),
                                      onPressed: (){
                                        MainCubit.get(context)
                                            .insertData(
                                            MainCubit.get(context).addTextController
                                            .text.toString(),
                                        );
                                        MainCubit.get(context).addTextController
                                            .text='';
                                        MainCubit.get(context).getData();
                                        Navigator.pop(context);

                                      },
                                      child: const Text('ADD')
                                  ),
                                ),
                                const SizedBox(width: 5,),
                                Expanded(
                                  child: ElevatedButton(
                                      style: ButtonStyle(
                                          backgroundColor: MaterialStateProperty
                                              .all(Colors.blue)
                                      ),
                                      onPressed: (){
                                        Navigator.pop(context);

                                      },
                                      child: const Text('Cancel')
                                  ),
                                ),
                              ],
                            )

                          ],
                        ),
                      ),
                    )

                );

              },
              child: const Icon(Icons.edit,
                size: 33,
                color: Colors.white,
              ),
            ),
          );

        },

      ),

    );

  }
}
