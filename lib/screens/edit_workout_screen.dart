import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_app_complete/blocs/workout_cubit.dart';
import 'package:flutter_bloc_app_complete/blocs/workouts_cubit.dart';
import 'package:flutter_bloc_app_complete/states/workout_states.dart';

import '../helpers/helpers.dart';
import '../models/exercise.dart';
import '../models/workout.dart';
import 'edit_exercise_screen.dart';

class EditWorkoutScreen extends StatelessWidget {
  const EditWorkoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => BlocProvider.of<WorkoutCubit>(context).goHome(),
      child: BlocBuilder<WorkoutCubit, WorkoutState>(
        builder: (context, state) {
          WorkoutEditing we = state as WorkoutEditing;
          return Scaffold(
            appBar: AppBar(
              title: InkWell(
                child: Text(we.workout!.title!),
                onTap: () => showDialog(
                  context: context,
                  builder: (_) {
                    final controller =
                        TextEditingController(text: we.workout!.title!);
                    return AlertDialog(
                      content: TextField(
                        controller: controller,
                        decoration: const InputDecoration(
                          labelText: "Workout title",
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            if (controller.text.isNotEmpty) {
                              Navigator.pop(context);
                              Workout renamed = we.workout!.copyWith(
                                title: controller.text,
                              );
                              BlocProvider.of<WorkoutsCubit>(context)
                                  .saveWorkout(
                                renamed,
                                we.index,
                              );
                              BlocProvider.of<WorkoutCubit>(context)
                                  .editWorkout(
                                renamed,
                                we.index,
                              );
                            }
                          },
                          child: const Text('Rename'),
                        ),
                      ],
                    );
                  },
                ),
              ),
              leading: BackButton(
                onPressed: () {
                  BlocProvider.of<WorkoutCubit>(context).goHome();
                },
              ),
            ),
            body: ListView.builder(
              itemCount: we.workout!.exercises.length,
              itemBuilder: (context, index) {
                Exercise exercise = we.workout!.exercises[index];
                if (we.exIndex == index) {
                  return EditExerciseScreen(
                    workout: we.workout,
                    index: we.index,
                    exIndex: we.exIndex,
                  );
                } else {
                  return ListTile(
                    title: Text(exercise.title!),
                    leading: Text(formatTime(exercise.prelude!, true)),
                    trailing: Text(formatTime(exercise.duration!, true)),
                    onTap: () => BlocProvider.of<WorkoutCubit>(context)
                        .editExercise(index),
                  );
                }
              },
            ),
          );
        },
      ),
    );
  }
}
