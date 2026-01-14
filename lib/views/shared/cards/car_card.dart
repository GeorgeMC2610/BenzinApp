import 'package:auto_size_text/auto_size_text.dart';
import 'package:benzinapp/services/data_holder.dart';
import 'package:benzinapp/views/car/delete_car_screen.dart';
import 'package:benzinapp/views/car/invite_user_to_car.dart';
import 'package:benzinapp/views/car/transfer_car_ownership_screen.dart';
import 'package:benzinapp/views/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:intl/intl.dart' hide TextDirection;

import '../../../services/classes/car.dart';
import '../../../services/managers/car_user_invitation_manager.dart';
import '../../forms/car_form.dart';
import '../notification.dart';
import '../shared_font_styles.dart';

class CarCard extends StatelessWidget {
  const CarCard({super.key, required this.car});

  final Car? car;

  @override
  Widget build(BuildContext context) => car == null
      ?

      // ADD NEW CAR CARD
      SizedBox(
          child: Card(
            elevation: 0,
            color: Colors.transparent,
            shape: const _DashedBorder(
              color: Colors.grey,
              strokeWidth: 2,
              gap: 3,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FloatingActionButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const CarForm(),
                      ),
                    );
                  },
                  elevation: 0,
                  child: const Icon(Icons.add),
                ),
                const SizedBox(height: 10),
                Text(
                  translate('addNewCar'),
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
          ),
        )
      :

      // ACTUAL CAR
      SizedBox(
          child: Card(
            elevation: 0,
            color: !car!.isOwned() ? Theme.of(context).colorScheme.tertiaryContainer : null,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: InkWell(
              onTap: () {
                // navigate the user to the main page.
              },
              borderRadius: BorderRadius.circular(16),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: AutoSizeText(
                            minFontSize: 15,
                            maxLines: 1,
                            car!.username,
                            style: const TextStyle(
                                fontSize: 25, fontWeight: FontWeight.bold),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),

                        InkWell(
                          onTap: () {
                             showCarDetailsDialog(context);
                          },
                          child: const Padding(
                            padding: EdgeInsets.only(left: 8, top: 5, bottom: 5),
                            child: Icon(Icons.more_vert),
                          )
                        )
                      ]
                    ),
                    AutoSizeText(
                      maxLines: 1,
                      DateFormat.yMMMd().format(car!.createdAt),
                      style: SharedFontStyles.legendTextStyle,
                    ),
                    const SizedBox(height: 8),
                    AutoSizeText(
                      maxLines: 1,
                      "${car!.manufacturer} ${car!.model}",
                      style: SharedFontStyles.descriptiveTextStyle,
                    ),
                    const Spacer(),
                    if (!car!.isOwned())
                      Row(
                        children: [
                          const Icon(Icons.person, size: 18),
                          const SizedBox(width: 3),
                          Expanded(
                            child: AutoSizeText(
                              car!.ownerUsername,
                              maxLines: 1,
                              minFontSize: 8,
                            ),
                          )
                        ],
                      ),
                    Row(
                      children: [
                        Material(
                            color:
                            car!.isOwned() ?
                            Theme.of(context).colorScheme.tertiaryContainer : null,
                            borderRadius: BorderRadius.circular(20),
                            elevation: 0,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                              child: Text(car!.year.toString()),
                            )),
                        const Spacer(),
                        if (!car!.isOwned())
                          const Icon(Icons.people, size: 40),
                        if (car!.isOwned() && car!.isShared)
                          const Icon(Icons.supervised_user_circle, size: 40),
                        if (car!.isOwned() && !car!.isShared)
                          const Icon(Icons.directions_car, size: 40),
                      ],
                    ),
                    FilledButton.tonalIcon(
                        onPressed: () {
                          DataHolder().getCarData(car!.id);
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const HomePage(),
                            ),
                          );
                        },
                        style: FilledButton.styleFrom(
                          minimumSize: const Size(double.infinity, 30),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        icon: const Icon(Icons.remove_red_eye, size: 17),
                        label: AutoSizeText(translate('viewDetails'), maxLines: 1, minFontSize: 10)
                    )
                  ],
                ),
              ),
            ),
          ));

  void showCarDetailsDialog(context) {
    showDialog(
        context: context,
        builder: (buildContext) => AlertDialog(
            content: SizedBox(
              width: MediaQuery.of(context).size.width * 0.7,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Row(
                    children: [
                      Expanded(
                        child: AutoSizeText(
                          translate(
                            'carMenuDetails',
                            args: {'car': car!.username},
                          ),
                          maxLines: 1,
                          minFontSize: 10,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () {
                          Navigator.of(buildContext).pop();
                        },
                      ),
                    ],
                  ),
                  if (car!.isOwned()) ...getOwnedSettings(buildContext),
                  if (!car!.isOwned()) ...getSharedSettings(buildContext)
                ],
              ),
            )
        )
    );
  }

  getSharedSettings(buildContext) => [
    ListTile(
      leading: const Icon(Icons.visibility),
      title: Text(translate('carMenuView')),
      onTap: () {
        Navigator.of(buildContext).pop();
        DataHolder().getCarData(car!.id);
        Navigator.of(buildContext).push(
          MaterialPageRoute(
            builder: (context) => const HomePage(),
          ),
        );
      },
    ),
    ListTile(
      leading: const Icon(Icons.logout_rounded),
      title: Text(translate('carMenuLeaveCar')),
      textColor: Colors.red,
      iconColor: Colors.red,
      onTap: () async {
        final invitation = CarUserInvitationManager().local!.firstWhere((inv) => inv.carUsername == car!.username);
        await CarUserInvitationManager().delete(invitation);
        SnackbarNotification.show(MessageType.info, translate('invitationCanceled'));
        Navigator.of(buildContext).pop();
      },
    ),
  ];

  getOwnedSettings(buildContext) => [
    ListTile(
      leading: const Icon(Icons.visibility),
      title: Text(translate('carMenuView')),
      onTap: () {
        Navigator.of(buildContext).pop();
        DataHolder().getCarData(car!.id);
        Navigator.of(buildContext).push(
          MaterialPageRoute(
            builder: (context) => const HomePage(),
          ),
        );
      },
    ),
    ListTile(
      leading: const Icon(Icons.edit),
      title: Text(translate('carMenuEdit')),
      onTap: () async {
        Navigator.of(buildContext).pop();
        Navigator.of(buildContext).push(
          MaterialPageRoute(
            builder: (context) => CarForm(car: car),
          ),
        );
      },
    ),
    ListTile(
      leading: const Icon(Icons.share),
      title: Text(translate('carMenuShare')),
      onTap: () {
        Navigator.of(buildContext).pop();
        Navigator.of(buildContext).push(
          MaterialPageRoute(
            builder: (context) => InviteUserToCar(car: car!),
          ),
        );
      },
    ),
    ListTile(
      leading: const Icon(Icons.swap_horiz),
      title: Text(translate('carMenuTransferOwnership')),
      enabled: car!.isShared,
      textColor: car!.isShared ? Colors.red : null,
      iconColor: car!.isShared ? Colors.red : null,
      onTap: car!.isShared ? () {
        Navigator.of(buildContext).pop();
        Navigator.of(buildContext).push(
          MaterialPageRoute(
            builder: (context) => TransferCarOwnershipScreen(car: car!),
          ),
        );
      } : null,
    ),
    ListTile(
      leading: const Icon(Icons.delete),
      title: Text(translate('carMenuDelete')),
      textColor: Colors.red,
      iconColor: Colors.red,
      onTap: () {
        Navigator.of(buildContext).pop();
        Navigator.of(buildContext).push(
          MaterialPageRoute(
            builder: (context) => DeleteCarScreen(car: car!),
          ),
        );

      },
    ),
  ];
}

class _DashedBorder extends ShapeBorder {
  final Color color;
  final double strokeWidth;
  final double gap;

  const _DashedBorder({
    this.color = Colors.black,
    this.strokeWidth = 1.0,
    this.gap = 5.0,
  });

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.all(strokeWidth);

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    return Path()
      ..addRect(Rect.fromLTWH(rect.left, rect.top, rect.width, rect.height));
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    return Path()
      ..addRect(Rect.fromLTWH(rect.left, rect.top, rect.width, rect.height));
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final path = getOuterPath(rect);
    const dashWidth = 5.0;
    final dashSpace = gap;
    double distance = 0.0;

    for (final metric in path.computeMetrics()) {
      while (distance < metric.length) {
        canvas.drawPath(
          metric.extractPath(distance, distance + dashWidth),
          paint,
        );
        distance += dashWidth + dashSpace;
      }
      distance = 0;
    }
  }

  @override
  ShapeBorder scale(double t) {
    return _DashedBorder(
      color: color,
      strokeWidth: strokeWidth * t,
      gap: gap * t,
    );
  }
}