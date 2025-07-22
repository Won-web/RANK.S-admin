package com.etech.starranking.ui.activity.ui.signin;

import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.CompoundButton;

import androidx.databinding.DataBindingUtil;

import com.etech.starranking.R;
import com.etech.starranking.app.StarRankingApp;
import com.etech.starranking.base.BaseActivity;
import com.etech.starranking.databinding.ActivitySignUpBinding;
import com.etech.starranking.ui.activity.SampleWebViewActivity;
import com.etech.starranking.ui.activity.model.EmailOtpVerify;
import com.etech.starranking.ui.activity.model.LoginProfile;

import com.etech.starranking.ui.activity.ui.dashboard.DashboardActivity;
import com.etech.starranking.ui.activity.ui.emailOtpVerification.EmailOtpVerificationActivity;
import com.etech.starranking.ui.activity.ui.login.LoginActivity;
import com.etech.starranking.utils.AppUtils;

import static com.etech.starranking.utils.Constants.LOGIN_TYPE_FACEBOOK;
import static com.etech.starranking.utils.Constants.LOGIN_TYPE_GOOGLE;
import static com.etech.starranking.utils.Constants.LOGIN_TYPE_KAKAO;
import static com.etech.starranking.utils.Constants.LOGIN_TYPE_NAVER;

