package com.etech.starranking.services;

import android.app.ActivityManager;
import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.content.Context;
import android.content.Intent;
import android.media.AudioManager;
import android.media.Ringtone;
import android.media.RingtoneManager;
import android.net.Uri;
import android.os.Build;
import android.os.VibrationEffect;
import android.os.Vibrator;
import android.util.Log;

import androidx.annotation.NonNull;
import androidx.core.app.NotificationCompat;
import androidx.localbroadcastmanager.content.LocalBroadcastManager;

import com.etech.starranking.R;
import com.etech.starranking.app.StarRankingApp;
import com.etech.starranking.data.DataManager;
import com.etech.starranking.data.prefs.AppPreferencesHelper;
import com.etech.starranking.ui.activity.ui.splash.SplashActivity;
import com.etech.starranking.utils.AppUtils;
import com.etech.starranking.utils.Constants;
import com.google.firebase.messaging.FirebaseMessagingService;
import com.google.firebase.messaging.RemoteMessage;
import com.google.gson.JsonObject;


import org.json.JSONObject;

import java.util.List;
import java.util.Map;
import java.util.Random;

import static com.etech.starranking.utils.Constants.CHANNEL_ID;
import static com.etech.starranking.utils.Constants.CHANNEL_ID_SILENT;
import static com.etech.starranking.utils.Constants.LB_KEY_MESSAGE;
import static com.etech.starranking.utils.Constants.LB_TYPE_GENERAL;
import static com.etech.starranking.utils.Constants.LB_TYPE_STAR_UPDATED;

public class MyFirebaseService extends FirebaseMessagingService {
    private static final String TAG = "MyFirebaseMsgService";


    boolean isInBackground = false;
    static int count = 0;

    @Override
    public void onMessageReceived(RemoteMessage remoteMessage) {
        Log.d(TAG, "data Message Body: " + remoteMessage.getData());
        Log.d(TAG, "Notification Message Body: " + remoteMessage.getNotification());
        handleDataMessage(remoteMessage);

    }

    private void handleDataMessage(RemoteMessage remoteMessage) {
        Map<String, String> data = remoteMessage.getData();

        try {
            String strCustomParams = data.get("customParam");
            @SuppressWarnings("ConstantConditions") JSONObject jsonObject = new JSONObject(strCustomParams);

            String receiverId = jsonObject.getString("receiverId");
            String vibrate = null;
            if (jsonObject.has("vibrate"))
                vibrate = jsonObject.getString("vibrate");
            String sound = null;
            if (data.containsKey("sound"))
                sound = data.get("sound");

            DataManager dataManager = StarRankingApp.getDataManager();
            if (dataManager.get(AppPreferencesHelper.PREF_USER_ID, "").equals(receiverId)) {
                String lbType = LB_TYPE_GENERAL;
                if (jsonObject.has("receiver_star")) {
                    String receiverStar = jsonObject.getString("receiver_star");
                    dataManager.set(AppPreferencesHelper.PREF_USER_STARS, receiverStar);
                    lbType = LB_TYPE_STAR_UPDATED;
                }
                if (isInBackground(this)) {
                    showNotification(jsonObject.getString("messageTitle"), data.get("message"), sound, vibrate);
                } else {
                    sendLocalBroadCastWithMessage(lbType, data.get("message"));
                    vibrateIfNeeded(vibrate);
                    playNotificationSoundIfNeeded(sound);
                }


            }


        } catch (Exception e) {
            Log.e(TAG, "handleDataMessage: error ", e);
        }


    }

