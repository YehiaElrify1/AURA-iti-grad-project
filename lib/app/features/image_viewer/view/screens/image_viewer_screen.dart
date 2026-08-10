// lib/app/features/image_viewer/view/screens/image_viewer_screen.dart
import 'dart:io';
import 'dart:typed_data';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:gal/gal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_view/photo_view.dart';
import 'package:iti_grad_proj/app/core/constants/app_strings.dart';

class ImageViewerScreen extends StatefulWidget {
  final String imageUrl;
  final String heroTag;

  const ImageViewerScreen({
    super.key,
    required this.imageUrl,
    required this.heroTag,
  });

  @override
  State<ImageViewerScreen> createState() => _ImageViewerScreenState();
}

class _ImageViewerScreenState extends State<ImageViewerScreen> {
  bool _downloading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.black.withValues(alpha: 0.4),
        foregroundColor: Colors.white,
        elevation: 0,
        title: Text(
          AppStrings.imageViewerTitle,
          style: TextStyle(color: Colors.white, fontSize: 16.sp),
        ),
      ),
      body: Hero(
        tag: widget.heroTag,
        child: PhotoView(
          imageProvider: CachedNetworkImageProvider(widget.imageUrl),
          minScale: PhotoViewComputedScale.contained,
          maxScale: PhotoViewComputedScale.covered * 3,
          backgroundDecoration:
              const BoxDecoration(color: Colors.black),
          loadingBuilder: (_, event) => Center(
            child: CircularProgressIndicator(
              value: event == null
                  ? null
                  : event.cumulativeBytesLoaded /
                      (event.expectedTotalBytes ?? 1),
              color: Colors.white,
            ),
          ),
        ),
      ),
      floatingActionButton: _downloading
          ? FloatingActionButton(
              onPressed: null,
              backgroundColor: Colors.white24,
              child: const CircularProgressIndicator(
                  color: Colors.white, strokeWidth: 2),
            )
          : FloatingActionButton(
              onPressed: _downloadImage,
              backgroundColor: Colors.white.withValues(alpha: 0.15),
              tooltip: 'Save to Gallery',
              child: const Icon(Icons.download_rounded, color: Colors.white),
            ),
    );
  }

  Future<void> _downloadImage() async {
    // Request storage permission
    PermissionStatus status;
    if (Platform.isAndroid) {
      status = await Permission.storage.request();
      if (!status.isGranted) {
        _showSnack(AppStrings.permissionDenied, isError: true);
        return;
      }
    }

    setState(() => _downloading = true);

    try {
      // 1. Fetch image bytes using Dio
      final response = await Dio().get(
        widget.imageUrl,
        options: Options(responseType: ResponseType.bytes),
      );

      // 2. Save image directly to the gallery using 'gal' package
      await Gal.putImageBytes(
        Uint8List.fromList(response.data),
        name: 'aura_${DateTime.now().millisecondsSinceEpoch}',
      );

      if (mounted) _showSnack(AppStrings.downloadSuccess);
    } catch (e) {
      if (mounted) _showSnack(AppStrings.downloadError, isError: true);
    } finally {
      if (mounted) setState(() => _downloading = false);
    }
  }

  void _showSnack(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red.shade700 : Colors.green.shade700,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.r)),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
