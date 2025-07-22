package com.etech.starranking.ui.activity.ui.emailOtpVerificationForForgotPwd;

import android.content.Intent;
import android.os.Bundle;
import android.os.CountDownTimer;
import android.util.Log;
import android.view.View;

import androidx.annotation.Nullable;
import androidx.databinding.DataBindingUtil;

import com.etech.starranking.R;
import com.etech.starranking.app.StarRankingApp;
import com.etech.starranking.base.BaseActivity;
import com.etech.starranking.databinding.ActivityEmailVerificationBinding;
import com.etech.starranking.ui.activity.model.EmailOtpVerify;
import com.etech.starranking.ui.activity.model.LoginProfile;
import com.etech.starranking.ui.activity.ui.createPassword.CreatePasswordActivity;
import com.etech.starranking.ui.activity.ui.dashboard.DashboardActivity;

import com.etech.starranking.utils.AppUtils;

import java.text.DecimalFormat;
import java.text.NumberFormat;

public class EmailOtpVerificationForgotPwdActivity extends BaseActivity implements
        EmailOtpVerificationForgotPwdContract.View {
    public ActivityEmailVerificationBinding binding;
    EmailOtpVerificationForgotPwdContract.Presenter<EmailOtpVerificationForgotPwdContract.View> presenter;
    String intentString="";
    String email="";
    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        binding = DataBindingUtil.setContentView(this, R.layout.activity_email_verification);
        setupView(binding.extraViews);
        presenter = new EmailOtpVerificationForgotPwdPresenter<>();
        presenter.onAttach(this);
        onClickListeners();
        setTimer();
       /* Intent intent = getIntent();
        intentString=intent.getStringExtra("Password");
        binding.etOtpNumber.setText(intentString);*/
        String email = StarRankingApp.getDataManager().getUserEmail().getEmail();
        if(email!=null && !email.isEmpty()){
            binding.tvEmail.setText(email);
        }
        binding.layoutTool.ibCharge.setVisibility(View.GONE);

        Log.d(TAG, "onCreate:Email "+email);
    }

    private void onClickListeners() {
        binding.layoutTool.ibBack.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                onBackPressed();
            }
        });

        binding.btnVerify.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if(isValid()){
                    presenter.emailOtpVerify(binding.tvEmail.getText().toString(),binding.etOtpNumber.getText().toString());
                }
            }
        });

        binding.tvResendOtp.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if(binding.tvTimer.getVisibility()== View.GONE){
                    presenter.resendOtp(binding.tvEmail.getText().toString());

                }
            }
        });
    }

    boolean isValid() {
        if (binding.etOtpNumber.getText().toString().equals("")) {
            AppUtils.setToast(getApplicationContext(), getString(R.string.str_hint_otp));
            binding.etOtpNumber.requestFocus();
            return false;
        } else if (binding.etOtpNumber.getText().toString().length() < 6) {
            AppUtils.setToast(getApplicationContext(), getString(R.string.str_hint_valid_otp));
            binding.etOtpNumber.requestFocus();
            return false;
        }
        return true;
    }

    public void setTimer(){
        new CountDownTimer(60000, 1000) {
            public void onTick(long millisUntilFinished) {
                // Used for formatting digit to be in 2 digits only
                NumberFormat f = new DecimalFormat("00");
                long hour = (millisUntilFinished / 3600000) % 24;
                long min = (millisUntilFinished / 60000) % 60;
                long sec = (millisUntilFinished / 1000) % 60;
                binding.tvTimer.setText(f.format(hour) + ":" + f.format(min) + ":" + f.format(sec));
            }
            // When the task is over it will print 00:00:00 there
            public void onFinish() {
                binding.tvTimer.setText("00:00:00");
                binding.tvTimer.setVisibility(View.GONE);
                binding.tvResendOtp.setTextColor(getResources().getColor(R.color.colorAccent));
            }
        }.start();
    }


    @Override
    public void onSuccessEmailVerification(LoginProfile model) {

        StarRankingApp.getDataManager().setUserId(model.getUser_id());
        Intent i = new Intent(EmailOtpVerificationForgotPwdActivity.this, CreatePasswordActivity.class);
        startActivity(i);
      //  finish();
    }

    @Override
    public void onfail(String message) {

    }



    @Override
    public void onSuccessOtpResend(EmailOtpVerify model) {
        Log.d(TAG, "onSuccessOtpResend: "+model.getOtp());
        binding.tvTimer.setVisibility(View.VISIBLE);
        binding.tvResendOtp.setTextColor(getResources().getColor(R.color.black));
        setTimer();
    }


    @Override
    public void onRetryClicked() {
        super.onRetryClicked();
        presenter.retry();
    }
}
