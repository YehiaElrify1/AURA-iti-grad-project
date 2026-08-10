// lib/app/features/person_details/view/widgets/person_image_grid.dart
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:iti_grad_proj/app/core/constants/app_spacing.dart';
import 'package:iti_grad_proj/app/core/routing/app_router.dart';
import 'package:iti_grad_proj/app/features/person_details/data/models/person_image_model.dart';
import 'package:shimmer/shimmer.dart';

class PersonImageGrid extends StatelessWidget {
  final List<PersonImageModel> images;

  const PersonImageGrid({super.key, required this.images});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: AppSpacing.h8,
        mainAxisSpacing: AppSpacing.v8,
        childAspectRatio: 0.7,
      ),
      itemCount: images.length,
      itemBuilder: (context, index) {
        final image = images[index];
        final tag = 'person-image-${image.filePath}';
        return GestureDetector(
          onTap: () => context.push(
            AppRouter.imageViewer,
            extra: {'imageUrl': image.originalUrl, 'heroTag': tag},
          ),
          child: Hero(
            tag: tag,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.sm),
              child: CachedNetworkImage(
                imageUrl: image.thumbnailUrl,
                fit: BoxFit.cover,
                placeholder: (_, _) => Shimmer.fromColors(
                  baseColor: Colors.grey.shade300,
                  highlightColor: Colors.grey.shade100,
                  child: Container(color: Colors.grey.shade300),
                ),
                errorWidget: (_, _, _) => Container(
                  color: Colors.grey.shade200,
                  child: Icon(Icons.broken_image_rounded,
                      color: Colors.grey.shade500, size: 24.sp),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
