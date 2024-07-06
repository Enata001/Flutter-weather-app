import 'package:flutter/material.dart';

class SearchWidget extends StatefulWidget {
  final Function(String?) onSubmitted;

  const SearchWidget({
    super.key,
    required this.onSubmitted,
  });

  @override
  State<SearchWidget> createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  late TextEditingController searchController;

  @override
  void initState() {
    super.initState();
    searchController = TextEditingController();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SearchBar(
          controller: searchController,
          autoFocus: false,
          textInputAction: TextInputAction.go,
          leading:
              Icon(Icons.location_on, color: Theme.of(context).primaryColor),
          textCapitalization: TextCapitalization.words,
          elevation: WidgetStateProperty.all(1.0),
          hintText: 'Type to search...',
          trailing: [
            if (searchController.text.isNotEmpty)
              CloseButton(
                onPressed: searchController.clear,
              ),
          ],
          onChanged: (_) {
            setState(() {});
          },
          onTapOutside: (_) => FocusScope.of(context).unfocus(),
          onSubmitted: widget.onSubmitted,
          backgroundColor: WidgetStateProperty.all(Colors.white),
          constraints: BoxConstraints(
            maxWidth: size.width * 0.7,
            maxHeight: 50,
            minHeight: 50,
          ),
        ),
        const SizedBox(
          width: 10,
        ),

        //Search button
        FilledButton.icon(
          onPressed: () => widget.onSubmitted(searchController.text),
          label: const Icon(Icons.search),
          style: ButtonStyle(
            padding: WidgetStateProperty.all(EdgeInsets.zero),
            fixedSize: WidgetStateProperty.all(
              const Size.fromRadius(25),
            ),
          ),
        ),
      ],
    );
  }
}
