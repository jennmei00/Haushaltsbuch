import 'package:flutter/material.dart';
import 'package:haushaltsbuch/models/category.dart';
import 'package:haushaltsbuch/services/help_methods.dart';

class CategoryItem extends StatelessWidget {
  final Category categoryItem;
  final Function? onTapFunction;
  final String? selectedCatID;
  final bool multiSelection;
  final List<Category>? selectedCatList;
  final bool disabled;

  CategoryItem({
    required this.categoryItem,
    this.onTapFunction,
    this.selectedCatID,
    this.multiSelection: false,
    this.selectedCatList,
    this.disabled: false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTapFunction != null ? () => onTapFunction!() : () {},
          child: Padding(
            padding: const EdgeInsets.all(6.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: multiSelection
                      ? (selectedCatList!.contains(categoryItem)
                          ? getColor(categoryItem.color!)
                          : Colors.transparent)
                      : (selectedCatID == '${categoryItem.id}'
                          ? getColor(categoryItem.color!)
                          : Colors.transparent),
                ),
                color: disabled
                    ? Colors.transparent
                    : multiSelection
                        ? (selectedCatList!.contains(categoryItem)
                            ? getColor(categoryItem.color!).withOpacity(0.25)
                            : getColor(categoryItem.color!).withOpacity(0.08))
                        : (selectedCatID == '${categoryItem.id}'
                            ? getColor(categoryItem.color!).withOpacity(0.25)
                            : getColor(categoryItem.color!).withOpacity(0.08)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Image.asset(categoryItem.symbol!,
                    color:
                        disabled ? Colors.grey : getColor(categoryItem.color!)),
              ),
            ),
          ),
        ),
        Center(
          child: Text(
            '${categoryItem.title}',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            softWrap: false,
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: disabled ? Colors.grey : getColor(categoryItem.color!)),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
