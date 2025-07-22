package com.etech.starranking.base;

import android.annotation.SuppressLint;
import android.app.Dialog;
import android.app.NotificationManager;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.graphics.Color;
import android.graphics.drawable.ColorDrawable;
import android.net.ConnectivityManager;
import android.net.Network;
import android.os.Build;
import android.os.Bundle;
import android.os.Handler;
import android.text.TextUtils;
import android.util.Log;
import android.view.View;
import android.view.ViewGroup;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.appcompat.app.AppCompatActivity;
import androidx.appcompat.widget.AppCompatButton;
import androidx.appcompat.widget.AppCompatTextView;
import androidx.appcompat.widget.Toolbar;
import androidx.fragment.app.FragmentManager;
import androidx.fragment.app.FragmentTransaction;
import androidx.localbroadcastmanager.content.LocalBroadcastManager;

import com.etech.starranking.BuildConfig;
import com.etech.starranking.R;
import com.etech.starranking.databinding.LayoutExtraViewsBinding;
import com.etech.starranking.ui.activity.ui.dashboard.DashboardActivity;
import com.etech.starranking.ui.activity.ui.dashboard.home.ContestListsFragment;
import com.etech.starranking.ui.activity.ui.splash.SplashActivity;
import com.etech.starranking.utils.AppUtils;
import com.etech.starranking.utils.Constants;
import com.tapadoo.alerter.Alerter;

import static com.etech.starranking.utils.Constants.LB_KEY_MESSAGE;


@SuppressLint("Registered")
public class BaseActivity extends AppCompatActivity implements BaseContractView {


    private BroadcastReceiver receiver;
    private LayoutExtraViewsBinding extraViews;

