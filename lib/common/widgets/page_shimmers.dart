import 'package:flutter/material.dart';
import 'package:garden_ui/ui/design_system.dart';
import 'package:shimmer/shimmer.dart';

class HomePageShimmer extends StatelessWidget {
  final bool mobile;

  const HomePageShimmer({super.key, this.mobile = false});

  @override
  Widget build(BuildContext context) {
    return _ShimmerSurface(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(GardenSpace.paddingMd),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _ShimmerBlock(
              width: mobile ? 180 : 240,
              height: 32,
              radius: GardenRadius.radiusSm,
            ),
            SizedBox(height: GardenSpace.gapMd),
            _ShimmerGrid(
              itemCount: mobile ? 2 : 4,
              maxCrossAxisExtent: mobile ? 200 : 220,
              itemHeight: mobile ? 90 : 110,
            ),
            SizedBox(height: GardenSpace.gapMd),
            _ShimmerSectionCard(
              itemCount: mobile ? 1 : 2,
              itemHeight: 150,
              maxCrossAxisExtent: mobile ? 320 : 320,
            ),
            SizedBox(height: GardenSpace.gapMd),
            _ShimmerSectionCard(
              itemCount: mobile ? 1 : 2,
              itemHeight: 170,
              maxCrossAxisExtent: mobile ? 320 : 320,
            ),
            SizedBox(height: GardenSpace.gapMd),
            _ShimmerSectionCard(
              itemCount: mobile ? 2 : 4,
              itemHeight: 190,
              maxCrossAxisExtent: mobile ? 210 : 260,
            ),
          ],
        ),
      ),
    );
  }
}

class AreasPageShimmer extends StatelessWidget {
  final bool mobile;

  const AreasPageShimmer({super.key, this.mobile = false});

  @override
  Widget build(BuildContext context) {
    return _ShimmerSurface(
      child: Padding(
        padding: EdgeInsets.all(GardenSpace.paddingMd),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _ShimmerBlock(
              width: mobile ? 160 : 220,
              height: 32,
              radius: GardenRadius.radiusSm,
            ),
            SizedBox(height: GardenSpace.gapMd),
            Expanded(
              child:
                  mobile
                      ? _ShimmerSectionCard(
                        itemCount: 6,
                        itemHeight: 22,
                        maxCrossAxisExtent: 500,
                        showSectionHeader: false,
                      )
                      : Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 1,
                            child: _ShimmerSectionCard(
                              itemCount: 10,
                              itemHeight: 20,
                              maxCrossAxisExtent: 500,
                              showSectionHeader: false,
                            ),
                          ),
                          SizedBox(width: GardenSpace.gapMd),
                          Expanded(
                            flex: 2,
                            child: _ShimmerSectionCard(
                              itemCount: 1,
                              itemHeight: 340,
                              maxCrossAxisExtent: 1000,
                            ),
                          ),
                        ],
                      ),
            ),
          ],
        ),
      ),
    );
  }
}

class CellsPageShimmer extends StatelessWidget {
  final bool mobile;

  const CellsPageShimmer({super.key, this.mobile = false});

