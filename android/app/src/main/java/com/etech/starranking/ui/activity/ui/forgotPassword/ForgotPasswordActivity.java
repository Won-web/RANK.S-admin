package com.etech.starranking.ui.activity.ui.forgotPassword;

import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import android.view.View;

import androidx.annotation.Nullable;
import androidx.databinding.DataBindingUtil;

import com.etech.starranking.R;
import com.etech.starranking.app.StarRankingApp;
import com.etech.starranking.base.BaseActivity;
import com.etech.starranking.databinding.ActivityForgotPasswordBinding;
import com.etech.starranking.ui.activity.model.EmailOtpVerify;
import com.etech.starranking.ui.activity.model.LoginProfile;
import com.etech.starranking.ui.activity.ui.emailOtpVerification.EmailOtpVerificationActivity;
import com.etech.starranking.ui.activity.ui.emailOtpVerification.EmailOtpVerificationContract;
import com.etech.starranking.ui.activity.ui.emailOtpVerificationForForgotPwd.EmailOtpVerificationForgotPwdActivity;
import com.etech.starranking.ui.activity.ui.login.LoginContract;
import com.etech.starranking.utils.AppUtils;

public class ForgotPasswordActivity extends BaseActivity implements
        ForgotPasswordContract.View {
    ActivityForgotPasswordBinding binding;
    ForgotPasswordContract.Presenter<ForgotPasswordContract.View> presenter;
    String emailPattern = "[a-zA-Z0-9._-]+@[a-z]+\\.+[a-z]+";


    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        binding = DataBindingUtil.setContentView(this, R.layout.activity_forgot_password);
        presenter = new ForgotPasswordPresenter<>();
        presenter.onAttach(this);
        setupView(binding.extraViews);
        binding.layoutTool.ibCharge.setVisibility(View.GONE);

        setOnClickListeners();
    }

    public void setOnClickListeners() {
        binding.layoutTool.ibBack.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                onBackPressed();
            }
        });

        binding.btnSend.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (isValid()) {
                    StarRankingApp.getDataManager().saveUserEmail(binding.etForgotEmail.getText().toString());
                    presenter.emailVerificationForForgotPassword(binding.etForgotEmail.getText().toString());

                }
            }
        });
    }

    boolean isValid() {
        if (binding.etForgotEmail.getText().toString().equals("")) {
            AppUtils.setToast(getApplicationContext(), getString(R.string.str_val_email));
            binding.etForgotEmail.requestFocus();
            return false;
        } else if (!binding.etForgotEmail.getText().toString().matches(emailPattern)) {
            AppUtils.setToast(getApplicationContext(), getString(R.string.str_hint_enter_valid_email));
            binding.etForgotEmail.requestFocus();
            return false;
        }
        return true;
    }

    @Override
    public void onSuccessEmailVerification(EmailOtpVerify model) {
        StarRankingApp.getDataManager().setUserId(model.getUser_id());
        Intent intent = new Intent(ForgotPasswordActivity.this, EmailOtpVerificationForgotPwdActivity.class);
        startActivity(intent);
        Log.d(TAG, "onSuccessSignUp: OTP"+model.getOtp());

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