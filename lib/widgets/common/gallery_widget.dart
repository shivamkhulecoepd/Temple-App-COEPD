import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:temple_app/widgets/translated_text.dart';

class GalleryWidget extends StatefulWidget {
  final String? title;
  const GalleryWidget({super.key, this.title});

  @override
  State<GalleryWidget> createState() => _GalleryWidgetState();
}

class _GalleryWidgetState extends State<GalleryWidget> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(child: _buildGallerySection(widget.title)),
    );
  }

  // 8. GALLERY SECTION
  Widget _buildGallerySection(String? title) {
    return Column(
      children: [
        if (title != null)
          TranslatedText(
            title,
            style: TextStyle(
              fontFamily: 'aBeeZee',
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).textTheme.titleLarge?.color,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        Padding(
          padding: const EdgeInsets.all(10),
          child: Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _galleryImage('assets/images/dashboard/gallery1.jpg'),
              _galleryImage('assets/images/dashboard/gallery2.jpg'),
              _galleryImage('assets/images/dashboard/gallery3.jpg'),
              _galleryImage('assets/images/dashboard/gallery4.jpg'),
              _galleryImage('assets/images/dashboard/gallery5.jpg'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _galleryImage(String path) {
    // return ClipRRect(
    //   borderRadius: BorderRadius.circular(8),
    //   child: Image.asset(path, width: 100, height: 100, fit: BoxFit.cover),
    // );
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Theme.of(context).cardTheme.color,
        border: Border.all(color: Colors.white, width: 3),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.asset(path, width: 100, height: 100, fit: BoxFit.cover),
      ),
    );
  }
}
