package com.etech.starranking.utils;

import android.Manifest;
import android.app.Activity;
import android.app.Dialog;
import android.content.Context;
import android.content.Intent;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;
import android.graphics.Bitmap;
import android.graphics.Color;
import android.graphics.drawable.ColorDrawable;
import android.graphics.drawable.Drawable;
import android.net.ConnectivityManager;
import android.net.NetworkInfo;
import android.net.Uri;
import android.os.Build;
import android.os.Environment;
import android.text.Editable;
import android.text.TextUtils;
import android.text.TextWatcher;
import android.view.View;
import android.view.ViewGroup;
import android.view.Window;
import android.view.WindowManager;
import android.widget.ImageView;
import android.widget.Toast;

import androidx.annotation.DrawableRes;
import androidx.annotation.Nullable;
import androidx.appcompat.widget.AppCompatButton;
import androidx.appcompat.widget.AppCompatEditText;
import androidx.appcompat.widget.AppCompatTextView;

import com.bumptech.glide.Glide;
import com.bumptech.glide.load.DataSource;
import com.bumptech.glide.load.engine.DiskCacheStrategy;
import com.bumptech.glide.load.engine.GlideException;
import com.bumptech.glide.request.RequestListener;
import com.bumptech.glide.request.RequestOptions;
import com.bumptech.glide.request.target.Target;
import com.etech.starranking.R;
import com.etech.starranking.app.StarRankingApp;
import com.etech.starranking.data.network.apiHelper.RestResponse;
import com.etech.starranking.data.prefs.AppPreferencesHelper;
import com.etech.starranking.ui.activity.StarChargingWebview;
import com.etech.starranking.ui.activity.model.LoginProfile;
import com.mikhaellopez.circularimageview.CircularImageView;

import org.json.JSONObject;

import java.io.File;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;

import static com.etech.starranking.utils.Constants.RES_CODE_KEY;
import static com.etech.starranking.utils.Constants.RES_MSG_KEY;


public class AppUtils {

    public static Context context;
    public static String[] PERMISSIONS = new String[]{
            Manifest.permission.INTERNET,
            Manifest.permission.ACCESS_NETWORK_STATE,
            Manifest.permission.READ_PHONE_STATE
    };

    public static String[] WRITE_STORAGE = new String[]{
            Manifest.permission.WRITE_EXTERNAL_STORAGE,
            Manifest.permission.CAMERA
    };

    public static String LANGUAGE_DEFAULT_VALUE = "english";

//    public static String[] PHONE_READ_PERMISSION = new String[]{
//            Manifest.permission.READ_PHONE_NUMBERS,
//            Manifest.permission.READ_PHONE_STATE,
//            Manifest.permission.READ_SMS
//
//    };

    public static void setToast(Context context, String msg) {

        Toast.makeText(context, msg, Toast.LENGTH_SHORT).show();

    }

