import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PhotoPicker extends StatelessWidget {

  final VoidCallback onTap;
  final XFile? selectedPhoto;

  const PhotoPicker({
    super.key,
    required this.onTap,
    required this.selectedPhoto,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.maxFinite,
        height: 50,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5)
        ),
        child: Row(
          children: [
            Container(
              width: 80,
              height: 50,
              alignment: .center,
              decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(10), bottomLeft: Radius.circular(10))
              ),
              child: const Text('Photo',style: TextStyle(color: Colors.white)),
            ),
            Text(selectedPhoto == null ? 'No photo selected' : selectedPhoto!.name,
              style: TextStyle( overflow: TextOverflow.ellipsis),
              maxLines: 2,
              softWrap: true,
            ),
          ],
        ),
      ),
    );
  }
}