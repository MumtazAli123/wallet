// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'mix_widgets.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody()
    );
  }

  _buildBody() {
    return NestedScrollView(
        controller: ScrollController(),
        scrollBehavior: ScrollBehavior(),
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              expandedHeight: 200,
              floating: false,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                title: wText('Privacy Policy', size: 24, color: Colors.white),
                background: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.blue,
                        Colors.blueAccent,
                      ],
                    ),
                  ),
                )
              ),
            ),
          ];
        },
        body: _buildContent(),
    );
  }

  _buildHeader() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.blue,
            Colors.blueAccent,
          ],
        ),
      ),
      child: Column(
        children: [
          Text(
            'Privacy Policy',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16),
          Text(
            'Last updated: 2021-09-01',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  _buildContent() {
    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'This privacy policy applies to the ZubiPay app (hereby referred to as "Application") for mobile devices that was created by Mumtaz Ali (hereby referred to as "Service Provider") as a Free service. This service is intended for use "AS IS".',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 16),
              Text(
                'At the ZubiPay Digital Wallet, privacy is important to us. Therefore, zubipay is committed to safeguarding the privacy of all customers. This policy sets out how we collect and will treat your personal information. Please contact us at paysaw@yahoo.com if you have any questions.',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 16),
              Text(
                "The Application collects information when you download and use it. This information may include information such as\n'Your device's Internet Protocol address (e.g. IP address)\nThe pages of the Application that you visit, the time and date of your visit, the time spent on those pages\nThe time spent on the Application\nThe operating system you use on your mobile device",
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 16),
              Text(
                'The Application does not gather precise information about the location of your mobile device.',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 16),
              Text(
                'The Service Provider may use the information you provided to contact you from time to time to provide you with important information, required notices and marketing promotions.',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 16),
              Text(
                'For a better experience, while using the Application, the Service Provider may require you to provide us with certain personally identifiable information, including but not limited to ZubiPay app does not collect data and not share with anyone. The information that the Service Provider request will be retained by them and used as described in this privacy policy.',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 16.0),
              Text(
                textAlign: TextAlign.start,
                  "Third Party Access", style: GoogleFonts.gabriela(fontSize: 20, fontWeight: FontWeight.bold)),
              Text(
                'Only aggregated, anonymized data is periodically transmitted to external services to aid the Service Provider in improving the Application and their service. The Service Provider may share your information with third parties in the ways that are described in this privacy statement.',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Please note that the Application utilizes third-party services that have their own Privacy Policy about handling data. Below are the links to the Privacy Policy of the third-party service providers used by the Application:',
                // Google Play Services

              // AdMob',
              //   style: TextStyle(
              //     fontSize: 16,
              //   ),
              ),
              SizedBox(height: 16.0),
              Text(
                textAlign: TextAlign.start,
                'Google Play Services',
                style: GoogleFonts.aBeeZee(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'AdMob',
                style: GoogleFonts.aBeeZee(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                )
              ),

              SizedBox(height: 16.0),
              Text(
                'The Service Provider may disclose User Provided and Automatically Collected Information:\n'
                'as required by law, such as to comply with a subpoena, or similar legal process;\n'
              'when they believe in good faith that disclosure is necessary to protect their rights, protect your safety or the safety of others, investigate fraud, or respond to a government request;\n'
              'with their trusted services providers who work on their behalf, do not have an independent use of the information we disclose to them, and have agreed to adhere to the rules set forth in this privacy statement.',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 16.0),
              Text(
                'If the Service Provider is involved in a merger, acquisition, or sale of all or a portion of its assets, you will be notified via email and/or a prominent notice on our Web site of any change in ownership or uses of this information, as well as any choices you may have regarding this information.',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 16.0),
              Text(
                "Opt-Out Rights",
                style: GoogleFonts.aBeeZee(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'You can stop all collection of information by the Application easily by uninstalling the Application. You may use the standard uninstall processes as may be available as part of your mobile device or via the mobile application marketplace or network.',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 16.0),
              Text(
                'Data Retention Policy, Managing Your Information',
                style: GoogleFonts.aBeeZee(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "The Service Provider will retain User Provided data for as long as you use the Application and for a reasonable time thereafter. If you'd like them to delete User Provided Data that you have provided via the Application, please contact them at kad.dadu@gmail.com and they will respond in a reasonable time. Please note that some or all of the User Provided Data may be required in order for the Application to function properly.",
              ),
              SizedBox(height: 16.0),
Text(
                'Children',
                style: GoogleFonts.aBeeZee(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'The Service Provider does not use the Application to knowingly solicit data from or market to children under the age of 13. If a parent or guardian becomes aware that his or her child has provided us with information without their consent, he or she should contact us at\n'
                "kad.dadu@gmail.com. We will delete such information from our files within a reasonable time.",
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 16.0),
              Text(
                'Security',
                style: GoogleFonts.aBeeZee(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'The Service Provider is concerned about safeguarding the confidentiality of your information. They provide physical, electronic, and procedural safeguards to protect information they process and maintain. For example, they limit access to this information to authorized employees and contractors who need to know that information in order to operate, develop or improve their Application. Please be aware that, although they endeavor to provide reasonable security for information they process and maintain, no security system can prevent all potential security breaches.',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 16.0),
              Text(
                'Changes',
                style: GoogleFonts.aBeeZee(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'This Privacy Policy may be updated from time to time for any reason. The Service Provider will notify you of any changes to their Privacy Policy by posting the new Privacy Policy here. You are advised to consult this Privacy Policy regularly for any changes, as continued use is deemed approval of all changes.',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 16.0),
              Text(
                'Contact Us',
                style: GoogleFonts.aBeeZee(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'If you have any questions regarding privacy while using the Application, or have questions about our practices, please contact us via email at kad.dadu@gmail.com.',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 16.0),

              Text(
                'This policy is effective as of 1 September 2023.',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ],
    );

  }
}

 // Now, let’s add the  PrivacyPolicy  widget to the  routes  map in the  main.dart  file.