    public static void loginPopup(Context context) {
        final Dialog dialog = new Dialog(context);
        dialog.setContentView(R.layout.popup_loginfirst_alert);
        dialog.getWindow().setLayout(ViewGroup.LayoutParams.WRAP_CONTENT, ViewGroup.LayoutParams.WRAP_CONTENT);
        dialog.getWindow().setBackgroundDrawable(new ColorDrawable(Color.TRANSPARENT));
        dialog.setCancelable(true);

        final AppCompatButton btnpopuploginok = (AppCompatButton) dialog.findViewById(R.id.btnpopuploginok);

        btnpopuploginok.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                dialog.dismiss();
            }
        });

        dialog.show();
    }

    public static void logoutPopup(Context context) {
        final Dialog dialog = new Dialog(context);
        dialog.setContentView(R.layout.popup_logout_alert);
        dialog.getWindow().setLayout(ViewGroup.LayoutParams.WRAP_CONTENT, ViewGroup.LayoutParams.WRAP_CONTENT);
        dialog.getWindow().setBackgroundDrawable(new ColorDrawable(Color.TRANSPARENT));
        dialog.setCancelable(true);

        final AppCompatButton btnpopuploginok = (AppCompatButton) dialog.findViewById(R.id.btnpopuploginok);

        btnpopuploginok.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                dialog.dismiss();
            }
        });

        dialog.show();
    }

    public static boolean isConnectingToInternet() {
        ConnectivityManager cm = (ConnectivityManager) StarRankingApp.appContext.getSystemService(Context.CONNECTIVITY_SERVICE);
        NetworkInfo networkInfo = cm.getActiveNetworkInfo();

        return (networkInfo != null && networkInfo.isConnected());
    }

    public static boolean isPermissionGranted(Activity context, String[] permissions) {
        boolean flag = false;
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            for (String per : permissions) {
                if (context.checkSelfPermission(per) == PackageManager.PERMISSION_GRANTED) {
                    flag = true;
                } else {
                    flag = false;
                    break;
                }
            }
        } else {
            flag = true;
        }

        return flag;

    }

    private static boolean checkFirstTimePermission(String permission[]) {
        for (String s : permission) {
            if (!StarRankingApp.getDataManager().getBooleanAppPref(s, false)) {
                return true;
            }
        }
        return false;
    }

    public static boolean AskAndCheckPermission(Activity context, String permission[], int requestCode) {
        boolean flag = false;
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            if (checkFirstTimePermission(permission)) {
                context.requestPermissions(permission, requestCode);
                for (String s : permission) {
                    StarRankingApp.getDataManager().setBooleanAppPref(s, true);
                }
            } else {
                if (isPermissionGranted(context, permission))
                    return true;
                for (String per : permission) {
                    if (context.checkSelfPermission(per) != PackageManager.PERMISSION_GRANTED && !context.shouldShowRequestPermissionRationale(per)) {
                        flag = true;
                        break;
                    } else {
                        flag = false;
                    }
                }

                if (flag) {
                    flag = false;
                    CustomAlertDialog.showPermissionAlert(context, context.getResources().getString(R.string.msg_alert_you_have_permission));
                } else {
                    context.requestPermissions(permission, requestCode);
                }
            }
        } else {
            return true;
        }
        return flag;
    }

    public static JSONObject checkResponse(int code, String message, RestResponse restResponse) {

        if (code == Constants.SUCCESS_CODE) {
            int flag;
            try {
                JSONObject res = new JSONObject(restResponse.getResString());
//                Log.d("response ", res.toString());
                flag = res.getInt(RES_CODE_KEY);
                String msg = res.getString(RES_MSG_KEY);
                if (flag == 1) {
                } else {
                    res = null;
                }
                return res;

            } catch (Exception e) {
                e.printStackTrace();
            }
        } else if (code == Constants.FAIL_CODE) {

        } /*else if (code == 3) {
            StarRankingApp.getDataManager().getTokenFromRefreshToken();
        }*/
        return null;

    }

    public static void visibility(View view, int visibilty) {
        if (view == null) return;
        if (view.getVisibility() == visibilty) {
            view.setVisibility(visibilty);
        }
    }

    public static void setImageUrl(Context context, String path, final ImageView imageView) {
        setImageUrl(context, path, imageView, true);
    }

    public static void setImageUrl(Context context, String path, final ImageView imageView, boolean isAddBgColor) {
        setImageUrl(context, path, imageView, isAddBgColor, R.drawable.home_main_holder);
    }

    public static void setImageUrl(Context context, String path, final ImageView imageView, boolean isAddBgColor, @DrawableRes int placeHolder) {
        if (isAddBgColor)
            imageView.setBackgroundResource(R.color.image_bg);
        if (!TextUtils.isEmpty(path)) {
            RequestOptions requestOptions = new RequestOptions()
//                    .diskCacheStrategy(DiskCacheStrategy.NONE) // because file name is always same
                    .placeholder(placeHolder)
                    .timeout(0)
//                    .skipMemoryCache(true)
                    ;

            Glide.with(context).load(path)
                    .apply(requestOptions)
                    .into(imageView);
        } else {
            Glide.with(context).load(placeHolder).into(imageView);
        }

    }

    public static void setImageUrl(Context context, Uri path, final ImageView imageView) {
        imageView.setBackgroundResource(R.color.image_bg);
        if (path != null) {
            RequestOptions requestOptions = new RequestOptions()
//                    .diskCacheStrategy(DiskCacheStrategy.NONE) // because file name is always same
                    .skipMemoryCache(true);

            Glide.with(context).load(path)
                    .apply(requestOptions)
                    .into(imageView);
        }

    }

    public static void callStarChargigWebview(Context context) {
        callStarChargigWebview(context, null);
    }

    public static void callStarChargigWebview(Context context, String contestId) {
        LoginProfile user = StarRankingApp.getDataManager().getUserFromPref();
        if (!user.getUser_id().equals("")) {
            Intent i = new Intent(context, StarChargingWebview.class);
            i.putExtra(StarChargingWebview.ARG_CONTEST_ID, contestId);
            context.startActivity(i);
        } else {
            loginPopup(context);
        }


    }

    //    public static void giftStarPopup(Context context){
