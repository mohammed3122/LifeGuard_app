# Life Guard

تطبيق Life Guard هو تطبيق Flutter لمتابعة القياسات الصحية للمستخدم (مثل ضربات القلب و الأكسجين إلخ) مع واجهة عربية سهلة الاستخدام.

## الميزات

- تسجيل دخول وتسجيل حساب جديد باستخدام Firebase Authentication.
- حفظ بيانات المستخدم (الاسم، العمر، الجنس، البريد الإلكتروني، الهاتف).
- عرض وتعديل بيانات الملف الشخصي.
- عرض آخر القياسات الصحية على شكل رسم بياني (Bar Chart).
- دعم إشعارات ترحيبية وتفاعلية.
- واجهة عربية بالكامل وتصميم عصري.
- دعم تسجيل الخروج وتسجيل الدخول عبر Google.

## التقنيات المستخدمة

- Flutter
- Firebase Auth & Firestore
- overlay_support (لإشعارات Overlay)
- fl_chart (للرسوم البيانية)
- awesome_dialog (لحوار التنبيهات)
- intl (لتنسيق التواريخ)

## بدء الاستخدام

1. تأكد من إعداد Firebase لمشروعك.
2. نفذ:
   ```bash
   flutter pub get
   flutter run
   ```
3. عدّل بيانات الاتصال بـ Firebase في `android/app/google-services.json` و`ios/Runner/GoogleService-Info.plist`.


## حقوق النشر
جميع الحقوق محفوظة © 2024 Life Guard Team