@SuppressWarnings("Convert2Lambda")
public class SignUpActivity extends BaseActivity implements
        SignUpContract.View {

    public static final String ARG_IS_SOCIAL_SIGN_UP = "arg_IsSocialSignUp_SignUpActivity";
    public static final String ARG_LOGIN_PROFILE = "arg_LoginInProfile_SignUpActivity";

    ActivitySignUpBinding binding;
    private SignUpContract.Presenter<SignUpContract.View> presenter;
    //    SharedPrefHelper helper;
    int cnt = 0;
    int is_term, is_privacy;
    //is_news;
    String emailPattern = "[a-zA-Z0-9._-]+@[a-z]+\\.+[a-z]+";
    //    String social_id;
//    String login_type;
    boolean argIsSocialSignUp;
    LoginProfile argLoginProfile = null;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setUP();
        getArguments();
        initPresenter();
        initUI();


//        binding.cbTermsConditionssubscribe.setOnCheckedChangeListener(new CompoundButton.OnCheckedChangeListener() {
//            @Override
//            public void onCheckedChanged(CompoundButton buttonView, boolean isChecked) {
//                if (isChecked) {
//                    cnt++;
//                    is_news = 1;
//                } else {
//                    is_news = 0;
//                }
//            }
//        });
        binding.cbTermsConditionsPrivacy.setOnCheckedChangeListener(new CompoundButton.OnCheckedChangeListener() {
            @Override
            public void onCheckedChanged(CompoundButton buttonView, boolean isChecked) {
                if (isChecked) {
                    cnt++;
                    is_privacy = 1;
                } else {
                    is_privacy = 0;
                }
            }
        });


    }

    private void initUI() {
        if (argIsSocialSignUp) {
            binding.llemailPwd.setVisibility(View.GONE);
            String loginType = argLoginProfile.getLogin_type();
            if (LOGIN_TYPE_FACEBOOK.equals(loginType)) {
                binding.tvFBLoggedintxt.setVisibility(View.VISIBLE);
            } else if (LOGIN_TYPE_GOOGLE.equals(loginType)) {
                binding.tvGoogleLoggedintxt.setVisibility(View.VISIBLE);
            } else if (LOGIN_TYPE_KAKAO.equals(loginType)) {
                binding.tvKakaoLoggedintxt.setVisibility(View.VISIBLE);
            } else if (LOGIN_TYPE_NAVER.equals(loginType)) {
                binding.tvLoggedintxt.setVisibility(View.VISIBLE);
            }
            if (argLoginProfile.getName() != null && !argLoginProfile.getName().isEmpty()) {
                binding.etSignupname.setText(argLoginProfile.getName());
                binding.etSignupname.setEnabled(false);
                binding.etSignupname.setBackgroundResource(R.drawable.edittext_rect_fixed);
            }
            if(argLoginProfile.getEmail()!=null && !argLoginProfile.getEmail().isEmpty()){
                binding.etSignupEmail.setText(argLoginProfile.getEmail());
            }
            String nickName = argLoginProfile.getNick_name();
            if (nickName != null && !nickName.isEmpty()) {
                binding.etSignupNickname.setText(nickName);
            }
        } else {
            binding.llemailPwd.setVisibility(View.VISIBLE);
        }
        binding.tvIsEmailAvailOrUsed.setVisibility(View.GONE);
        binding.layoutTool.ibCharge.setVisibility(View.GONE);
        setClickListeners();
    }

    private void setClickListeners() {
        binding.layoutTool.ibBack.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                onBackPressed();
            }
        });
        binding.btnSignin.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {

                if (argIsSocialSignUp) {
                    if (isValidSocalData()) {
                        presenter.socialSignup(argLoginProfile.getSocial_id(), binding.etSignupname.getText().toString(),
                                binding.etSignupNickname.getText().toString(), binding.etSignupEmail.getText().toString(), argLoginProfile.getLogin_type(), binding.etSignupPh.getText().toString());
                    }
                } else {
                    if (isValid()) {
//                    onBackPressed();
//                    helper.setSharedPref("islogin");
                      //  Intent intent= new Intent(SignUpActivity.this, EmailOtpVerificationActivity.class);
                     //   intent.putExtra("Password","123");
                      //  SignUpActivity.this.startActivity(intent);
                        StarRankingApp.getDataManager().saveUserEmail(binding.etSignupEmail.getText().toString());
                        presenter.doSignup(binding.etSignupEmail.getText().toString(), binding.etSignupRepwd.getText().toString(), binding.etSignupname.getText().toString(), binding.etSignupPh.getText().toString(), binding.etSignupNickname.getText().toString(), is_term, is_privacy, 0);
                    }
                }


            }
        });
        binding.btnDoublecheck.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (binding.etSignupEmail.getText().toString().equals("")) {
                    AppUtils.setToast(getApplicationContext(), getString(R.string.str_val_email));
                    binding.etSignupEmail.requestFocus();
                } else if (!binding.etSignupEmail.getText().toString().matches(emailPattern)) {
                    AppUtils.setToast(getApplicationContext(),  getString(R.string.str_hint_enter_valid_email));
                    binding.etSignupEmail.requestFocus();
                } else {
                    presenter.doublecheck(binding.etSignupEmail.getText().toString());
                }


            }
        });
        binding.tvTermsLink.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Intent i = new Intent(getApplicationContext(), SampleWebViewActivity.class);
                i.putExtra("from", "signinterms");
                startActivity(i);
            }
        });
        binding.tvPrivacyLink.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Intent i = new Intent(getApplicationContext(), SampleWebViewActivity.class);
                i.putExtra("from", "signinprivacy");
                startActivity(i);
            }
        });
        binding.cbTermsConditions.setOnCheckedChangeListener(new CompoundButton.OnCheckedChangeListener() {
            @Override
            public void onCheckedChanged(CompoundButton buttonView, boolean isChecked) {
                if (isChecked) {
                    cnt++;
                    is_term = 1;
                } else {
                    is_term = 0;
                }
            }
        });
    }

    private void getArguments() {
        Intent myIntent = getIntent();
        argIsSocialSignUp = myIntent.getBooleanExtra(ARG_IS_SOCIAL_SIGN_UP, false);
        if (argIsSocialSignUp) {
            argLoginProfile = (LoginProfile) myIntent.getSerializableExtra(ARG_LOGIN_PROFILE);
        }
    }

    private void initPresenter() {
        //        helper = new SharedPrefHelper(this);
        presenter = new SignUpPresenter<>();
        presenter.onAttach(this);
    }

    private void setUP() {
        AppUtils.gradientStatusbar(SignUpActivity.this);
        binding = DataBindingUtil.setContentView(this, R.layout.activity_sign_up);
        setupView(binding.extraViews);
    }

    boolean isValid() {
        if (binding.etSignupEmail.getText().toString().equals("")) {
            AppUtils.setToast(getApplicationContext(), getString(R.string.str_val_email));
            binding.etSignupEmail.requestFocus();
            return false;
        } else if (!binding.etSignupEmail.getText().toString().matches(emailPattern)) {
            AppUtils.setToast(getApplicationContext(), getString(R.string.str_hint_enter_valid_email));
            binding.etSignupEmail.requestFocus();
            return false;
        } else if (binding.etSignupPwd.getText().toString().equals("")) {
            AppUtils.setToast(getApplicationContext(), getString(R.string.str_hint_password));
            binding.etSignupPwd.requestFocus();
            return false;
        }else if (binding.etSignupPwd.getText().toString().length()<8) {
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
        } else if (binding.etSignupname.getText().toString().equals("")) {
            AppUtils.setToast(getApplicationContext(), getString(R.string.str_hint_name));
            binding.etSignupname.requestFocus();
            return false;
        } else if (binding.etSignupPh.getText().toString().equals("")) {
            AppUtils.setToast(getApplicationContext(), getString(R.string.str_hint_phone_number));
            binding.etSignupPh.requestFocus();
            return false;
        } else if (binding.etSignupPh.getText().toString().length() != 11) {
            AppUtils.setToast(getApplicationContext(), getString(R.string.str_hint_valid_phone_number));
            binding.etSignupPh.requestFocus();
            return false;
        } else if (binding.etSignupNickname.getText().toString().equals("")) {
            AppUtils.setToast(getApplicationContext(), getString(R.string.str_hint_enter_nickname));
            binding.etSignupNickname.requestFocus();
            return false;
        } else if (is_term == 0) {
            AppUtils.setToast(getApplicationContext(),  getString(R.string.str_msg_accept_term_condition));
            return false;
        } else if (is_privacy == 0) {
            AppUtils.setToast(getApplicationContext(), getString(R.string.str_msg_accept_privacy_policy));
            return false;
        }

        return true;
    }

    boolean isValidSocalData() {
        if (binding.etSignupEmail.getText().toString().equals("")) {
            AppUtils.setToast(getApplicationContext(), getString(R.string.str_val_email));
            binding.etSignupEmail.requestFocus();
            return false;
        } else if (!binding.etSignupEmail.getText().toString().matches(emailPattern)) {
            AppUtils.setToast(getApplicationContext(), getString(R.string.str_hint_enter_valid_email));
            binding.etSignupEmail.requestFocus();
            return false;
        } else if (binding.etSignupname.getText().toString().equals("")) {
            AppUtils.setToast(getApplicationContext(), getString(R.string.str_hint_name));
            binding.etSignupname.requestFocus();
            return false;
        } else if (binding.etSignupPh.getText().toString().equals("")) {
            AppUtils.setToast(getApplicationContext(), getString(R.string.str_hint_phone_number));
            binding.etSignupPh.requestFocus();
            return false;
        } else if (binding.etSignupPh.getText().toString().length() != 11) {
            AppUtils.setToast(getApplicationContext(), getString(R.string.str_hint_valid_phone_number));
            binding.etSignupPh.requestFocus();
            return false;
        } else if (binding.etSignupNickname.getText().toString().equals("")) {
            AppUtils.setToast(getApplicationContext(), getString(R.string.str_hint_enter_nickname));
            binding.etSignupNickname.requestFocus();
            return false;
        } else if (is_term == 0) {
            AppUtils.setToast(getApplicationContext(), getString(R.string.str_msg_accept_term_condition));
            return false;
        } else if (is_privacy == 0) {
            AppUtils.setToast(getApplicationContext(), getString(R.string.str_msg_accept_privacy_policy));
            return false;
        }

        return true;
    }


    /*@Override
    public void onSuccessSignUp(LoginProfile model) {
        Intent intent= new Intent(SignUpActivity.this, EmailOtpVerificationActivity.class);
        intent.putExtra("Password","123");
        SignUpActivity.this.startActivity(intent);
       *//* StarRankingApp.getDataManager().saveUserToPref(model);
        Intent i = new Intent(SignUpActivity.this, DashboardActivity.class);
        startActivity(i);*//*
        finish();
    }*/

    @Override
    public void onSuccessSignUp(EmailOtpVerify model) {
        StarRankingApp.getDataManager().setUserId(model.getUser_id());
        Intent intent= new Intent(SignUpActivity.this, EmailOtpVerificationActivity.class);
        SignUpActivity.this.startActivity(intent);
        Log.d(TAG, "onSuccessSignUp: OTP"+model.getOtp());
       /* StarRankingApp.getDataManager().saveUserToPref(model);
        Intent i = new Intent(SignUpActivity.this, DashboardActivity.class);
        startActivity(i);*/
        finish();
    }

    @Override
    public void Successdoublechecked(String msg) {
        binding.tvIsEmailAvailOrUsed.setVisibility(View.VISIBLE);
        binding.tvIsEmailAvailOrUsed.setText(msg);
        binding.tvIsEmailAvailOrUsed.setTextColor(getResources().getColor(R.color.fbtxt));
    }

    @Override
    public void onSuccessRegisterd() {
//        AppUtils.setToast(getApplicationContext(), "registered");
    }

    @Override
    public void successSocialSignup(LoginProfile model) {
        presenter.doSocialLogin(model);
       // StarRankingApp.getDataManager().saveUserToPref(model);
       /* Intent i = new Intent(SignUpActivity.this, DashboardActivity.class);
        startActivity(i);
        finish();*/
    }


    @Override
    public void onfail(String message) {
        AppUtils.setToast(getApplicationContext(), message);
    }

    @Override
    public void onfailEmailCheck(String message) {
        binding.tvIsEmailAvailOrUsed.setVisibility(View.VISIBLE);
        binding.tvIsEmailAvailOrUsed.setText(message);
        binding.tvIsEmailAvailOrUsed.setTextColor(getResources().getColor(R.color.googletxt));
    }


    @Override
    public void setUserDataToInput(String email, String pwd, String mob, String nickname, Boolean terms, Boolean privacy, Boolean news) {

    }

    @Override
    public void socialLoginSuccess(LoginProfile model) {
      // /* presenter.doSocialLogin(model);
        StarRankingApp.getDataManager().saveUserToPref(model);
        Intent i = new Intent(SignUpActivity.this, DashboardActivity.class);
        startActivity(i);
        finish();
    }

    @Override
    public void onfailVerifySocialMedia() {
        Intent i = new Intent(SignUpActivity.this, LoginActivity.class);
        startActivity(i);
        finish();
    }

    @Override
    public void onRetryClicked() {
        super.onRetryClicked();
        presenter.retry();
    }
}
