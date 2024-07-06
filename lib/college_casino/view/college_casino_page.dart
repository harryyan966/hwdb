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
          CardsGrid(context: context),
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
}

class CardsGrid extends StatelessWidget {
  const CardsGrid({
    super.key,
    required this.context,
  });

  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: LayoutBuilder(builder: (context, constraints) {
        return Padding(
          padding: const EdgeInsets.only(right: Spacing.m),
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 5,
              mainAxisSpacing: Spacing.s,
              crossAxisSpacing: Spacing.s,
              mainAxisExtent: constraints.maxHeight / 2,
            ),
            itemCount: 10,
            // ignore: prefer_const_constructors
            itemBuilder: (context, index) => RandomCard(), // this is deliberately not const as it is reset by rebuild
          ),
        );
      }),
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
  static final _random = Random.secure();

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
            Positioned.fill(
              child: _cardSection(
                controller: _backController,
                animation: _backAnimation,
                image: CardImages.cardBack,
              ),
            ),
            Positioned.fill(
              child: _cardSection(
                controller: _frontController,
                animation: _frontAnimation,
                image: _card,
              ),
            ),
          ],
        ),
      ),
    );
  }

  ImageProvider _getRandomCard() {
    final chance = _random.nextDouble();
    final chances = [0.003, 0.009, 0.027, 0.081, 0.243];

    // Calculate cumulative chances.
    for (int i = 1; i < chances.length; i++) {
      chances[i] = chances[i] + chances[i - 1];
    }

    if (chance < chances[0]) {
      return CardImages.god[_random.nextInt(CardImages.god.length)];
    } else if (chance < chances[1]) {
      return CardImages.wtf[_random.nextInt(CardImages.wtf.length)];
    } else if (chance < chances[2]) {
      return CardImages.wow[_random.nextInt(CardImages.wow.length)];
    } else if (chance < chances[3]) {
      return CardImages.yes[_random.nextInt(CardImages.yes.length)];
    } else if (chance < chances[4]) {
      return CardImages.yea[_random.nextInt(CardImages.yea.length)];
    }

    return CardImages.lol;
  }

  Widget _cardSection({
    required AnimationController controller,
    required Animation<double> animation,
    required ImageProvider image,
  }) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) => Transform(
        alignment: Alignment.center,
        transform: Matrix4.identity()..rotateY(animation.value),
        child: Container(
          color: Colors.white,
          child: Image(
            image: image,
            fit: BoxFit.fitWidth,
          ),
        ),
      ),
    );
  }

  void _initializeAnimation() {
    _backController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _frontController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
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

/// NOTE: The groupings of colleges may be inaccurate, and some great colleges are missing on the lists. Please do not take this too seriously as it is only a biased measure of the rarity of colleges offers. Again, all colleges are great colleges, and your fit with the college is always the top priority to consider.
abstract class CardImages {
  static final god = <ImageProvider>[
    Assets.images.colleges.stanford.provider(),
    Assets.images.colleges.mit.provider(),
    Assets.images.colleges.harvard.provider(),
    Assets.images.colleges.yale.provider(),
    Assets.images.colleges.princeton.provider(),
    Assets.images.colleges.caltech.provider(),
  ];
  static final wtf = <ImageProvider>[
    Assets.images.colleges.upenn.provider(),
    Assets.images.colleges.dartmouth.provider(),
    Assets.images.colleges.cornell.provider(),
    Assets.images.colleges.northwestern.provider(),
    Assets.images.colleges.brown.provider(),
    Assets.images.colleges.columbia.provider(),
    Assets.images.colleges.jhu.provider(),
    Assets.images.colleges.duke.provider(),
    Assets.images.colleges.ucb.provider(),
    Assets.images.colleges.uchicago.provider(),
    Assets.images.colleges.cambridge.provider(),
    Assets.images.colleges.oxford.provider(),
  ];
  static final wow = <ImageProvider>[
    Assets.images.colleges.vanderbilt.provider(),
    Assets.images.colleges.notredame.provider(),
    Assets.images.colleges.rice.provider(),
    Assets.images.colleges.ucla.provider(),
    Assets.images.colleges.cmu.provider(),
    Assets.images.colleges.gatech.provider(),
    Assets.images.colleges.tufts.provider(),
    Assets.images.colleges.lse.provider(),
    Assets.images.colleges.washu.provider(),
    Assets.images.colleges.virginia.provider(),
    Assets.images.colleges.georgetown.provider(),
    Assets.images.colleges.umich.provider(),
  ];
  static final yes = <ImageProvider>[
    Assets.images.colleges.usc.provider(),
    Assets.images.colleges.emory.provider(),
    Assets.images.colleges.unc.provider(),
    Assets.images.colleges.imperial.provider(),
    Assets.images.colleges.nyu.provider(),
    Assets.images.colleges.ucl.provider(),
  ];
  static final yea = <ImageProvider>[
    Assets.images.colleges.bu.provider(),
    Assets.images.colleges.uci.provider(),
    Assets.images.colleges.purdue.provider(),
    Assets.images.colleges.florida.provider(),
    Assets.images.colleges.illinois.provider(),
    Assets.images.colleges.madison.provider(),
    Assets.images.colleges.rochester.provider(),
    Assets.images.colleges.ucd.provider(),
    Assets.images.colleges.ucsb.provider(),
    Assets.images.colleges.ohio.provider(),
  ];
  static final lol = Assets.images.colleges.pineapple.provider();
  static final cardBack = Assets.images.collegeCardBack.provider();
}