    @Override
    protected void onPostCreate(@Nullable Bundle savedInstanceState) {
        super.onPostCreate(savedInstanceState);
        View v = findViewById(R.id.tvTitle);
        if (v != null) {
            v.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                titleClicked();
                }
            });
        }

    }

    public void titleClicked() {
        Intent i = new Intent(getApplicationContext(), DashboardActivity.class);
        startActivity(i);
        finishAffinity();
    }

    @Override
    protected void onResume() {
        super.onResume();
        NotificationManager notificationManager = (NotificationManager) getSystemService(Context.NOTIFICATION_SERVICE);
        if (notificationManager != null)
            notificationManager.cancelAll();
    }

    protected final String TAG = BaseActivity.class.getName();
    Toolbar toolbar;

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        Log.d(TAG, "onCreate() called with: savedInstanceState = [" + savedInstanceState + "]");
    }


    public BaseFragment baseFragment;
    private int count = 0;

    public void addFragment(BaseFragment fragment, boolean isClearStack) {
        this.addFragment(fragment, isClearStack, true);
    }

    public void addFragment(BaseFragment fragment, boolean isClearStack, boolean isAddToStack) {
        Log.d(TAG, fragment.getClass().getName());
        String tag = fragment.getClass().getName() + count;
        baseFragment = fragment;
        if (isClearStack) {
            clearFragmentStack();
        }
        FragmentTransaction transaction = getSupportFragmentManager()
                .beginTransaction();
//        transaction.setCustomAnimations(android.R.anim.fade_in, android.R.anim.fade_out);

        if (isAddToStack)
            transaction.addToBackStack(tag);
        transaction.replace(R.id.frm_container, fragment, tag);
        transaction.commit();
        count = count + 1;
    }

    public void clearFragmentStack() {
        for (int i = 0; i < getSupportFragmentManager().getBackStackEntryCount(); i++) {
            String name = getSupportFragmentManager().getBackStackEntryAt(0).getName();
            getSupportFragmentManager().popBackStack(name, FragmentManager.POP_BACK_STACK_INCLUSIVE);
            break;
        }
    }

    public void setupView(LayoutExtraViewsBinding binding) {
        this.extraViews = binding;
        if (binding == null) return;
        binding.btnRetry.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                onRetryClicked();
            }
        });
    }

    public void onRetryClicked() {
        Log.d(TAG, "onRetryClicked() called");
        if (AppUtils.isConnectingToInternet()) {
            hideConnectionLost();
        }
        if (baseFragment != null)
            baseFragment.onRetryClicked();
    }

    @Override
    public void onRequestPermissionsResult(int requestCode, @NonNull String[] permissions, @NonNull int[] grantResults) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults);
        if (requestCode == Constants.PERMISSION_CODE) {
            if (AppUtils.isPermissionGranted(this, AppUtils.PERMISSIONS)) {
                Log.e("baseAct", "all permissions are granted");
            }
        }
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, @Nullable Intent data) {
        super.onActivityResult(requestCode, resultCode, data);

    }

    @Override
    public void showLoader() {
        if (extraViews == null) return;
        if (extraViews.llProgressContainer.getVisibility() == View.GONE) {
            extraViews.llProgressContainer.setVisibility(View.VISIBLE);
        }
    }

    @Override
    public void hideLoader() {
        if (extraViews == null) return;
        if (extraViews.llProgressContainer.getVisibility() == View.VISIBLE) {
            extraViews.llProgressContainer.setVisibility(View.GONE);
        }
    }

    @Override
    public void showConnectionLost() {
        if (extraViews == null) return;
        if (extraViews.llConnectionLostContainer.getVisibility() == View.GONE) {
            extraViews.llConnectionLostContainer.setVisibility(View.VISIBLE);
        }
        // extraViews.llConnectionLostContainer.setVisibility(View.VISIBLE);
    }

    @Override
    public void hideConnectionLost() {
        if (extraViews == null) return;
        if (extraViews.llConnectionLostContainer.getVisibility() == View.VISIBLE) {
            extraViews.llConnectionLostContainer.setVisibility(View.GONE);
        }
    }

    @Override
    public void showError(int code, String response) {

        final Dialog dialog = new Dialog(this);

        dialog.setContentView(R.layout.popup_layout_underdevelopment);

        dialog.getWindow().setLayout(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.WRAP_CONTENT);
        dialog.getWindow().setBackgroundDrawable(new ColorDrawable(Color.TRANSPARENT));
        dialog.setCancelable(false);
        final AppCompatTextView tvbar = (AppCompatTextView) dialog.findViewById(R.id.tvbar);
        ((AppCompatTextView) dialog.findViewById(R.id.tvAlreadyCheckedin)).setText(response);

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


    boolean isCalled = true;

    private void networkChangedReceived() {
        Log.d(TAG, "networkChangedReceived() called");
        boolean isConnected = AppUtils.isConnectingToInternet();

        if (isCalled) {
            isCalled = false;
            onNetworkChanged(isConnected);
            new Handler().postDelayed(new Runnable() {
                @Override
                public void run() {
                    isCalled = true;
                }
            }, 1000);
        } else {
            isCalled = true;
        }
    }

    public void onNetworkChanged(boolean networkchanged) {
        Log.d(TAG, "onNetworkChanged() called with: networkchanged = [" + networkchanged + "]");
        if (networkchanged) {
            onRetryClicked();
            hideConnectionLost();
        }

    }

    BroadcastReceiver receiverNotification = null;
    ConnectivityManager.NetworkCallback defaultNetworkCallback;
    boolean isFirstSkipped = false;

    @Override
    protected void onStart() {
        super.onStart();
        //noinspection RedundantIfStatement
        if (AppUtils.isConnectingToInternet())
            isFirstSkipped = false;
        else
            isFirstSkipped = true;
        if (receiverNotification == null) {
            receiverNotification = new BroadcastReceiver() {
                @Override
                public void onReceive(Context context, Intent intent) {
                    BaseActivity.this.onReceiverNotification(context, intent.getStringExtra(Constants.INTENT_NOTIFFICATION_TYPE), intent);
                }
            };
        }
        IntentFilter intentFilter = new IntentFilter();
        intentFilter.addAction(Constants.INTENT_FILTER_RECEIVER_NOTIFICATION);
        LocalBroadcastManager.getInstance(BaseActivity.this).registerReceiver(receiverNotification, intentFilter);

        if (android.os.Build.VERSION.SDK_INT < android.os.Build.VERSION_CODES.P) {
            if (receiver == null) {
                receiver = new BroadcastReceiver() {
                    @Override
                    public void onReceive(Context context, Intent intent) {
                        Log.d(TAG, "newtowrk change onReceive() called with: context = [" + context + "], intent = [" + intent + "]");
                        networkChangedReceived();
                    }
                };
            }
            IntentFilter intentFilterConnectivity = new IntentFilter(ConnectivityManager.CONNECTIVITY_ACTION);
            registerReceiver(receiver, intentFilterConnectivity);
        } else {
            ConnectivityManager connectivityManager = getSystemService(ConnectivityManager.class);
            if (connectivityManager != null) {

                if (defaultNetworkCallback == null) {
                    defaultNetworkCallback = new ConnectivityManager.NetworkCallback() {

                        @Override
                        public void onAvailable(@NonNull Network network) {
                            super.onAvailable(network);
                            Log.d(TAG, "newtowrk change onAvailable() called with: network = [" + network + "]");
                            runOnUiThread(new Runnable() {
                                @Override
                                public void run() {
                                    if (isFirstSkipped) {
                                        networkChangedReceived();
                                    } else {
                                        isFirstSkipped = true;
                                    }
                                }
                            });

                        }
                    };
                }
                connectivityManager.registerDefaultNetworkCallback(defaultNetworkCallback);
            }
        }

    }

    @Override
    protected void onStop() {
        super.onStop();
//        unregisterReceiver(receiver);
        if (receiverNotification != null)
            LocalBroadcastManager.getInstance(BaseActivity.this).unregisterReceiver(receiverNotification);
        if (receiver != null)
            unregisterReceiver(receiver);
        if (defaultNetworkCallback != null && android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.P) {
            ConnectivityManager connectivityManager = getSystemService(ConnectivityManager.class);
            if (connectivityManager != null)
                connectivityManager.unregisterNetworkCallback(defaultNetworkCallback);
        }
    }
//    public void setUpView(Toolbar toolbar, LayoutExtraViewsBinding extraViewBinding, String title, boolean isBackEnable) {
//        if(toolbar!=null)
//            this.toolbar = toolbar;
//
//        if(toolbar!=null)
//            setSupportActionBar(toolbar);
//        if (!TextUtils.isEmpty(title)) {
//            setTitle(title);
//        }
//        if (isBackEnable) {
//            if (getSupportActionBar() != null) {
//                getSupportActionBar().setDisplayHomeAsUpEnabled(true);
//                getSupportActionBar().setDisplayShowHomeEnabled(true);
//            }
//        }
//
//        if (extraViewBinding == null) return;
//
//    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        // do not remove this method from here
        Log.d(TAG, "onDestroy: ");
    }

    public void onReceiverNotification(Context context, String type, Intent intent) {
//        if (baseFragment != null)
//            baseFragment.onReceiverNotification(context, type, intent);
        Log.d(TAG, "onReceiverNotification: ");
        Alerter.create(this)
                .setText(intent.getStringExtra(LB_KEY_MESSAGE))
//                .setBackgroundColorRes(R.color.colorPrimary)
                .setBackgroundDrawable(getDrawable(R.drawable.toolbar_gradient))
                .setDuration(2000)
                .enableVibration(false)
                .show();

    }

    public void checkInternetAndShowNoInternetDialog() {
        if (!AppUtils.isConnectingToInternet()) {
            showError(Constants.FAIL_INTERNET_CODE, getString(R.string.str_msg_no_network_connection));
        }
    }

}