  @override
  Widget build(BuildContext context) {
    return _ShimmerSurface(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: GardenSpace.paddingLg,
          vertical: GardenSpace.paddingMd,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _ShimmerHeader(titleWidth: mobile ? 160 : 200, actionCount: 2),
            SizedBox(height: GardenSpace.gapMd),
            Row(
              children: [
                if (!mobile)
                  Expanded(
                    flex: 1,
                    child: _ShimmerBlock(
                      height: 52,
                      radius: GardenRadius.radiusMd,
                    ),
                  ),
                if (!mobile) SizedBox(width: GardenSpace.gapSm),
                Expanded(
                  flex: 3,
                  child: _ShimmerBlock(
                    height: 52,
                    radius: GardenRadius.radiusMd,
                  ),
                ),
              ],
            ),
            SizedBox(height: GardenSpace.gapMd),
            _ShimmerBlock(
              width: mobile ? 130 : 160,
              height: 24,
              radius: GardenRadius.radiusSm,
            ),
            SizedBox(height: GardenSpace.gapMd),
            Expanded(
              child: _ShimmerGrid(
                itemCount: mobile ? 4 : 6,
                maxCrossAxisExtent: mobile ? 380 : 320,
                itemHeight: mobile ? 95 : 180,
                useScroll: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AlertsPageShimmer extends StatelessWidget {
  final bool mobile;

  const AlertsPageShimmer({super.key, this.mobile = false});

  @override
  Widget build(BuildContext context) {
    return _ShimmerSurface(
      child: Padding(
        padding: EdgeInsets.all(GardenSpace.paddingMd),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _ShimmerHeader(titleWidth: mobile ? 180 : 240, actionCount: 2),
            SizedBox(height: GardenSpace.gapMd),
            Row(
              children: [
                Expanded(
                  child: _ShimmerBlock(
                    height: 48,
                    radius: GardenRadius.radiusMd,
                  ),
                ),
                if (mobile) SizedBox(width: GardenSpace.gapMd),
                if (mobile)
                  _ShimmerCircle(size: 40, radius: GardenRadius.radiusLg),
              ],
            ),
            SizedBox(height: GardenSpace.gapMd),
            _ShimmerBlock(height: 42, radius: GardenRadius.radiusMd),
            SizedBox(height: GardenSpace.gapMd),
            Expanded(child: AlertsContentShimmer(mobile: mobile)),
          ],
        ),
      ),
    );
  }
}

class AlertsContentShimmer extends StatelessWidget {
  final bool mobile;

  const AlertsContentShimmer({super.key, this.mobile = false});

  @override
  Widget build(BuildContext context) {
    return _ShimmerGrid(
      itemCount: mobile ? 5 : 7,
      maxCrossAxisExtent: 1000,
      itemHeight: mobile ? 92 : 84,
      useScroll: true,
    );
  }
}

class _ShimmerSurface extends StatelessWidget {
  final Widget child;

  const _ShimmerSurface({required this.child});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: GardenColors.base.shade200.withValues(alpha: 0.45),
      highlightColor: GardenColors.base.shade50.withValues(alpha: 0.85),
      period: const Duration(milliseconds: 1250),
      child: child,
    );
  }
}

class _ShimmerHeader extends StatelessWidget {
  final double titleWidth;
  final int actionCount;

  const _ShimmerHeader({required this.titleWidth, required this.actionCount});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _ShimmerBlock(
          width: titleWidth,
          height: 32,
          radius: GardenRadius.radiusSm,
        ),
        const Spacer(),
        ...List.generate(actionCount, (index) {
          return Padding(
            padding: EdgeInsets.only(left: GardenSpace.gapSm),
            child: _ShimmerCircle(size: 40, radius: GardenRadius.radiusSm),
          );
        }),
      ],
    );
  }
}

class _ShimmerSectionCard extends StatelessWidget {
  final int itemCount;
  final double itemHeight;
  final double maxCrossAxisExtent;
  final bool showSectionHeader;

  const _ShimmerSectionCard({
    required this.itemCount,
    required this.itemHeight,
    required this.maxCrossAxisExtent,
    this.showSectionHeader = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(GardenSpace.paddingMd),
      decoration: BoxDecoration(
        color: GardenColors.base.shade100,
        borderRadius: GardenRadius.radiusLg,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (showSectionHeader)
            _ShimmerBlock(
              width: 210,
              height: 18,
              radius: GardenRadius.radiusSm,
            ),
          if (showSectionHeader) SizedBox(height: GardenSpace.gapMd),
          _ShimmerGrid(
            itemCount: itemCount,
            maxCrossAxisExtent: maxCrossAxisExtent,
            itemHeight: itemHeight,
            useScroll: false,
          ),
        ],
      ),
    );
  }
}

class _ShimmerGrid extends StatelessWidget {
  final int itemCount;
  final double maxCrossAxisExtent;
  final double itemHeight;
  final bool useScroll;

  const _ShimmerGrid({
    required this.itemCount,
    required this.maxCrossAxisExtent,
    required this.itemHeight,
    this.useScroll = false,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: itemCount,
      shrinkWrap: true,
      physics:
          useScroll
              ? const BouncingScrollPhysics()
              : const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: maxCrossAxisExtent,
        mainAxisExtent: itemHeight,
        mainAxisSpacing: GardenSpace.gapMd,
        crossAxisSpacing: GardenSpace.gapMd,
      ),
      itemBuilder:
          (context, index) =>
              _ShimmerBlock(height: itemHeight, radius: GardenRadius.radiusMd),
    );
  }
}

class _ShimmerBlock extends StatelessWidget {
  final double? width;
  final double height;
  final BorderRadiusGeometry? radius;

  const _ShimmerBlock({this.width, required this.height, this.radius});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: GardenColors.base.shade100,
        borderRadius: radius ?? GardenRadius.radiusSm,
      ),
    );
  }
}

class _ShimmerCircle extends StatelessWidget {
  final double size;
  final BorderRadiusGeometry? radius;

  const _ShimmerCircle({required this.size, this.radius});

  @override
  Widget build(BuildContext context) {
    return _ShimmerBlock(width: size, height: size, radius: radius);
  }
}
