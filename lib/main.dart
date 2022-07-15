import 'dart:async';
import 'dart:math';

import 'package:autocomplete_app/data/providers/autocompete_api.dart';
import 'package:autocomplete_app/data/repositories/autocomplete_repo.dart';
import 'package:autocomplete_app/logic/bloc/autocomplete_bloc.dart';
import 'package:autocomplete_app/snack_bar.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final AutocompleteApi _api;

  @override
  void initState() {
    super.initState();
    _api = AutocompleteApi();
  }

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => AutocompleteRepo(_api),
      child: MaterialApp(
        title: 'Flutter Autocomplete',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: BlocProvider(
          create: (context) => AutocompleteBloc(context.read()),
          child: BlocListener<AutocompleteBloc, AutocompleteState>(
            listener: (context, state) {
              if (state.status.isFailed) {
                showSnackBar(text: 'Произошла ошибка API', context: context);
              }
            },
            child: const MyHomePage(),
          ),
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late final AutocompleteBloc _autocompleteBloc;

  @override
  void initState() {
    super.initState();
    _autocompleteBloc = context.read<AutocompleteBloc>();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 40, 16, 40),
                    child: AutocompleteWidget(
                      autocompleteBloc: _autocompleteBloc,
                    ),
                  ),
                  Positioned(
                    child: BlocBuilder<AutocompleteBloc, AutocompleteState>(
                      builder: (context, state) {
                        return Padding(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                          child: SizedBox(
                            height: 40,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: List.generate(
                                min(state.suggestions.length, 3),
                                (index) => Expanded(
                                  child: AutocompleteButton(
                                    text: state.suggestions[index].text,
                                    autocompleteBloc: _autocompleteBloc,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AutocompleteButton extends StatelessWidget {
  const AutocompleteButton({
    required this.text,
    required this.autocompleteBloc,
    Key? key,
  }) : super(key: key);

  final String text;
  final AutocompleteBloc autocompleteBloc;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        textStyle: const TextStyle(
          fontSize: 18,
        ),
      ),
      onPressed: _onPressed,
      child: FittedBox(
        child: Align(
          child: Text(text),
        ),
      ),
    );
  }

  void _onPressed() {
    autocompleteBloc.add(AutocompleteSelectEvent(text));
  }
}

class AutocompleteWidget extends StatefulWidget {
  const AutocompleteWidget({
    required this.autocompleteBloc,
    Key? key,
  }) : super(key: key);

  final AutocompleteBloc autocompleteBloc;

  @override
  State<AutocompleteWidget> createState() => _AutocompleteWidgetState();
}

class _AutocompleteWidgetState extends State<AutocompleteWidget> {
  late final TextEditingController _textInput;

  AutocompleteState get state => widget.autocompleteBloc.state;

  @override
  void initState() {
    super.initState();
    _textInput = TextEditingController();
  }

  @override
  void dispose() {
    _textInput.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AutocompleteBloc, AutocompleteState>(
      listenWhen: (previous, current) {
        if (current.query != _textInput.text) {
          return true;
        }
        return false;
      },
      listener: (context, state) {
        _textInput.text = state.query;
        _textInput.selection = TextSelection.fromPosition(
          TextPosition(offset: _textInput.text.length),
        );
      },
      buildWhen: (previous, current) {
        if (current.query != _textInput.text) {
          return true;
        }
        return false;
      },
      builder: (context, state) {
        return TextFormField(
          autocorrect: false,
          enableSuggestions: false,
          keyboardType: TextInputType.visiblePassword,
          minLines: 1,
          maxLines: 1,
          controller: _textInput,
          onChanged: onChanged,
          decoration: const InputDecoration(
            hintText: "Запрос...",
          ),
          style: const TextStyle(
            fontSize: 18,
          ),
        );
      },
    );
  }

  void onChanged(final String query) {
    widget.autocompleteBloc.add(AutocompleteGetEvent(query));
  }
}
