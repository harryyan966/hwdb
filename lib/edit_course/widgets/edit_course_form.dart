import 'package:client_tools/client_tools.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hw_dashboard/edit_course/cubit/edit_course_cubit.dart';
import 'package:hw_dashboard/l10n/l10n.dart';
import 'package:tools/tools.dart';

class EditCourseForm extends StatefulWidget {
  const EditCourseForm({super.key});

  @override
  State<EditCourseForm> createState() => _EditCourseFormState();
}

class _EditCourseFormState extends State<EditCourseForm> {
  final name = Field('');
  final year = Field<int>();
  final grade = Field<Grade>();

  @override
  void initState() {
    super.initState();

    final courseInfo = context.read<EditCourseCubit>().courseInfo;

    name.value = courseInfo.name;
    year.value = courseInfo.year;
    grade.value = courseInfo.grade;
  }

  @override
  Widget build(BuildContext context) {
    final teacherModified = context.select((EditCourseCubit cubit) => cubit.state.teacherModified);
    final studentsModified = context.select((EditCourseCubit cubit) => cubit.state.studentsModified);

    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final l10n = context.l10n;

    return MultiBlocListener(
      listeners: [
        // WHEN THE COURSE IS SUCCESSFULLY UPDATED ON THE SERVER
        BlocListener<EditCourseCubit, EditCourseState>(
          listenWhen: (previous, current) => current.event == Events.updatedCourseInfo,
          listener: (context, state) {
            context.nav.pop(state.newCourseInfo);
          },
        ),

        // IF THE REQUEST IS EMPTY
        BlocListener<EditCourseCubit, EditCourseState>(
          listenWhen: (previous, current) => current.error == Errors.emptyRequest,
          listener: (context, state) {
            showSimpleDialog(context, title: l10n.prompt_EmptyRequest);
          },
        ),

        // WHEN THE SERVER THROWS A VALIDATION ERROR
        BlocListener<EditCourseCubit, EditCourseState>(
          listenWhen: (previous, current) => current.error == Errors.validationError,
          listener: (context, state) {
            name.error = toErrorString(context, state.validationError['name']);
            year.error = toErrorString(context, state.validationError['year']);
            grade.error = toErrorString(context, state.validationError['grade']);

            setState(() {});
          },
        ),
      ],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // TITLE
          ListTile(
            title: Text(l10n.formLabel_CourseInfo, style: Theme.of(context).textTheme.titleMedium),
            tileColor: Theme.of(context).colorScheme.surfaceContainer,
          ),
          const SizedBox(height: Spacing.m),

          // NAME FIELD
          TextFormField(
            initialValue: name.value,
            onChanged: (value) => setState(() => name.update(value)),
            decoration: InputDecoration(labelText: l10n.formLabel_CourseName, errorText: name.error),
          ),
          const SizedBox(height: Spacing.m),

          // YEAR FIELD
          TextFormField(
            initialValue: year.value.toString(),
            keyboardType: TextInputType.number,
            onChanged: (value) => setState(() => year.update(int.tryParse(value))),
            decoration: InputDecoration(labelText: l10n.formLabel_CourseYear, errorText: year.error),
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          ),
          const SizedBox(height: Spacing.m),

          // GRADE FIELD
          DropdownButton(
            hint: Text(l10n.formLabel_SelectGrade),
            focusColor: Colors.transparent,
            value: grade.value,
            onChanged: (value) => setState(() => grade.update(value)),
            items: [
              DropdownMenuItem(value: Grade.g10fall, child: Text(l10n.grade_G10fall)),
              DropdownMenuItem(value: Grade.g10spring, child: Text(l10n.grade_G10spring)),
              DropdownMenuItem(value: Grade.g11fall, child: Text(l10n.grade_G11fall)),
              DropdownMenuItem(value: Grade.g11spring, child: Text(l10n.grade_G11spring)),
              DropdownMenuItem(value: Grade.g12fall, child: Text(l10n.grade_G12fall)),
              DropdownMenuItem(value: Grade.g12spring, child: Text(l10n.grade_G12spring)),
            ],
          ),
          const SizedBox(height: Spacing.m),
          if (grade.error != null)
            Text(
              grade.error!,
              style: textTheme.labelMedium?.copyWith(color: colorScheme.error),
            ),
          const SizedBox(height: Spacing.m),

          // SUBMIT BUTTON
          ElevatedButton(
            onPressed: (_hasChanged() || teacherModified || studentsModified) ? _submit : null,
            child: Text(l10n.buttonLabel_Submit),
          ),
        ],
      ),
    );
  }

  bool _hasChanged() {
    return name.hasBeenEdited || year.hasBeenEdited || grade.hasBeenEdited;
  }

  // WHEN THE USER PUSHES THE SUBMIT BUTTON
  void _submit() {
    final l10n = context.l10n;

    // VALIDATE NAME
    if (name.value!.isEmpty) {
      name.error = l10n.validationError_Required;
    } else if (name.value!.length < 2) {
      name.error = l10n.validationError_TooShort(2);
    }

    // VALIDATE YEAR
    if (year.value == null) {
      year.error = l10n.validationError_Required;
    } else if (year.value! < 2000 || year.value! > DateTime.now().year) {
      year.error = l10n.validationError_OutOfRange;
    }

    // VALIDATE GRADE
    if (grade.value == null) {
      grade.error = l10n.validationError_Required;
    }

    // WHEN THE USER HAS FINISHED EDITING PERSONAL INFO
    if (noErrorsIn([name, year, grade])) {
      context.read<EditCourseCubit>().editCourseInfo(
            name: name.newValue,
            year: year.newValue,
            grade: grade.newValue,
          );
    }

    // WHEN THERE ARE ERRORS IN THE FIELDS
    else {
      setState(() {});
    }
  }
}
