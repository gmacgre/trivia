import 'package:flutter/material.dart';
import 'package:trivia/model/category.dart';

class CategoryEditor extends StatefulWidget {
  final Category category;

  const CategoryEditor({
    super.key,
    required this.category
  });

  @override
  State<CategoryEditor> createState() => _CategoryEditorState();
}

class _CategoryEditorState extends State<CategoryEditor> {
  CategoryType _type = CategoryType.rapid;
  final TextEditingController _controller = TextEditingController();
  @override
  void initState() {
    super.initState();
    _type = widget.category.type;
    _controller.text = widget.category.title;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.category.title),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Category Title:',
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.7,
                  child: TextField(
                    controller: _controller,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Category Type:',
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.7,
                  child: DropdownMenu<CategoryType>(
                    initialSelection: _type,
                    dropdownMenuEntries: CategoryType.values.map((e) => DropdownMenuEntry(value: e, label: e.toString())).toList(),
                    onSelected: (var selection) {
                      if(selection == null) return;
                      setState(() {
                        if(_type != selection) {
                          widget.category.questions = const [];
                        }
                        _type = selection;
                      });
                    },
                  )
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: FilledButton(
              onPressed: (){
                widget.category.title = _controller.text;
                widget.category.type = _type;
                Navigator.of(context).pop(widget.category);
              },
              child: const Text('Save and Return')
            ),
          )
        ]
      ),
    );
  }
}