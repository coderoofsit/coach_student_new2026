import 'package:flutter/material.dart';
import '../core/app_export.dart';

/// A collection of pre-defined text styles for customizing text appearance,
/// categorized by different font families and weights.
/// Additionally, this class includes extensions on [TextStyle] to easily apply specific font families to text.

class CustomTextStyles {
  static get titleMediumOnError => theme.textTheme.titleMedium!.copyWith(
        color: theme.colorScheme.onError,
        fontWeight: FontWeight.w600,
      );
  static get titleMediumBlack900SemiBold_3 =>
      theme.textTheme.titleMedium!.copyWith(
        color: appTheme.black900.withOpacity(0.75),
        fontWeight: FontWeight.w600,
      );
  static get titleMediumSemiBold => theme.textTheme.titleMedium!.copyWith(
        fontWeight: FontWeight.w600,
      );
  static get titleMediumWhiteA700SemiBold_1 =>
      theme.textTheme.titleMedium!.copyWith(
        color: appTheme.whiteA700,
        fontWeight: FontWeight.w600,
      );
  // Body text style
  static get bodyLargeBlack900 => theme.textTheme.bodyLarge!.copyWith(
        color: appTheme.black900.withOpacity(0.5),
      );
  static get titleMediumBlack900SemiBold_2 =>
      theme.textTheme.titleMedium!.copyWith(
        color: appTheme.black900.withOpacity(0.75),
        fontWeight: FontWeight.w600,
      );
  static get titleSmallBlack900_3 => theme.textTheme.titleSmall!.copyWith(
        color: appTheme.black900,
      );
  static get titleSmallBlack900_4 => theme.textTheme.titleSmall!.copyWith(
        color: appTheme.black900.withOpacity(0.4),
      );
  static get titleMedium18 => theme.textTheme.titleMedium!.copyWith(
        fontSize: 18.fSize,
      );
  static get titleMediumPrimary_1 => theme.textTheme.titleMedium!.copyWith(
        color: theme.colorScheme.primary,
      );
  static get bodySmallBlack90010 => theme.textTheme.bodySmall!.copyWith(
        color: appTheme.black900.withOpacity(0.9),
        fontSize: 10.fSize,
      );
  static get labelLargeBlack90013_1 => theme.textTheme.labelLarge!.copyWith(
        color: appTheme.black900.withOpacity(0.4),
        fontSize: 13.fSize,
      );
  static get titleMediumGray80001 => theme.textTheme.titleMedium!.copyWith(
        color: appTheme.gray80001,
      );
  static get labelLargeGray80001 => theme.textTheme.labelLarge!.copyWith(
        color: appTheme.gray80001,
        fontSize: 13.fSize,
      );
  static get titleMediumPrimarySemiBold_1 =>
      theme.textTheme.titleMedium!.copyWith(
        color: theme.colorScheme.primary,
        fontWeight: FontWeight.w600,
      );
  static get labelLargeGray8000113 => theme.textTheme.labelLarge!.copyWith(
        color: appTheme.gray80001,
        fontSize: 13.fSize,
      );
  static get titleSmallGray500 => theme.textTheme.titleSmall!.copyWith(
        color: appTheme.gray600,
      );
  static get titleMediumBlack900SemiBold =>
      theme.textTheme.titleMedium!.copyWith(
        color: appTheme.black900,
        fontWeight: FontWeight.w600,
      );
  static get titleMediumGray900 => theme.textTheme.titleMedium!.copyWith(
        color: appTheme.gray900.withOpacity(0.6),
        fontWeight: FontWeight.w600,
      );
  static get titleSmallBlack900Bold => theme.textTheme.titleSmall!.copyWith(
        color: appTheme.black900.withOpacity(0.8),
        fontWeight: FontWeight.w700,
      );

  static get titleLargeBlack900 => theme.textTheme.titleLarge!.copyWith(
        color: appTheme.black900,
        fontWeight: FontWeight.w700,
      );
  static get titleLargeBold => theme.textTheme.titleLarge!.copyWith(
        fontWeight: FontWeight.w700,
      );
  static get titleSmallBlack900_2 => theme.textTheme.titleSmall!.copyWith(
        color: appTheme.black900.withOpacity(0.8),
      );
  static get titleMediumBlack900SemiBold18 =>
      theme.textTheme.titleMedium!.copyWith(
        color: appTheme.black900,
        fontSize: 18.fSize,
        fontWeight: FontWeight.w600,
      );

