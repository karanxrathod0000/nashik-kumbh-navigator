# Flutter Wrapper
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.**  { *; }
-keep class io.flutter.plugins.**  { *; }

# Google Play Core & Flutter Deferred Components
-dontwarn com.google.android.play.core.**
-dontwarn io.flutter.embedding.android.FlutterPlayStoreSplitApplication
-dontwarn io.flutter.embedding.engine.deferredcomponents.**

# Firebase & Google Services
-keep class com.google.firebase.** { *; }
-keep class com.google.android.gms.** { *; }
-dontwarn com.google.firebase.**
-dontwarn com.google.android.gms.**

# Google Maps Flutter Plugin
-keep class io.flutter.plugins.googlemaps.** { *; }
-keep class com.google.android.gms.maps.** { *; }

# Geolocator & Permission Handler
-keep class com.baseflow.permissionhandler.** { *; }
-keep class com.baseflow.geolocator.** { *; }

# General keep rules for Android Parcelable / Serializable classes
-keepclassmembers class * implements android.os.Parcelable {
    public static final android.os.Parcelable$Creator CREATOR;
}
-keepclassmembers class **.R$* {
    public static <fields>;
}

# Preserve annotations
-keepattributes *Annotation*,Signature,InnerClasses,EnclosingMethod
