import 'package:flutter/material.dart';
// import 'package:raie/screens/unit_details_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  Future<void> _launchWhatsApp({
    required String phone,
    required String errorMessage,
    required BuildContext context,
  }) async {
    final uri = Uri.parse("whatsapp://send?phone=$phone");
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      // fallback لـ wa.me (لو whatsapp:// مش مدعوم)
      final webUri = Uri.parse("https://wa.me/$phone");
      if (await canLaunchUrl(webUri)) {
        await launchUrl(webUri, mode: LaunchMode.externalApplication);
      } else {
        // ignore: use_build_context_synchronously
        showDialog(
          // ignore: use_build_context_synchronously
          context: context,
          barrierDismissible: true,
          builder: (context) => Stack(
            alignment: Alignment.center,
            children: [
              Positioned(
                bottom: 80,
                left: 24,
                right: 24,
                child: Material(
                  color: Colors.transparent,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF339cd2), Color(0xFF2fc57f)],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          // ignore: deprecated_member_use
                          color: Colors.teal.withOpacity(0.18),
                          blurRadius: 16,
                          offset: Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          errorMessage,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'ElMessiri',
                            fontSize: 16,
                          ),
                        ),
                        Icon(
                          Icons.error_outline,
                          color: Colors.redAccent,
                          size: 28,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
        Future.delayed(Duration(seconds: 2), () {
          // ignore: use_build_context_synchronously
          if (Navigator.of(context).canPop()) {
            // ignore: use_build_context_synchronously
            Navigator.of(context).pop();
          }
        });
      }
    }
  }

  Widget forTitle(
      {required BuildContext context, required String? text, IconData? icon}) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            Color(0xFF339cd2), // الأزرق
            Color(0xFF2fc57f), // الأخضر
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            // ignore: deprecated_member_use
            color: Colors.teal.withOpacity(0.1),
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      padding: EdgeInsets.symmetric(vertical: 14, horizontal: 18),
      margin: EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(
            icon,
            color: Colors.white,
            size: 28,
          ),
          SizedBox(width: 10),
          Text(
            text!,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'ElMessiri',
                  fontSize: 22,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard({
    required IconData icon,
    required String title,
    required String subtitle,
    String? url,
    BuildContext? context,
  }) {
    return Card(
      elevation: 3,
      color: const Color(0xffe1f3f2),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: Colors.teal,
          size: 30,
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            fontFamily: 'ElMessiri',
          ),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(
            fontSize: 14,
            fontFamily: 'ElMessiri',
          ),
        ),
        onTap: url != null && context != null
            ? () async {
                final uri = Uri.parse(url);
                if (await canLaunchUrl(uri)) {
                  await launchUrl(uri, mode: LaunchMode.externalApplication);
                } else {
                  // ignore: use_build_context_synchronously
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('تعذر فتح الرابط')),
                  );
                }
              }
            : null,
        trailing: url != null
            ? const Icon(
                Icons.open_in_new,
                color: Colors.grey,
              )
            : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: AppBar(
            iconTheme: IconThemeData(
              color: Colors.white,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadiusDirectional.vertical(
                bottom: Radius.circular(30),
              ),
            ),
            title: Text(
              'عنا',
              style: TextStyle(
                fontFamily: 'ElMessiri',
                fontSize: 24,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            backgroundColor: Colors.transparent,
            elevation: 20,
            flexibleSpace: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    Color(0xFF339cd2), // الأزرق
                    Color(0xFF2fc57f), // الأخضر
                  ],
                ),
                borderRadius: BorderRadiusDirectional.vertical(
                  bottom: Radius.circular(30),
                ),
              ),
            ),
          ),
          body: SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                Container(
                  width: 140,
                  height: 140,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFF2EBEF2), // أزرق
                        Color(0xFF34C88A), // أخضر
                      ],
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(2.0), // سمك الإطار
                    child: CircleAvatar(
                      radius: 68,
                      backgroundImage:
                          AssetImage('assets/images/icons/alpha.webp'),
                      backgroundColor: Colors.white,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                forTitle(
                  context: context,
                  text: 'من نحن',
                  icon: Icons.group,
                ),
                Card(
                  color: Colors.teal.shade50,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      'نحن فريق Alpha قمنا بعمل نظام LifeGuard هو نظام متكامل لمراقبة المؤشرات الصحية الحيوية بشكل لحظي، يهدف إلى تمكين الأفراد والعائلات من متابعة صحتهم بسهولة وخصوصية، مع توفير تنبيهات ذكية وتقارير مفصلة تساعد في الوقاية والتدخل المبكر.',
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'ElMessiri',
                      ),
                      textDirection: TextDirection.rtl,
                      textAlign: TextAlign.justify,
                    ),
                  ),
                ),
                SizedBox(height: 25),
                forTitle(
                    context: context,
                    text: 'التقنيات المستخدمة',
                    icon: Icons.code),
                _buildCard(
                    icon: Icons.phone_android,
                    title: 'تطبيق الموبايل',
                    subtitle: 'من خلاله تتابع به قياساتك.'),
                SizedBox(height: 5),
                _buildCard(
                  icon: Icons.web,
                  title: "موقعنا الإلكتروني",
                  subtitle: "اضغط هنا لزيارة الموقع.",
                  url: "http://life-guard-monitor0.getenjoyment.net",
                  context: context,
                ),
                SizedBox(height: 5),
                _buildCard(
                  icon: Icons.memory,
                  title: 'جهاز أردوينو',
                  subtitle:
                      'يستخدم لقراءة البيانات من المستشعرات وإرسالها إلى التطبيق و موقع الويب.',
                ),
                SizedBox(height: 20),
                forTitle(
                    context: context,
                    text: 'نتمني لكم دوام العافية.',
                    icon: Icons.favorite),
                SizedBox(height: 16),
                Center(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          Color(0xFF339cd2), // الأزرق
                          Color(0xFF2fc57f), // الأخضر // الأخضر
                        ],
                      ),
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          // ignore: deprecated_member_use
                          color: Colors.tealAccent.withOpacity(0.2),
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        _launchWhatsApp(
                          phone: '201044319398',
                          errorMessage: 'عذرا .. لا يمكن فتح تطبيق الواتساب ',
                          context: context,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(200, 30),
                        elevation: 8,
                        backgroundColor: Colors.transparent,
                        padding:
                            EdgeInsets.symmetric(horizontal: 40, vertical: 18),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        shadowColor: Colors.transparent,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'تواصل معنا عبر واتساب',
                            style: TextStyle(
                              fontSize: 18,
                              fontFamily: 'ElMessiri',
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 1,
                            ),
                          ),
                          SizedBox(width: 12),
                          Icon(
                            Icons.chat,
                            color: Colors.white,
                            size: 28,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
