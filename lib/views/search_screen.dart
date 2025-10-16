import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_app/widgets/custom_text_field.dart';
import '../cubit/search_cubit.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _wasSelected = false;

  void _onSearchSubmit(String value) {
    if (value.isNotEmpty) {
      context.read<SearchCubit>().addSearch(value);
      FocusScope.of(context).unfocus();
    }
  }

  @override
  void initState() {
    super.initState();
    final cubit = context.read<SearchCubit>();
    final lastSearch = cubit.currentSearch;

    if (lastSearch != null && lastSearch.isNotEmpty) {
      _controller.text = lastSearch;
      _focusNode.requestFocus();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _controller.selection = TextSelection(
          baseOffset: 0,
          extentOffset: lastSearch.length,
        );
        setState(() => _wasSelected = true);
      });
    }

    _focusNode.addListener(() {
      if (!_focusNode.hasFocus && _wasSelected) {
        setState(() {
          _controller.selection = TextSelection.collapsed(
            offset: _controller.text.length,
          );
          _wasSelected = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(title: const Text("Search")),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: BlocBuilder<SearchCubit, List<String>>(
            builder: (context, history) {
              final cubit = context.read<SearchCubit>();

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomTextField(
                    controller: _controller,
                    focusNode: _focusNode,
                    hintText: 'Search...',
                    onSubmitted: _onSearchSubmit,
                    onChanged: (value) {
                      if (_wasSelected) {
                        _controller.selection = TextSelection.fromPosition(
                          TextPosition(offset: value.length),
                        );
                        setState(() => _wasSelected = false);
                      }
                    },
                    suffixIcon: _controller.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              setState(() {
                                _controller.clear();
                                cubit.clearCurrent();
                              });
                            },
                          )
                        : null,
                  ),
                  const SizedBox(height: 16),
                  if (history.isNotEmpty)
                    Row(
                      children: [
                        const Text(
                          "Recent Searches",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          onPressed: () => cubit.clearAll(),
                          icon: const Text('Clear'),
                        ),
                      ],
                    ),

                  const SizedBox(height: 8),

                  if (history.isNotEmpty)
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: history.map((word) {
                        return GestureDetector(
                          onTap: () {
                            _controller.text = word;
                            _focusNode.requestFocus();
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              _controller.selection = TextSelection(
                                baseOffset: 0,
                                extentOffset: word.length,
                              );
                            });
                            setState(() => _wasSelected = true);
                            cubit.addSearch(word);
                          },
                          child: Chip(
                            label: Text(word),
                            backgroundColor: Colors.grey.shade200,
                          ),
                        );
                      }).toList(),
                    ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
