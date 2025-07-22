package com.etech.starranking.base;

import android.app.Activity;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.os.Bundle;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.Menu;
import android.view.View;
import android.view.ViewGroup;

import androidx.annotation.Nullable;
import androidx.fragment.app.Fragment;
import androidx.localbroadcastmanager.content.LocalBroadcastManager;

import com.etech.starranking.utils.Constants;


public class BaseFragment extends Fragment implements BaseContractView {

    public BaseActivity activity;
    public Menu menu;
    private BroadcastReceiver receiverNotification;

    @Override
    public void onCreate(@Nullable Bundle savedInstanceState) {
        init();
        super.onCreate(savedInstanceState);
        setHasOptionsMenu(true);
    }

    @Nullable
    @Override
    public View onCreateView(LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        init();
        return super.onCreateView(inflater, container, savedInstanceState);
    }

    public void init() {
//        AppUtils.setLocalLanguage(requireContext(),"ko");
        Activity activity = getActivity();
        if (activity instanceof BaseActivity) {
            this.activity = (BaseActivity) activity;
        }
        if (receiverNotification == null) {
            receiverNotification = new BroadcastReceiver() {
                @Override
                public void onReceive(Context context, Intent intent) {
                    onReceiverNotification(context, intent.getStringExtra(Constants.INTENT_NOTIFFICATION_TYPE), intent);
                }
            };
        }
        IntentFilter intentFilter = new IntentFilter();
        intentFilter.addAction(Constants.INTENT_FILTER_RECEIVER_NOTIFICATION);
        LocalBroadcastManager.getInstance(getActivity()).registerReceiver(receiverNotification, intentFilter);

    }

    public void onRetryClicked() {
        Log.d("BaseFragment", "onRetryCalled");
    }

    public void onNetworkChanged(Boolean isNetworkChanged) {
        Log.d("BaseFragment", "onNet");
    }

    public void onReceiverNotification(Context context, String type, Intent intent) {
        Log.d("BaseFragment", "onNotification");
    }


    @Override
    public void showLoader() {
        if (activity != null) {
            activity.showLoader();
        }


    }

    @Override
    public void hideLoader() {
        if (activity != null) {
            activity.hideLoader();
        }
    }

    @Override
    public void showConnectionLost() {
        if (activity != null) {
            activity.showConnectionLost();
        }
    }

    @Override
    public void hideConnectionLost() {
        if (activity != null) {
            activity.hideConnectionLost();
        }
    }

    @Override
    public void showError(int code, String res) {
        if (activity != null) {
            activity.showError(code, res);
        }
    }

    @Override
    public void onDestroy() {
        super.onDestroy();
        if (receiverNotification != null)
            LocalBroadcastManager.getInstance(getActivity()).unregisterReceiver(receiverNotification);
        // do not remove this method
    }
}
