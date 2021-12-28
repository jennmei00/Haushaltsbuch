import 'package:flutter/material.dart';
import 'package:haushaltsbuch/models/category.dart';

class CategoryItem extends StatelessWidget {
  final Category categoryItem;
  final Function? onTapFunction;
  final String? selectedCatID;
  final bool multiSelection;
  final List<Category>? selectedCatList;

  CategoryItem({
    required this.categoryItem,
    this.onTapFunction,
    this.selectedCatID,
    this.multiSelection: false,
    this.selectedCatList,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTapFunction != null ? () => onTapFunction!() : () {},
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  if (!multiSelection) 
                  BoxShadow(
                    blurRadius: selectedCatID == '${categoryItem.id}' ? 5 : 5,
                    color: selectedCatID == '${categoryItem.id}'
                        ? categoryItem.color!.withOpacity(0.2)
                        : categoryItem.color!.withOpacity(0.05),
                    spreadRadius: selectedCatID == '${categoryItem.id}' ? 2 : 1,
                  )
                  else if (multiSelection)
                  BoxShadow(
                    blurRadius: selectedCatList!.contains(categoryItem) ? 5 : 5,
                    color: selectedCatList!.contains(categoryItem)
                        ? categoryItem.color!.withOpacity(0.2)
                        : categoryItem.color!.withOpacity(0.05),
                    spreadRadius: selectedCatList!.contains(categoryItem) ? 2 : 1,
                  )
                ],
              ),
              // width: 60,
              // height: 60,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Image.asset(categoryItem.symbol!, color: categoryItem.color!),
              ),
            ),
          ),
        ),
        Center(
          // child: SingleChildScrollView( //---> Alternative zu den drei Punkten
          //   scrollDirection: Axis.horizontal,
          child: Text(
            '${categoryItem.title}',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            softWrap: false,
            style: TextStyle(
                fontSize: 14, fontWeight: FontWeight.bold, color: categoryItem.color),
            textAlign: TextAlign.center,
          ),
          // ),
        ),
      ],
    );
  }
}
