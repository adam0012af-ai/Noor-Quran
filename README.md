# نور القرآن — Android v0.4.0

تطبيق أندرويد عربي خفيف للقراءة والاستماع والتفسير والأذكار.

## أهم ما في v0.4.0

- استكمال مشروع Android/Gradle الناقص ليصبح قابلًا للبناء.
- تذكير أذكار بصوت مخصص هادئ داخل التطبيق.
- ثلاثة أوضاع للتذكير: صوت، اهتزاز فقط، صامت/كتابة فقط.
- زر «تجربة التنبيه الآن» قبل التفعيل.
- إعادة جدولة التذكير تلقائيًا بعد إعادة تشغيل الهاتف.
- الإبقاء على النص داخل الإشعار مع وضع الصوت المختار.
- Version code 4 / Version name 0.4.0.
- GitHub Actions workflow لبناء Debug APK من الهاتف أو المتصفح.

## البناء

المتطلبات محليًا: JDK 17 + Android SDK 35 + Gradle 8.11.1.

```bash
gradle :app:assembleDebug
```

الملف الناتج:
`app/build/outputs/apk/debug/app-debug.apk`

يمكن كذلك تشغيل Workflow باسم **Build Noor Quran APK** من GitHub Actions وتحميل الـArtifact الناتج.

## المصادر

- نص Tanzil Uthmani 1.1، وفق CC BY 3.0.
- التفسير الميسر.
- الصوت من EveryAyah/QuranHub حسب القارئ المحدد داخل التطبيق.
