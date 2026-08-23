<manifest xmlns:android="http://schemas.android.com/apk/res/android" package="com.noor.quran" android:versionCode="10" android:versionName="1.0.0">
  <uses-sdk android:minSdkVersion="23" android:targetSdkVersion="35"/>
  <uses-permission android:name="android.permission.INTERNET"/>
  <uses-permission android:name="android.permission.WAKE_LOCK"/>
  <uses-permission android:name="android.permission.POST_NOTIFICATIONS"/>
  <uses-permission android:name="android.permission.RECEIVE_BOOT_COMPLETED"/>
  <uses-permission android:name="android.permission.VIBRATE"/>
  <uses-permission android:name="android.permission.ACCESS_FINE_LOCATION"/>
  <uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION"/>
  <application android:allowBackup="true" android:label="نور القرآن" android:icon="@drawable/icon" android:theme="@style/AppTheme" android:usesCleartextTraffic="false">
    <activity android:name=".MainActivity" android:screenOrientation="portrait" android:exported="true">
      <intent-filter>
        <action android:name="android.intent.action.MAIN"/><category android:name="android.intent.category.LAUNCHER"/>
      </intent-filter>
    </activity>
    <activity android:name=".TasbeehActivity" android:exported="false"/>
    <activity android:name=".AzkarActivity" android:exported="false"/>
    <activity android:name=".QiblaActivity" android:exported="false"/>
    <receiver android:name=".ReminderReceiver" android:exported="false"/>
    <receiver android:name=".BootReceiver" android:enabled="true" android:exported="true">
      <intent-filter><action android:name="android.intent.action.BOOT_COMPLETED"/></intent-filter>
    </receiver>
  </application>
</manifest>