    private void playNotificationSoundIfNeeded(String sound) {
        if ("enabled".equals(sound) || "default".equals(sound)) {
            try {
                Uri notification = RingtoneManager.getDefaultUri(RingtoneManager.TYPE_NOTIFICATION);
                Ringtone r = RingtoneManager.getRingtone(getApplicationContext(), notification);
                r.play();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }

    private void vibrateIfNeeded(String vibrate) {
        if ("enabled".equals(vibrate) || "default".equals(vibrate)) {
            Vibrator v = (Vibrator) getSystemService(Context.VIBRATOR_SERVICE);
// Vibrate for 500 milliseconds
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                v.vibrate(VibrationEffect.createOneShot(500, VibrationEffect.DEFAULT_AMPLITUDE));
            } else {
                //deprecated in API 26
                v.vibrate(500);
            }
        }

    }

    private void sendLocalBroadCastWithMessage(String lbType, String message) {
        Intent intentFinal = AppUtils.getReceiverNotificationIntent(lbType);
        intentFinal.putExtra(LB_KEY_MESSAGE, message);
        LocalBroadcastManager.getInstance(this).sendBroadcast(intentFinal);
        Log.d(TAG, "sendBroadcast()");
    }

    private void showNotification(String title, String message, String sound, String vibrate) {
        createNotificationChannel();
        Intent notifyIntent = new Intent(this, SplashActivity.class);
// Set the Activity to start in a new, empty task
        notifyIntent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK
                | Intent.FLAG_ACTIVITY_CLEAR_TASK);
// Create the PendingIntent
        PendingIntent notifyPendingIntent = PendingIntent.getActivity(
                this, 0, notifyIntent, PendingIntent.FLAG_UPDATE_CURRENT
        );
        NotificationCompat.Builder builder = new NotificationCompat.Builder(this, getSound(sound)==null?CHANNEL_ID_SILENT:CHANNEL_ID)
                .setSmallIcon(R.drawable.monochrome_icon)
                .setContentTitle(title)
                .setContentText(message)
                .setPriority(NotificationCompat.PRIORITY_DEFAULT)
                .setContentIntent(notifyPendingIntent)
                .setSound(getSound(sound),AudioManager.STREAM_NOTIFICATION)
                ;
        if(getSound(sound)==null){
            builder.setDefaults(0);
        }

        NotificationManager notificationManager = (NotificationManager) getSystemService(Context.NOTIFICATION_SERVICE);
        notificationManager.notify(new Random().nextInt(), builder.build());
        vibrateIfNeeded(vibrate);
//todo show notification only
    }

    private Uri getSound(String sound) {
        if ("enabled".equals(sound) || "default".equals(sound)) {
            Log.d(TAG, "getSound: enabled");
            return RingtoneManager.getDefaultUri(RingtoneManager.TYPE_NOTIFICATION);
        } else {
            Log.d(TAG, "getSound: disabled");
            return null;
        }
    }

    private void createNotificationChannel() {
        // Create the NotificationChannel, but only on API 26+ because
        // the NotificationChannel class is new and not in the support library
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            CharSequence name = getString(R.string.channel_name);
            String description = getString(R.string.channel_description);
            int importance = NotificationManager.IMPORTANCE_DEFAULT;
            NotificationChannel channel = new NotificationChannel(CHANNEL_ID, name, importance);
            channel.setDescription(description);
            // Register the channel with the system; you can't change the importance
            // or other notification behaviors after this
            NotificationManager notificationManager = getSystemService(NotificationManager.class);
            notificationManager.createNotificationChannel(channel);
            name = "Silent Notification";
            description = "Silent Notification";
            importance = NotificationManager.IMPORTANCE_LOW;
            channel = new NotificationChannel(CHANNEL_ID_SILENT, name, importance);
            channel.setDescription(description);
            notificationManager.createNotificationChannel(channel);
        }
    }

    private boolean isInBackground(Context context) {
        boolean isInBackground = true;
        ActivityManager am = (ActivityManager) context.getSystemService(Context.ACTIVITY_SERVICE);
        @SuppressWarnings("ConstantConditions") List<ActivityManager.RunningAppProcessInfo> runningProcesses = am.getRunningAppProcesses();
        for (ActivityManager.RunningAppProcessInfo processInfo : runningProcesses) {
            if (processInfo.importance == ActivityManager.RunningAppProcessInfo.IMPORTANCE_FOREGROUND) {
                for (String activeProcess : processInfo.pkgList) {
                    if (activeProcess.equals(context.getPackageName())) {
                        isInBackground = false;
                    }
                }
            }
        }
        return isInBackground;
    }


    @Override
    public void onNewToken(@NonNull String s) {
        super.onNewToken(s);
        Log.d(TAG,"onNewToken : "+s);
//        StarRankingApp.getDataManager().doSignup();
    }


}
