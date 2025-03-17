import 'package:flutter/material.dart';

class TaskCard extends StatelessWidget {
  const TaskCard({
    super.key,
    required String status,
    required Color color,
    }) : _status = status,
        _color = color;

  final String _status;
  final Color _color;

  @override
  Widget build(BuildContext context) {

    TextTheme textTheme = Theme.of(context).textTheme;

    return Card(
      elevation: 0,
      color: Colors.white,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Tittle will show here...', style: textTheme.titleLarge,),
            Text('Description will show here...', style: textTheme.bodyLarge,),
            Text('Date time will show here...'),
            Row(
              children: [
                Chip(
                  label: Text(_status, style: TextStyle(
                      color: Colors.white
                  ),),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  backgroundColor: _color,
                  side: BorderSide.none,
                ),
                const Spacer(),
                IconButton(onPressed: (){}, icon: Icon(Icons.edit, color: Colors.green,)),
                IconButton(onPressed: (){}, icon: Icon(Icons.delete, color: Colors.redAccent,)),
              ],
            )
          ],
        ),
      ),
    );
  }
}