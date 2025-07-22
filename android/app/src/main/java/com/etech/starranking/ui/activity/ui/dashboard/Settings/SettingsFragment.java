package com.etech.starranking.ui.activity.ui.dashboard.Settings;

import android.os.Bundle;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.CompoundButton;

import androidx.annotation.NonNull;
import androidx.databinding.DataBindingUtil;

import com.etech.starranking.BuildConfig;
import com.etech.starranking.R;
import com.etech.starranking.app.StarRankingApp;
import com.etech.starranking.base.BaseFragment;
import com.etech.starranking.data.prefs.AppPreferencesHelper;
import com.etech.starranking.databinding.NavFragmentSettingsBinding;
import com.etech.starranking.ui.activity.model.LoginProfile;
import com.etech.starranking.ui.activity.model.Settings;
import com.etech.starranking.ui.activity.ui.dashboard.home.HomePresenter;
import com.etech.starranking.utils.AppUtils;


public class SettingsFragment extends BaseFragment implements SettingsContract.View {

    NavFragmentSettingsBinding binding;
    String pushalert = "", pushsound = "", pushvibrate = "";
    SettingsContract.Presenter<SettingsContract.View> presenter;
    LoginProfile user;
    public SettingsFragment() {

    }

    public static SettingsFragment newInstance(Bundle bundle) {
        SettingsFragment fragment = new SettingsFragment();
        if (bundle != null)
            fragment.setArguments(bundle);
        return fragment;
    }

    public View onCreateView(@NonNull LayoutInflater inflater,
                             ViewGroup container, Bundle savedInstanceState) {
        binding = DataBindingUtil.inflate(inflater, R.layout.nav_fragment_settings, container, false);
        presenter = new SettingsPresenter<>();
        presenter.onAttach(this);

         user = StarRankingApp.getDataManager().getUserFromPref();
        presenter.getSettings(user.getUser_id());



//        binding.btnComplete.setOnClickListener(new View.OnClickListener() {
//            @Override
//            public void onClick(View v) {
//                presenter.sendSettings(user.getUser_id(), pushalert, pushsound, pushvibrate);
//            }
//        });
        binding.tvAppVer.setText(getString(R.string.str_lbl_ver) + BuildConfig.VERSION_NAME);
        return binding.getRoot();
    }

    @Override
    public void onGetingSettings(Settings model) {
        Log.d("get settings","called");

        if (model.getPush_alert().equals("enabled")) {
            pushalert = "enabled";
            binding.swAlaram.setChecked(true);
            binding.swSoundNotification.setEnabled(true);
            binding.swVibrationAlert.setEnabled(true);
        } else {
            pushalert = "disabled";
            binding.swAlaram.setChecked(false);
            binding.swSoundNotification.setEnabled(false);
            binding.swVibrationAlert.setEnabled(false);
        }

        if (model.getPush_sound().equals("enabled")) {
            pushsound = "enabled";
            binding.swSoundNotification.setChecked(true);
        } else {
            pushsound = "disabled";
            binding.swSoundNotification.setChecked(false);
        }
        if (model.getPush_vibrate().equals("enabled")) {
            pushvibrate = "enabled";
            binding.swVibrationAlert.setChecked(true);
        } else {
            pushvibrate = "disabled";
            binding.swVibrationAlert.setChecked(false);
        }

        binding.swAlaram.setOnCheckedChangeListener(new CompoundButton.OnCheckedChangeListener() {
            @Override
            public void onCheckedChanged(CompoundButton buttonView, boolean isChecked) {

                if (isChecked) {
                    pushalert = "enabled";
                    Log.d("set settings","called");
                    presenter.sendSettings(user.getUser_id(), pushalert, pushsound, pushvibrate);
                    binding.swSoundNotification.setEnabled(true);
                    binding.swVibrationAlert.setEnabled(true);
                } else {
                    pushalert = "disabled";
                    Log.d("set settings","called");
                    presenter.sendSettings(user.getUser_id(), pushalert, pushsound, pushvibrate);
                    binding.swSoundNotification.setEnabled(false);
                    binding.swVibrationAlert.setEnabled(false);
                }


            }
        });
        binding.swSoundNotification.setOnCheckedChangeListener(new CompoundButton.OnCheckedChangeListener() {
            @Override
            public void onCheckedChanged(CompoundButton buttonView, boolean isChecked) {
                if (isChecked) {
                    pushsound = "enabled";
                    presenter.sendSettings(user.getUser_id(), pushalert, pushsound, pushvibrate);
                } else {
                    pushsound = "disabled";
                    presenter.sendSettings(user.getUser_id(), pushalert, pushsound, pushvibrate);
                }
            }
        });
        binding.swVibrationAlert.setOnCheckedChangeListener(new CompoundButton.OnCheckedChangeListener() {
            @Override
            public void onCheckedChanged(CompoundButton buttonView, boolean isChecked) {
                if (isChecked) {
                    pushvibrate = "enabled";
                    presenter.sendSettings(user.getUser_id(), pushalert, pushsound, pushvibrate);
                } else {
                    pushvibrate = "disabled";
                    presenter.sendSettings(user.getUser_id(), pushalert, pushsound, pushvibrate);
                }
            }
        });
    }

    @Override
    public void onsuccessSentSetings(String msg) {
        AppUtils.setToast(getContext(), msg);
    }

    @Override
    public void onRetryClicked() {
        super.onRetryClicked();
        presenter.retry();
    }
}