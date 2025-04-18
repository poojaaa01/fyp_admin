import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:fyp_admin/models/doc_type.dart';
import 'package:fyp_admin/widgets/subtitle_text.dart';
import 'package:provider/provider.dart';
import '../../providers/doc_provider.dart';
import 'title_text.dart';

class DocWidget extends StatefulWidget {
  const DocWidget({
    super.key, required this.docId,
  });


  final String docId;
  @override
  State<DocWidget> createState() => _DocWidgetState();
}

class _DocWidgetState extends State<DocWidget> {
  @override
  Widget build(BuildContext context) {
    //final doctorTypeProvider = Provider.of<DoctorType>(context);
    final docProvider = Provider.of<DocProvider>(context);
    final getCurrDoctor = docProvider.findByDocId(widget.docId);
    Size size = MediaQuery.of(context).size;

    return getCurrDoctor == null
        ? const SizedBox.shrink()
        :Padding(
      padding: const EdgeInsets.all(0.0),
      child: GestureDetector(
        onTap: () {},
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12.0),
              child: FancyShimmerImage(
                imageUrl: getCurrDoctor.docImage,
                height: size.height * 0.22,
                width: double.infinity,
              ),
            ),
            const SizedBox(height: 12.0),
            Padding(
              padding: const EdgeInsets.all(2.0),
              child: Row(
                children: [
                  Flexible(
                    flex: 5,
                    child: TitlesTextWidget(
                      label: getCurrDoctor.docTitle,
                      fontSize: 18,
                      maxLines: 2,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 6.0),
            Padding(
              padding: const EdgeInsets.all(2.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    flex: 1,
                    child: SubtitleTextWidget(
                      label: "${getCurrDoctor.docPrice}",
                      fontWeight: FontWeight.w600,
                      color: Colors.blueAccent,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12.0),
          ],
        ),
      ),
    );
  }
}
