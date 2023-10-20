import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:insta_assets_crop/insta_assets_crop.dart';
import 'package:pet_mobile_social_flutter/common/library/insta_assets_picker/insta_assets_crop_controller.dart';
import 'package:pet_mobile_social_flutter/common/library/wechat_assets_picker/delegates/asset_picker_text_delegate.dart';
import 'package:pet_mobile_social_flutter/common/library/wechat_assets_picker/provider/asset_picker_provider.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:provider/provider.dart';

class CropViewer extends StatefulWidget {
  const CropViewer({
    super.key,
    required this.provider,
    required this.textDelegate,
    required this.controller,
    required this.loaderWidget,
    required this.height,
    this.opacity = 1.0,
    this.theme,
  });

  final DefaultAssetPickerProvider provider;

  final AssetPickerTextDelegate textDelegate;

  final InstaAssetsCropController controller;

  final Widget loaderWidget;

  final double opacity;

  final double height;

  final ThemeData? theme;

  @override
  State<CropViewer> createState() => CropViewerState();
}

class CropViewerState extends State<CropViewer> {
  final _cropKey = GlobalKey<CropState>();
  AssetEntity? _previousAsset;
  final ValueNotifier<bool> _isLoadingError = ValueNotifier<bool>(false);

  @override
  void dispose() {
    _isLoadingError.dispose();
    super.dispose();
  }

  /// Save the crop parameters state in [InstaAssetsCropController]
  /// to retrieve it if the asset is opened again
  /// and apply them at the exportation
  Future<void> saveCurrentCropChanges() async {
    widget.controller.onChange(
      _previousAsset,
      _cropKey.currentState,
      widget.provider.selectedAssets,
    );
  }

  /// Returns the [Crop] widget
  Widget _buildCropView(AssetEntity asset, CropInternal? cropParam) {
    return Opacity(
      opacity: widget.controller.isCropViewReady.value ? widget.opacity : 1.0,
      child: Crop(
        key: _cropKey,
        image: AssetEntityImageProvider(asset, isOriginal: true),
        placeholderWidget: ValueListenableBuilder<bool>(
          valueListenable: _isLoadingError,
          builder: (context, isLoadingError, child) => Stack(
            alignment: Alignment.center,
            children: [
              Opacity(
                opacity: widget.opacity,
                child: ExtendedImage(
                  // to match crop alignment
                  alignment: widget.controller.aspectRatio == 1.0 ? Alignment.center : Alignment.bottomCenter,
                  height: widget.height,
                  width: widget.height * widget.controller.aspectRatio,
                  image: AssetEntityImageProvider(asset, isOriginal: false),
                  enableMemoryCache: false,
                  fit: BoxFit.cover,
                ),
              ),
              // show backdrop when image is loading or if an error occured
              Positioned.fill(
                  child: DecoratedBox(
                decoration: BoxDecoration(color: widget.theme?.cardColor.withOpacity(0.4)),
              )),
              isLoadingError ? Text(widget.textDelegate.loadFailed) : widget.loaderWidget,
            ],
          ),
        ),
        // if the image could not be loaded (i.e unsupported format like RAW)
        // unselect it and clear cache, also show the error widget
        onImageError: (exception, stackTrace) {
          widget.provider.unSelectAsset(asset);
          AssetEntityImageProvider(asset).evict();
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _isLoadingError.value = true;
            widget.controller.isCropViewReady.value = true;
          });
        },
        onLoading: (isReady) => WidgetsBinding.instance.addPostFrameCallback((_) => widget.controller.isCropViewReady.value = isReady),
        maximumScale: 10,
        aspectRatio: widget.controller.aspectRatio,
        disableResize: true,
        backgroundColor: widget.theme!.canvasColor,
        // initialParam: cropParam,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      width: MediaQuery.of(context).size.width,
      child: ValueListenableBuilder<AssetEntity?>(
        valueListenable: widget.controller.previewAsset,
        builder: (_, previewAsset, __) => Selector<DefaultAssetPickerProvider, List<AssetEntity>>(
            selector: (_, DefaultAssetPickerProvider p) => p.selectedAssets,
            builder: (_, List<AssetEntity> selected, __) {
              _isLoadingError.value = false;
              final int effectiveIndex = selected.isEmpty ? 0 : selected.indexOf(selected.last);

              // if no asset is selected yet, returns the loader
              if (previewAsset == null && selected.isEmpty) {
                return widget.loaderWidget;
              }

              final asset = previewAsset ?? selected[effectiveIndex];
              final savedCropParam = widget.controller.get(asset)?.cropParam;

              // if the selected asset changed, save the previous crop parameters state
              if (asset != _previousAsset && _previousAsset != null) {
                saveCurrentCropChanges();
              }

              _previousAsset = asset;

              return ValueListenableBuilder<int>(
                valueListenable: widget.controller.cropRatioIndex,
                builder: (context, index, child) => Stack(
                  children: [
                    Positioned.fill(
                      child: _buildCropView(asset, savedCropParam),
                    ),
                  ],
                ),
              );
            }),
      ),
    );
  }
}
