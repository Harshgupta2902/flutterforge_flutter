import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

const Color primaryColor = Color(0xFF066AC9);

class OnBoardingTwoView extends StatefulWidget {
  const OnBoardingTwoView({Key? key}) : super(key: key);

  @override
  State<OnBoardingTwoView> createState() => _OnBoardingTwoViewState();
}

class _OnBoardingTwoViewState extends State<OnBoardingTwoView> {
  int _selectedIndex = 0;
  final PageController _pageController = PageController();

  List<Map<String, dynamic>> onboardingData = [
    {
      'title': "Welcome to Flutter Forge",
      'subtitle':
          "Embark on a journey to master a transformative skill and elevate your career prospects.",
      'iconPath': "assets/onboarding_two/onboard1.svg"
    },
    {
      'title': "High-Quality Code Standards",
      'subtitle':
          "Build resilient and maintainable applications with our comprehensive Flutter training.",
      'iconPath': "assets/onboarding_two/onboard2.svg"
    },
    {
      'title': "Expert Collaboration",
      'subtitle': "Engage with and learn from leading Flutter developers worldwide.",
      'iconPath': "assets/onboarding_two/onboard3.svg"
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Spacer(),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.64,
            child: PageView.builder(
              itemCount: onboardingData.length,
              onPageChanged: (value) {
                setState(() {
                  _selectedIndex = value;
                });
              },
              controller: _pageController,
              itemBuilder: (context, index) {
                return OnboardContent(
                  illustration: onboardingData[index]['iconPath'],
                  title: onboardingData[index]['title'],
                  text: onboardingData[index]['subtitle'],
                );
              },
            ),
          ),
          buildIndicator(),
          const SizedBox(height: kToolbarHeight),
          GestureDetector(
            onTap: () {
              setState(() {
                _selectedIndex++;
              });
              _pageController.nextPage(
                duration: const Duration(milliseconds: 1000),
                curve: Curves.linearToEaseOut,
              );
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: primaryColor,
                  ),
                  padding: const EdgeInsets.all(19),
                  child: const Icon(
                    Icons.arrow_forward_sharp,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                buildProgressIndicator(),
              ],
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }

  Widget buildIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        3,
        (index) {
          final bool isActive = index == _selectedIndex;
          return AnimatedContainer(
            duration: const Duration(seconds: 1),
            width: isActive ? 34 : 8,
            height: 6,
            curve: Curves.linearToEaseOut,
            margin: const EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(12)),
              color: isActive ? primaryColor : primaryColor.withOpacity(0.5),
            ),
          );
        },
      ),
    );
  }

  Widget buildProgressIndicator() {
    double progress = (_selectedIndex + 1) / 3; // Calculate progress
    return TweenAnimationBuilder(
      curve: Curves.linearToEaseOut,
      tween: Tween<double>(begin: 0.0, end: progress),
      duration: const Duration(seconds: 1), // Adjust duration as needed
      builder: (BuildContext context, double value, Widget? child) {
        return Transform.scale(
          scale: 2.5,
          child: CircularProgressIndicator(
            value: value,
            backgroundColor: primaryColor.withOpacity(0.2),
            valueColor: const AlwaysStoppedAnimation<Color>(primaryColor),
            strokeWidth: 1,
          ),
        );
      },
    );
  }
}

class OnboardContent extends StatelessWidget {
  const OnboardContent({
    super.key,
    required this.illustration,
    required this.title,
    required this.text,
  });

  final String illustration, title, text;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AspectRatio(
          aspectRatio: 1,
          child: SvgPicture.asset(illustration),
        ),
        const SizedBox(height: 16),
        Text(
          title,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w700,
                fontSize: 20,
                color: primaryColor,
              ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        Text(
          text,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w400,
                fontSize: 15,
              ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