//        final Dialog dialog = new Dialog(context);
//        dialog.setContentView( R.layout.popup_sendstar);
//        dialog.getWindow().setLayout(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.WRAP_CONTENT);
//        dialog.getWindow().setBackgroundDrawable(new ColorDrawable(Color.TRANSPARENT));
//
//        dialog.setCancelable(false);
//        final AppCompatTextView votebar = (AppCompatTextView) dialog.findViewById(R.id.bar);
//        final AppCompatTextView tvpopupStarsAmt = (AppCompatTextView) dialog.findViewById(R.id.tvpopupStarsAmt);
//        final AppCompatEditText giftNo = (AppCompatEditText) dialog.findViewById(R.id.giftMobileNo);
//        final AppCompatEditText giftVotesAmt = (AppCompatEditText) dialog.findViewById(R.id.giftVotesAmt);
//        final AppCompatTextView btn = (AppCompatTextView) dialog.findViewById(R.id.giftbtnUseAll);
//        giftto_name = (AppCompatTextView) dialog.findViewById(R.id.giftto_name);
//        final AppCompatTextView giftWarining = (AppCompatTextView) dialog.findViewById(R.id.giftWarining);
//        final AppCompatTextView giftHint = (AppCompatTextView) dialog.findViewById(R.id.giftHint);
//        final AppCompatButton btnConfirm = (AppCompatButton) dialog.findViewById(R.id.btnConfirm);
//
//        mobileProfile = (CircularImageView) dialog.findViewById(R.id.mobileProfile);
//        starGift = (CircularImageView) dialog.findViewById(R.id.star);
//
//        // LoginProfile user = StarRankingApp.getDataManager().getUserFromPref();
//
//
//        tvpopupStarsAmt.setText(user.getRemaining_star());
//        btn.setOnClickListener(new View.OnClickListener() {
//            @Override
//            public void onClick(View v) {
//                giftVotesAmt.setText(user.getRemaining_star());
//            }
//        });
//        giftVotesAmt.addTextChangedListener(new TextWatcher() {
//            @Override
//            public void beforeTextChanged(CharSequence s, int start, int count, int after) {
//
//            }
//
//            @Override
//            public void onTextChanged(CharSequence s, int start, int before, int count) {
//
//            }
//
//            @Override
//            public void afterTextChanged(Editable s) {
//                giftto_name.setVisibility(View.VISIBLE);
//
//                giftto_name.setText(gift_username + " " + getResources().getString(R.string.str_lbl_gift_to) + " " + giftVotesAmt.getText().toString() + " " + getResources().getString(R.string.str_lbl_gift_surity));
//
//                giftWarining.setVisibility(View.VISIBLE);
//                giftHint.setVisibility(View.GONE);
//                starGift.setBorderColor(getResources().getColor(R.color.colorAccent));
//
//                if(!giftVotesAmt.getText().toString().equals(""))
//                    if (Integer.parseInt(giftVotesAmt.getText().toString()) > Integer.parseInt(user.getRemaining_star())) {
//                        AppUtils.setToast(getContext(), getResources().getString(R.string.str_not_enough_star));
//                        btnConfirm.setClickable(false);
//                        btnConfirm.setBackgroundColor(getResources().getColor(R.color.grey));
//                    } else {
//                        btnConfirm.setClickable(true);
//                        btnConfirm.setBackgroundColor(getResources().getColor(R.color.colorAccent));
//                    }
//            }
//        });
//
//        giftNo.addTextChangedListener(new TextWatcher() {
//            @Override
//            public void beforeTextChanged(CharSequence s, int start, int count, int after) {
//            }
//
//            @Override
//            public void onTextChanged(CharSequence s, int start, int before, int count) {
//                if (s.toString().length() == 11) {
//                    presenter.getdetails(s.toString());
//                }
//
//            }
//
//            @Override
//            public void afterTextChanged(Editable s) {
//
//
//            }
//        });
//
//
//        votebar.setOnClickListener(new View.OnClickListener() {
//            @Override
//            public void onClick(View v) {
//                dialog.dismiss();
//            }
//        });
//        btnConfirm.setOnClickListener(new View.OnClickListener() {
//            @Override
//            public void onClick(View v) {
//                dialog.dismiss();
//                if (gift_userid == null) {
//                    AppUtils.setToast(getContext(), "Please provide valid user");
//                } else {
//                    presenter.sendgift(gift_userid, user.getUser_id(), giftVotesAmt.toString());
//                }
//
//            }
//        });
//
//        dialog.show();
//    }
    public static void gradientStatusbar(Activity activity) {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
            Window window = activity.getWindow();
//            Drawable background = activity.getResources().getDrawable(R.drawable.toolbar_gradient);
//            window.addFlags(WindowManager.LayoutParams.FLAG_DRAWS_SYSTEM_BAR_BACKGROUNDS);
            window.setStatusBarColor(activity.getResources().getColor(R.color.status_bar_color));
//            window.setBackgroundDrawable(background);
        }
    }

    public static Intent getReceiverNotificationIntent(String type) {
        Intent intent = new Intent();
        intent.setAction(Constants.INTENT_FILTER_RECEIVER_NOTIFICATION);
        intent.putExtra(Constants.INTENT_NOTIFFICATION_TYPE, type);
        return intent;
    }

    public static File getOutputMediaFileForImage() {
        File mediaStorageDir = Environment.getExternalStoragePublicDirectory(
                Environment.DIRECTORY_PICTURES);

        if (!mediaStorageDir.exists()) {
            if (!mediaStorageDir.mkdirs()) {
                return null;
            }
        }

        String timeStamp = new SimpleDateFormat("yyyyMMdd_HHmmss").format(new Date());
        return new File(mediaStorageDir.getPath() + File.separator +
                "IMG_" + timeStamp + ".jpg");
    }

    public static File getOutputMediaFileForVideo() {
        File mediaStorageDir = Environment.getExternalStoragePublicDirectory(
                Environment.DIRECTORY_MOVIES);

        if (!mediaStorageDir.exists()) {
            if (!mediaStorageDir.mkdirs()) {
                return null;
            }
        }

        String timeStamp = new SimpleDateFormat("yyyyMMdd_HHmmss").format(new Date());
        return new File(mediaStorageDir.getPath() + File.separator +
                "VID_" + timeStamp + ".mp4");
    }

    public static String getFormatedString(String s) {
        if (s != null) {
            return String.format("%,d", Long.parseLong(s));
        } else {
            return null;
        }


    }

    public static void showGiftSuccessDialog(Context context, String name, String stars) {
        final Dialog dialog = new Dialog(context);
        dialog.setContentView(R.layout.popup_layout_underdevelopment);
        dialog.getWindow().setLayout(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.WRAP_CONTENT);
        dialog.getWindow().setBackgroundDrawable(new ColorDrawable(Color.TRANSPARENT));
        dialog.setCancelable(true);
        final AppCompatTextView tvbar = (AppCompatTextView) dialog.findViewById(R.id.tvbar);
        String text = String.format(context.getString(R.string.str_msg_gift_success), name, stars);
        ((AppCompatTextView) dialog.findViewById(R.id.tvAlreadyCheckedin)).setText(text);
        final AppCompatButton btnConfirm = (AppCompatButton) dialog.findViewById(R.id.btndone);
        btnConfirm.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                dialog.dismiss();
            }
        });
        tvbar.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                dialog.dismiss();
            }
        });
        dialog.show();
    }


    public static Date getVoteStartAndCloseDate(String dateInString){
        SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        Date date = new Date();
        try {
            date = format.parse(dateInString);
            System.out.println(date);
        } catch (ParseException e) {
            e.printStackTrace();
        }
        return date;
    }

}
