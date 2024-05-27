import 'package:client_tools/client_tools.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hw_dashboard/create_course/create_course.dart';
import 'package:hw_dashboard/l10n/l10n.dart';
import 'package:hw_dashboard/select_course_teacher/select_course_teacher.dart';
import 'package:tools/tools.dart';

class CreateCourseForm extends StatefulWidget {
  const CreateCourseForm({super.key});

  @override
  State<CreateCourseForm> createState() => _CreateCourseFormState();
}

class _CreateCourseFormState extends State<CreateCourseForm> {
  final name = Field('');
  final year = Field<int>();
  final grade = Field<Grade>();
  final teacher = Field<User>(const User.empty());

  @override
  Widget build(BuildContext context) {
    final loading = context.select((CreateCourseCubit cubit) => cubit.state.status.isLoading);
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final l10n = context.l10n;

    return MultiBlocListener(
      listeners: [
        // WHEN THE COUSRE HAS BEEN CREATED SUCCESSFULLY
        BlocListener<CreateCourseCubit, CreateCourseState>(
          listenWhen: (previous, current) => current.event == Events.createdCourse,
          // SHOW A SNACKBAR TO NOTIFY THE USER
          listener: (context, state) {
            context.nav.pop(state.newCourse);
          },
        ),

        // WHEN THE SERVER THROWS A VALIDATION ERROR
        BlocListener<CreateCourseCubit, CreateCourseState>(
          listenWhen: (previous, current) => current.error == Errors.validationError,
          listener: (context, state) {
            name.error = toErrorString(context, state.validationError['name']);
            year.error = toErrorString(context, state.validationError['year']);
            grade.error = toErrorString(context, state.validationError['grade']);
            teacher.error = toErrorString(context, state.validationError['teacher']);

            setState(() {});
          },
        ),
      ],
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // NAME FIELD
          TextField(
            onChanged: (value) => setState(() => name.update(value)),
            decoration: InputDecoration(labelText: l10n.formLabel_CourseName, errorText: name.error),
          ),
          const SizedBox(height: Spacing.m),

          // YEAR FIELD
          TextField(
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

          // TEACHER FIELD
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (teacher.value!.isNotEmpty) ...[
                CircleAvatar(
                  backgroundImage: teacher.value!.profileImageUrl.isEmpty
                      ? Assets.images.defaultProfileImage.provider()
                      : NetworkImage(teacher.value!.profileImageUrl),
                ),
                const SizedBox(width: Spacing.m),
                Text(teacher.value!.name),
              ] else
                Text(
                  l10n.formLabel_SelectTeacher,
                  style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
              const SizedBox(width: Spacing.m),
              ElevatedButton(
                onPressed: () {
                  context.nav.push(SelectTeacherPage.route()).then((t) {
                    if (t != null) setState(() => teacher.update(t));
                  });
                },
                child: Text(l10n.linkLabel_Edit),
              ),
            ],
          ),
          const SizedBox(height: Spacing.m),
          if (teacher.error != null)
            Text(
              teacher.error!,
              style: textTheme.labelMedium?.copyWith(color: colorScheme.error),
            ),
          const SizedBox(height: Spacing.m),

          // SUBMIT BUTTON
          loading
              ? const CircularProgressIndicator()
              : ElevatedButton(onPressed: _submit, child: Text(l10n.buttonLabel_Submit)),
        ],
      ),
    );
  }

  // WHEN THE USER PRESSES THE SUBMIT BUTTON
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

    // VALDIATE TEACHER
    if (teacher.value!.isEmpty) {
      teacher.error = l10n.validationError_Required;
    }

    // WHEN THE USER HAS FINISHED EDITING PERSONAL INFO
    if (noErrorsIn([name, year, grade, teacher])) {
      context.read<CreateCourseCubit>().createCourse(
            name: name.newValue!,
            year: year.newValue!,
            grade: grade.newValue!,
            teacherId: teacher.newValue!.id,
          );
    }

    // WHEN THERE ARE ERRORS IN THE FIELDS
    else {
      setState(() {});
    }
  }
}
