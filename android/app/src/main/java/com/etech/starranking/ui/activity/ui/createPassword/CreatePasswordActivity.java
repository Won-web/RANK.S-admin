package com.etech.starranking.ui.activity.ui.createPassword;

import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import android.view.View;

import androidx.annotation.Nullable;
import androidx.databinding.DataBindingUtil;

import com.etech.starranking.R;
import com.etech.starranking.app.StarRankingApp;
import com.etech.starranking.base.BaseActivity;
import com.etech.starranking.databinding.ActivityCreateNewPasswordBinding;
import com.etech.starranking.ui.activity.model.LoginProfile;
import com.etech.starranking.ui.activity.ui.emailOtpVerificationForForgotPwd.EmailOtpVerificationForgotPwdActivity;
import com.etech.starranking.ui.activity.ui.login.LoginActivity;
import com.etech.starranking.utils.AppUtils;

public class CreatePasswordActivity extends BaseActivity implements
        CreatePasswordContract.View {
    ActivityCreateNewPasswordBinding binding;
    CreatePasswordContract.Presenter<CreatePasswordContract.View> presenter;

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        binding = DataBindingUtil.setContentView(this, R.layout.activity_create_new_password);
        presenter = new CreatePasswordPresenter<>();
        presenter.onAttach(this);
        setOnClickListeners();
        setupView(binding.extraViews);
        binding.layoutTool.ibCharge.setVisibility(View.GONE);

    }

    public void setOnClickListeners(){

        binding.layoutTool.ibBack.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                onBackPressed();
            }
        });

        binding.btnSubmit.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if(isValid()){
                    Log.d(TAG, "onClick:userID "+StarRankingApp.getDataManager().getUserId().getUser_id());
                     presenter.createNewPassword(StarRankingApp.getDataManager().getUserId().getUser_id(),binding.etSignupPwd.getText().toString());
                }
            }
        });
    }

    public boolean isValid() {
        if (binding.etSignupPwd.getText().toString().equals("")) {
            AppUtils.setToast(getApplicationContext(), getString(R.string.str_hint_password));
            binding.etSignupPwd.requestFocus();
            return false;
        } else if (binding.etSignupPwd.getText().toString().length() < 8) {
            AppUtils.setToast(getApplicationContext(), getString(R.string.str_hint_valid_password));
            binding.etSignupPwd.requestFocus();
            return false;
        } else if (binding.etSignupRepwd.getText().toString().equals("")) {
            AppUtils.setToast(getApplicationContext(), getString(R.string.str_hint_re_password));
            binding.etSignupPwd.requestFocus();
            return false;
        } else if (!binding.etSignupRepwd.getText().toString().equals(binding.etSignupPwd.getText().toString())) {
            AppUtils.setToast(getApplicationContext(), getString(R.string.str_hint_must_be_same));
            binding.etSignupRepwd.requestFocus();
            return false;
        }
        return true;
    }

    @Override
    public void onSuccessCreateNewPassword() {
        AppUtils.setToast(getApplicationContext(), getString(R.string.str_val_forgot_pwd));
        Intent i = new Intent(CreatePasswordActivity.this, LoginActivity.class);
        startActivity(i);
        finish();
    }

    @Override
    public void onfail(String message) {

    }
    @Override
    public void onRetryClicked() {
        super.onRetryClicked();
        presenter.retry();
    }
}
