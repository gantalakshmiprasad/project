import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Introductionpage extends StatelessWidget {
  const Introductionpage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B1517), // Base Deep Tech Background
      body: LayoutBuilder(
        builder: (context, constraints) {
          bool isMobile =
              constraints.maxWidth <
              800; // Adjusted breakpoint for layout comfort

          return Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                center: Alignment(-0.6, -0.7),
                radius: 1.2,
                colors: [
                  Color(0x261E4D55), // Hex replacement for 0.15 opacity
                  Color(0xFF0B1517),
                ],
                stops: [0.0, 1.0],
              ),
            ),
            child: SafeArea(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(
                  horizontal: isMobile ? 24 : 64,
                  vertical: 32,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // --- HEADER SECTION ---
                    _buildHeader(isMobile),

                    const SizedBox(height: 60),

                    // --- HERO BADGE ---
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(
                          0x1A2DD4BF,
                        ), // Hex replacement for 0.1 opacity
                        borderRadius: BorderRadius.circular(100),
                        border: Border.all(
                          color: const Color(0x3F2DD4BF),
                        ), // Hex replacement for 0.25 opacity
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.bolt_rounded,
                            color: Color(0xFF2DD4BF),
                            size: 16,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            "v1.0 Cloud Engine Live",
                            style: TextStyle(
                              color: const Color(0xFF2DD4BF),
                              fontSize: isMobile ? 11 : 13,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // --- MAIN HERO TITLE ---
                    Text(
                      'One Platform. Any Business.\nInfinite Scalability.',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: isMobile ? 36 : 64,
                        fontWeight: FontWeight.w900,
                        height: 1.15,
                        letterSpacing: -1,
                      ),
                    ),

                    const SizedBox(height: 24),

                    // --- DESCRIPTION BLOCK ---
                    ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: isMobile ? double.infinity : 720,
                      ),
                      child: Text(
                        ' strips away the complexity of traditional legacy POS setups. Experience a lightning-fast terminal built to effortlessly handle everything from busy restaurant kitchens to complex pharmacy batch distributions.',
                        style: TextStyle(
                          color: const Color(
                            0xFF94A3B8,
                          ), // Sleek Slate-400 Text
                          fontSize: isMobile ? 16 : 20,
                          height: 1.6,
                        ),
                      ),
                    ),

                    const SizedBox(height: 48),

                    // --- CALL TO ACTION BUTTONS ---
                    _buildActionButtons(isMobile),

                    const SizedBox(height: 80),

                    // --- BUSINESS SEGMENTS MATRIX ---
                    Text(
                      "Engineered for modern operational workflows",
                      style: TextStyle(
                        color: const Color(
                          0xE5FFFFFF,
                        ), // Hex replacement for 0.9 opacity
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.3,
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildFeatureMatrix(isMobile),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // Modernized Header Layout
  Widget _buildHeader(bool isMobile) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment:
          CrossAxisAlignment.center, // Fixed brackets and Center typo alignment
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFF0F262A),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFF1E4D55), width: 1.5),
                boxShadow: const [
                  BoxShadow(
                    color: Color(
                      0x0D2DD4BF,
                    ), // Hex replacement for 0.05 opacity
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: const Text(
                'UBS',
                style: TextStyle(
                  color: Color(0xFF2DD4BF),
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                ),
              ),
            ),
            const SizedBox(width: 14),
            if (!isMobile)
              const Text(
                'Universal Billing Service',
                style: TextStyle(
                  color: Color.fromARGB(255, 244, 245, 246),
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
          ],
        ),
        if (!isMobile)
          OutlinedButton(
            onPressed: () => Get.offAllNamed('/login'),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Color(0xFF1E4D55)),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text(
              'Sign In Workspace',
              style: TextStyle(color: Colors.white),
            ),
          ),
      ],
    );
  }

  // Unified CTA Module
  Widget _buildActionButtons(bool isMobile) {
    return Wrap(
      spacing: 16,
      runSpacing: 16,
      children: [
        ElevatedButton(
          onPressed: () => Get.offAllNamed('/login'),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF2DD4BF), // Bright Teal Accent
            foregroundColor: const Color(0xFF0B1517),
            elevation: 0,
            padding: EdgeInsets.symmetric(
              horizontal: isMobile ? 32 : 40,
              vertical: 20,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Launch Console',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              SizedBox(width: 8),
              Icon(Icons.arrow_forward_rounded, size: 18),
            ],
          ),
        ),
        if (isMobile)
          OutlinedButton(
            onPressed: () => Get.offAllNamed('/login'),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Color(0xFF1E4D55)),
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Sign In',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
      ],
    );
  }

  // Feature Matrix Grid
  Widget _buildFeatureMatrix(bool isMobile) {
    final features = [
      {
        'icon': Icons.restaurant_menu_rounded,
        'title': 'Food & Restaurant',
        'desc':
            'High-volume checkout processing with direct KOT management loops.',
      },
      {
        'icon': Icons.local_pharmacy_rounded,
        'title': 'Smart Pharmacy',
        'desc':
            'Track expiry timelines, live item batch matrices, and medical compliance logs.',
      },
    ];

    if (isMobile) {
      return Column(
        children: features
            .map(
              (f) => Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: _featureCard(
                  f['icon'] as IconData,
                  f['title']! as String,
                  f['desc']! as String,
                ),
              ),
            )
            .toList(),
      );
    }

    return Row(
      children: features
          .map(
            (f) => Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: _featureCard(
                  f['icon'] as IconData,
                  f['title']! as String,
                  f['desc']! as String,
                ),
              ),
            ),
          )
          .toList(),
    );
  }

  Widget _featureCard(IconData icon, String title, String desc) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0x990F262A), // Hex replacement for 0.6 opacity
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0x661E4D55),
        ), // Hex replacement for 0.4 opacity
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0x1A2DD4BF), // Hex replacement for 0.1 opacity
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: const Color(0xFF2DD4BF), size: 24),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            desc,
            style: const TextStyle(
              color: Color(0xFF64748B),
              fontSize: 14,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
