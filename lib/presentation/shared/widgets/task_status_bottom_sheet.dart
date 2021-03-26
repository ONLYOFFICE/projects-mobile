import 'package:flutter/material.dart';
import 'package:projects/presentation/shared/custom_theme.dart';
import 'package:projects/presentation/shared/text_styles.dart';

class BottomSheet extends StatelessWidget {

  final String title;
  const BottomSheet({
    Key key,
    this.title
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Container(
      height: 464,
      decoration: BoxDecoration(
        color: Theme.of(context).customColors().onPrimarySurface,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 18.5),
              child: SizedBox(
                height: 4,
                width: 40,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: Theme.of(context).customColors().onSurface.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(2)
                  ),
                ),
              ),
            ),
          ),
          if (title != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                title,
                style: TextStyleHelper.h6,
              ),
            ),
          const SizedBox(height: 14.5),
          Divider(height: 9),
          StatusTile(
            icon: Icon(Icons.ac_unit),
            selected: true,
            title: 'Задача создана',  
          ),
          StatusTile(
            icon: Icon(Icons.ac_unit),
            title: 'Задача назначена',
            selected: false, 
          ),
          StatusTile(
            icon: Icon(Icons.ac_unit),
            title: 'Задача открыта',
          ),
          StatusTile(
            icon: Icon(Icons.ac_unit),
            title: 'Задача на паузе',
          ),
          StatusTile(
            icon: Icon(Icons.ac_unit),
            title: 'Задача выполнена',
          ),
          StatusTile(
            icon: Icon(Icons.ac_unit),
            title: 'Задача завершена',
          ),
          StatusTile(
            icon: Icon(Icons.ac_unit),
            title: 'Задача на подтверждении',
          ),
          StatusTile(
            icon: Icon(Icons.ac_unit),
            title: 'Задача отменена',
          ),
        ],
      ),
    );
  }
}


class StatusTile extends StatelessWidget {

  final String title;
  final Widget icon;
  final bool selected;

  const StatusTile({
    Key key,
    this.icon,
    this.title,
    this.selected = false
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {


    BoxDecoration _selectedDecoration(){

      return BoxDecoration(
        color: Theme.of(context).customColors().bgDescription,
        borderRadius: BorderRadius.circular(6)
      );

    }
    return Container(
      height: 40,
      margin: const EdgeInsets.only(left: 8, right: 8, bottom: 4),
      decoration: selected
          ? _selectedDecoration() 
          : null,
      child: Stack(
        children: [
          Positioned(
            left: 15,
            top: 10,
            bottom: 10,
            child: icon
          ),
          Positioned(
            left: 48,
            top: 10,
            bottom: 10,
            child: Text(title, style: TextStyleHelper.body2)),
          if (selected)
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 15),
                child: Icon(
                  Icons.done_rounded,
                  color: Theme.of(context).customColors().primary,
                ),
              ),
            )
        ],
      ),
    );
  }
}