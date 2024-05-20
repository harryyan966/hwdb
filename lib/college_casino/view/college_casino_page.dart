import 'dart:math';

import 'package:client_tools/client_tools.dart';
import 'package:flutter/material.dart';
import 'package:hw_dashboard/l10n/l10n.dart';

class CollegeCasinoSection extends StatelessWidget {
  const CollegeCasinoSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const CollegeCasinoView();
  }
}

class CollegeCasinoView extends StatefulWidget {
  const CollegeCasinoView({super.key});

  @override
  State<CollegeCasinoView> createState() => _CollegeCasinoViewState();
}

class _CollegeCasinoViewState extends State<CollegeCasinoView> {
  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Padding(
      padding: const EdgeInsets.all(Spacing.l),
      child: Column(
        children: [
          _cards(),
          const SizedBox(height: Spacing.m),
          ElevatedButton(
            onPressed: () {
              setState(() {});
            },
            child: Text(l10n.buttonLabel_PlayAgain),
          ),
        ],
      ),
    );
  }

  Expanded _cards() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(right: Spacing.m),
        child: GridView.builder(
          // gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          //   maxCrossAxisExtent: 200,
          //   mainAxisSpacing: Spacing.s,
          //   crossAxisSpacing: Spacing.s,
          //   childAspectRatio: 11 / 16,
          // ),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 5,
            mainAxisSpacing: Spacing.s,
            crossAxisSpacing: Spacing.s,
            childAspectRatio: 11 / 16,
          ),
          itemCount: 10,
          // ignore: prefer_const_constructors
          itemBuilder: (context, index) => RandomCard(), //
        ),
      ),
    );
  }
}

class RandomCard extends StatefulWidget {
  const RandomCard({super.key});

  @override
  State<RandomCard> createState() => _RandomCardState();
}

class _RandomCardState extends State<RandomCard> with TickerProviderStateMixin {
  static const _hasBonusCard = false;
  static final _random = Random();
  static final t1 = <ImageProvider>[
    Assets.images.colleges.stanford.provider(),
    Assets.images.colleges.mit.provider(),
    Assets.images.colleges.harvard.provider(),
    Assets.images.colleges.yale.provider(),
    Assets.images.colleges.princeton.provider(),
    Assets.images.colleges.caltech.provider(),
    Assets.images.colleges.upenn.provider(),
  ];
  static final t2 = <ImageProvider>[
    Assets.images.colleges.dartmouth.provider(),
    Assets.images.colleges.cornell.provider(),
    Assets.images.colleges.northwestern.provider(),
    Assets.images.colleges.brown.provider(),
    Assets.images.colleges.columbia.provider(),
    Assets.images.colleges.jhu.provider(),
    Assets.images.colleges.duke.provider(),
    Assets.images.colleges.ucb.provider(),
    Assets.images.colleges.uchicago.provider(),
  ];
  static final t3 = <ImageProvider>[
    Assets.images.colleges.vanderbilt.provider(),
    Assets.images.colleges.notredame.provider(),
    Assets.images.colleges.rice.provider(),
    Assets.images.colleges.ucla.provider(),
    Assets.images.colleges.cmu.provider(),
    Assets.images.colleges.emory.provider(),
    Assets.images.colleges.gatech.provider(),
    Assets.images.colleges.tufts.provider(),
    Assets.images.colleges.unc.provider(),
  ];
  static final t4 = <ImageProvider>[
    Assets.images.colleges.nyu.provider(),
    Assets.images.colleges.bu.provider(),
    Assets.images.colleges.illinois.provider(),
    Assets.images.colleges.madison.provider(),
    Assets.images.colleges.rochester.provider(),
    Assets.images.colleges.ucd.provider(),
    Assets.images.colleges.ucsb.provider(),
  ];
  static final pineapple = Assets.images.colleges.pineapple.provider();

  late AnimationController _backController;
  late AnimationController _frontController;
  late Animation<double> _backAnimation;
  late Animation<double> _frontAnimation;

  late ImageProvider _card;
  ImageProvider? _bonusCard;

  bool preventReset = false;

  @override
  void initState() {
    super.initState();
    _initializeAnimation();
  }

  @override
  Widget build(BuildContext context) {
    _reset();

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          _backController.forward();
        },
        child: Stack(
          children: [
            _cardSection(
              controller: _backController,
              animation: _backAnimation,
              image: Assets.images.collegeCardBack.provider(),
            ),
            _cardSection(
              controller: _frontController,
              animation: _frontAnimation,
              image: _card,
            ),
          ],
        ),
      ),
    );
  }

  ImageProvider _getRandomCard() {
    final tierRand = _random.nextDouble();
    final probs = [1, 0.01, 0.04, 0.1];

    // Calculate cumulative prob.
    for (int i = 0; i < probs.length - 1; i++) {
      probs[i + 1] = probs[i] + probs[i + 1];
    }

    if (tierRand < probs[0]) {
      return t1[_random.nextInt(t1.length)];
    } else if (tierRand < probs[1]) {
      return t2[_random.nextInt(t2.length)];
    } else if (tierRand < probs[2]) {
      return t3[_random.nextInt(t3.length)];
    } else if (tierRand < probs[3]) {
      return t4[_random.nextInt(t4.length)];
    }

    return pineapple;
  }

  AnimatedBuilder _cardSection({
    required AnimationController controller,
    required Animation<double> animation,
    required ImageProvider image,
  }) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) => Transform(
        alignment: Alignment.center,
        transform: Matrix4.identity()
          ..rotateY(
            animation.value,
          ),
        child: Image(image: image),
      ),
    );
  }

  void _initializeAnimation() {
    _backController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    _frontController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    _backAnimation = Tween<double>(
      begin: 0,
      end: pi / 2,
    ).animate(_backController);

    _frontAnimation = Tween<double>(
      begin: -pi / 2,
      end: 0,
    ).animate(_frontController);

    _backController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _frontController.forward();
      }
    });

    _frontController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        if (_hasBonusCard && _bonusCard != null) {
          Future.delayed(const Duration(seconds: 6), () {
            _card = _bonusCard!;
            preventReset = true;
            setState(() {});
          });
        }
      }
    });
  }

  void _reset() {
    if (preventReset) {
      preventReset = false;
      return;
    }

    _backController.reset();
    _frontController.reset();

    final cardImage = _getRandomCard();
    _card = cardImage;

    if (_hasBonusCard) {
      if (cardImage == Assets.images.colleges.pineapple.provider()) {
        _bonusCard = _getRandomCard();
      } else {
        _bonusCard = null;
      }
    }
  }
}
