// // ignore_for_file: avoid_print

// import 'package:app_ui/app_ui.dart';
// import 'package:flutter/widgets.dart';

// /// Signature for the individual builders (`small`, `large`).
// typedef ResponsiveLayoutWidgetBuilder = Widget Function(BuildContext, Widget?);

// /// {@template responsive_layout_builder}
// /// A wrapper around [LayoutBuilder] which exposes builders for
// /// various responsive breakpoints.
// /// {@endtemplate}
// class ResponsiveLayoutBuilder extends StatelessWidget {
//   /// {@macro responsive_layout_builder}
//   const ResponsiveLayoutBuilder({
//     required this.small,
//     required this.large,
//     super.key,
//     this.child,
//   });

//   /// [ResponsiveLayoutWidgetBuilder] for small layout.
//   final ResponsiveLayoutWidgetBuilder small;

//   /// [ResponsiveLayoutWidgetBuilder] for large layout.
//   final ResponsiveLayoutWidgetBuilder large;

//   /// Optional child widget which will be passed
//   /// to the `small` and `large`
//   /// builders as a way to share/optimize shared layout.
//   final Widget? child;

//   @override
//   Widget build(BuildContext context) {
//     if (context.isSmall) return small(context, child);
//     return large(context, child);
//   }
// }