  static get studentScreenHeadline => theme.textTheme.bodyLarge!.copyWith(
      color: ColorSchemes.primaryColorScheme.primary,
      fontSize: 20.fSize,
      fontFamily: 'Nunito Sans',
      fontWeight: FontWeight.w700);
  static get titleLargeBlack900Bold => theme.textTheme.titleLarge!.copyWith(
        color: appTheme.black900,
        fontWeight: FontWeight.w700,
      );
  static get bodyLargeBlack900_1 => theme.textTheme.bodyLarge!.copyWith(
        color: appTheme.black900.withOpacity(0.4),
      );
  static get bodyLargeBlack900_2 => theme.textTheme.bodyLarge!.copyWith(
        color: appTheme.black900,
      );
  static get bodyLargeBlack900_3 => theme.textTheme.bodyLarge!.copyWith(
        color: appTheme.black900.withOpacity(0.5),
      );
  static get bodyLargeLato => theme.textTheme.bodyLarge!.lato.copyWith(
        fontSize: 17.fSize,
      );
  static get bodyLargePrimary => theme.textTheme.bodyLarge!.copyWith(
        color: theme.colorScheme.primary,
        fontSize: 18.fSize,
      );
  static get bodyMediumBlack900 => theme.textTheme.bodyMedium!.copyWith(
        color: appTheme.black900.withOpacity(0.75),
      );
  static get bodySmallBlack900 => theme.textTheme.bodySmall!.copyWith(
        color: appTheme.black900.withOpacity(0.6),
        fontSize: 10.fSize,
      );
  // Display text style
  static get displayMediumPublicSans =>
      theme.textTheme.displayMedium!.publicSans.copyWith(
        fontWeight: FontWeight.w400,
      );
  static get displayMediumPublicSansYellowA400 =>
      theme.textTheme.displayMedium!.publicSans.copyWith(
        color: appTheme.yellowA400,
        fontWeight: FontWeight.w700,
      );
  static get displaySmallPublicSans =>
      theme.textTheme.displaySmall!.publicSans.copyWith(
        fontWeight: FontWeight.w400,
      );
  static get displaySmallPublicSansYellowA400 =>
      theme.textTheme.displaySmall!.publicSans.copyWith(
        color: appTheme.yellowA400,
        fontWeight: FontWeight.w700,
      );
  // Headline text style
  static get headlineSmallNotoSansOnErrorContainer =>
      theme.textTheme.headlineSmall!.notoSans.copyWith(
        color: theme.colorScheme.onErrorContainer.withOpacity(1),
        fontWeight: FontWeight.w600,
      );
  static get headlineSmallOnErrorContainer =>
      theme.textTheme.headlineSmall!.copyWith(
        color: theme.colorScheme.onErrorContainer.withOpacity(1),
        fontWeight: FontWeight.w600,
      );
  static get headlineSmallPublicSansOnErrorContainer =>
      theme.textTheme.headlineSmall!.publicSans.copyWith(
        color: theme.colorScheme.onErrorContainer.withOpacity(1),
        fontWeight: FontWeight.w300,
      );
  static get headlineSmallPublicSansYellowA400 =>
      theme.textTheme.headlineSmall!.publicSans
          .copyWith(color: appTheme.yellowA400, fontSize: 18);
  // Label text style
  static get labelLargeBlack900 => theme.textTheme.labelLarge!.copyWith(
        color: appTheme.black900,
        fontSize: 13.fSize,
      );
  static get labelLargeBlack90013 => theme.textTheme.labelLarge!.copyWith(
        color: appTheme.black900.withOpacity(0.4),
        fontSize: 13.fSize,
      );
  static get labelLargeBlack900_1 => theme.textTheme.labelLarge!.copyWith(
        color: appTheme.black900.withOpacity(0.4),
      );
  static get labelLargeBlack900_2 => theme.textTheme.labelLarge!.copyWith(
        color: appTheme.black900.withOpacity(0.5),
      );
  static get labelLargeBold => theme.textTheme.labelLarge!.copyWith(
        fontSize: 13.fSize,
        fontWeight: FontWeight.w700,
      );
  static get labelLargeBold_1 => theme.textTheme.labelLarge!.copyWith(
        fontWeight: FontWeight.w700,
      );
  static get labelLargeGray800 => theme.textTheme.labelLarge!.copyWith(
        color: appTheme.gray800,
        fontSize: 13.fSize,
      );
  static get labelLargeGray80013 => theme.textTheme.labelLarge!.copyWith(
        color: appTheme.gray800,
        fontSize: 13.fSize,
      );
  static get labelLargeMontserratBlack900 =>
      theme.textTheme.labelLarge!.montserrat.copyWith(
        color: appTheme.black900,
        fontSize: 13.fSize,
        fontWeight: FontWeight.w500,
      );
  static get labelLargePrimary => theme.textTheme.labelLarge!.copyWith(
        color: theme.colorScheme.primary,
        fontWeight: FontWeight.w700,
      );
  static get labelLargeRobotoBlack900 =>
      theme.textTheme.labelLarge!.roboto.copyWith(
        color: appTheme.black900.withOpacity(0.8),
        fontSize: 13.fSize,
        fontWeight: FontWeight.w500,
      );
  static get labelLargeRobotoOnErrorContainer =>
      theme.textTheme.labelLarge!.roboto.copyWith(
        color: theme.colorScheme.onErrorContainer.withOpacity(1),
        fontSize: 13.fSize,
        fontWeight: FontWeight.w500,
      );
  static get labelLargeRobotoPrimary =>
      theme.textTheme.labelLarge!.roboto.copyWith(
        color: theme.colorScheme.primary,
        fontSize: 13.fSize,
        fontWeight: FontWeight.w500,
      );
  static get labelLargeSecondaryContainer =>
      theme.textTheme.labelLarge!.copyWith(
        color: theme.colorScheme.secondaryContainer,
        fontWeight: FontWeight.w700,
      );
  static get labelLarge_1 => theme.textTheme.labelLarge!;
  // Title text style
  static get titleLargeGray900 => theme.textTheme.titleLarge!.copyWith(
        color: appTheme.gray900,
        fontWeight: FontWeight.w600,
      );
  static get titleLargeOnErrorContainer => theme.textTheme.titleLarge!.copyWith(
        color: theme.colorScheme.onErrorContainer,
        fontWeight: FontWeight.w600,
      );
  static get titleLargeOnErrorContainerRegular =>
      theme.textTheme.titleLarge!.copyWith(
        color: theme.colorScheme.onErrorContainer.withOpacity(0.9),
        fontWeight: FontWeight.w400,
      );
  static get titleLargePrimary => theme.textTheme.titleLarge!.copyWith(
        color: theme.colorScheme.primary,
      );
  static get titleLarge_1 => theme.textTheme.titleLarge!;
  static get titleMediumBlack900 => theme.textTheme.titleMedium!.copyWith(
        color: appTheme.black900.withOpacity(0.8),
        fontWeight: FontWeight.w700,
      );
  static get titleMediumBlack90018 => theme.textTheme.titleMedium!.copyWith(
        color: appTheme.black900,
        fontSize: 18.fSize,
      );
  static get titleMediumBlack900Bold => theme.textTheme.titleMedium!.copyWith(
        color: appTheme.black900.withOpacity(0.8),
        fontSize: 18.fSize,
        fontWeight: FontWeight.w700,
      );
  static get titleMediumBlack900Bold18 => theme.textTheme.titleMedium!.copyWith(
        color: appTheme.black900,
        fontSize: 18.fSize,
        fontWeight: FontWeight.w700,
      );
  static get titleMediumBlack900Bold_1 => theme.textTheme.titleMedium!.copyWith(
        color: appTheme.black900.withOpacity(0.75),
        fontWeight: FontWeight.w700,
      );
  static get titleMediumBlack900Bold_2 => theme.textTheme.titleMedium!.copyWith(
        color: appTheme.black900,
        fontWeight: FontWeight.w700,
      );
  static get titleMediumBlack900_1 => theme.textTheme.titleMedium!.copyWith(
        color: appTheme.black900.withOpacity(0.8),
      );
  static get titleMediumBlack900_2 => theme.textTheme.titleMedium!.copyWith(
        color: appTheme.black900.withOpacity(0.6),
      );
  static get titleMediumBlack900_3 => theme.textTheme.titleMedium!.copyWith(
        color: appTheme.black900.withOpacity(0.75),
      );
  static get titleMediumErrorContainer => theme.textTheme.titleMedium!.copyWith(
        color: theme.colorScheme.errorContainer,
      );
  static get titleMediumGray800 => theme.textTheme.titleMedium!.copyWith(
        color: appTheme.gray800,
        fontWeight: FontWeight.w700,
      );
  static get titleMediumMontserratBlack900 =>
      theme.textTheme.titleMedium!.montserrat.copyWith(
        color: appTheme.black900.withOpacity(0.5),
        fontWeight: FontWeight.w500,
      );
  static get titleMediumOnErrorContainer =>
      theme.textTheme.titleMedium!.copyWith(
        color: theme.colorScheme.onErrorContainer.withOpacity(1),
        fontSize: 18.fSize,
        fontWeight: FontWeight.w700,
      );
  static get titleMediumOnErrorContainerBold =>
      theme.textTheme.titleMedium!.copyWith(
        color: theme.colorScheme.onErrorContainer.withOpacity(1),
        fontSize: 18.fSize,
        fontWeight: FontWeight.w700,
      );
  static get titleMediumOnErrorContainerBold_1 =>
      theme.textTheme.titleMedium!.copyWith(
        color: theme.colorScheme.onErrorContainer.withOpacity(1),
        fontWeight: FontWeight.w700,
      );
  static get titleMediumPrimary => theme.textTheme.titleMedium!.copyWith(
        color: theme.colorScheme.primary,
        fontWeight: FontWeight.w800,
      );
  static get titleMediumPrimary18 => theme.textTheme.titleMedium!.copyWith(
        color: theme.colorScheme.primary,
        fontSize: 18.fSize,
      );
  static get titleMediumPrimaryBold => theme.textTheme.titleMedium!.copyWith(
        color: theme.colorScheme.primary,
        fontWeight: FontWeight.w700,
      );
  static get titleMediumPrimaryBold18 => theme.textTheme.titleMedium!.copyWith(
        color: theme.colorScheme.primary,
        fontSize: 18.fSize,
        fontWeight: FontWeight.w700,
      );
  static get titleMediumPrimaryBold_1 => theme.textTheme.titleMedium!.copyWith(
        color: theme.colorScheme.primary,
        fontWeight: FontWeight.w700,
      );
  static get titleSmallBlack900 => theme.textTheme.titleSmall!.copyWith(
        color: appTheme.black900.withOpacity(0.6),
      );
  static get titleSmallBlack900_1 => theme.textTheme.titleSmall!.copyWith(
        color: appTheme.black900.withOpacity(0.8),
      );
  static get titleSmallPrimary => theme.textTheme.titleSmall!.copyWith(
        color: theme.colorScheme.primary,
        fontWeight: FontWeight.w700,
      );
  static get titleSmallPrimary_1 => theme.textTheme.titleSmall!.copyWith(
        color: theme.colorScheme.primary,
      );
}

extension on TextStyle {
  TextStyle get lato {
    return copyWith(
      fontFamily: 'Lato',
    );
  }

  TextStyle get roboto {
    return copyWith(
      fontFamily: 'Roboto',
    );
  }

  TextStyle get publicSans {
    return copyWith(
      fontFamily: 'Public Sans',
    );
  }

  TextStyle get montserrat {
    return copyWith(
      fontFamily: 'Montserrat',
    );
  }

  TextStyle get nunitoSans {
    return copyWith(
      fontFamily: 'Nunito Sans',
    );
  }

  TextStyle get notoSans {
    return copyWith(
      fontFamily: 'Noto Sans',
    );
  }
}
