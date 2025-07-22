package com.etech.starranking.ui.activity.ui.login;

import android.annotation.SuppressLint;
import android.app.Activity;
import android.content.Intent;
import android.os.AsyncTask;
import android.os.Bundle;
import android.util.Log;
import android.util.Patterns;
import android.view.View;
import android.widget.CompoundButton;

import androidx.annotation.Nullable;
import androidx.databinding.DataBindingUtil;

import com.etech.starranking.R;
import com.etech.starranking.app.StarRankingApp;
import com.etech.starranking.base.BaseActivity;
import com.etech.starranking.databinding.ActivityLoginBinding;
import com.etech.starranking.ui.activity.model.LoginProfile;
import com.etech.starranking.ui.activity.ui.dashboard.DashboardActivity;
import com.etech.starranking.ui.activity.ui.forgotPassword.ForgotPasswordActivity;
import com.etech.starranking.ui.activity.ui.signin.SignUpActivity;
import com.etech.starranking.utils.AppUtils;
import com.facebook.AccessToken;
import com.facebook.CallbackManager;
import com.facebook.FacebookCallback;
import com.facebook.FacebookException;
import com.facebook.GraphRequest;
import com.facebook.GraphResponse;
import com.facebook.login.LoginManager;
import com.facebook.login.LoginResult;
import com.google.android.gms.auth.api.signin.GoogleSignIn;
import com.google.android.gms.auth.api.signin.GoogleSignInAccount;
import com.google.android.gms.auth.api.signin.GoogleSignInClient;
import com.google.android.gms.auth.api.signin.GoogleSignInOptions;
import com.google.android.gms.common.api.ApiException;
import com.google.android.gms.tasks.Task;
import com.kakao.auth.ISessionCallback;
import com.kakao.auth.Session;
import com.kakao.network.ErrorResult;
import com.kakao.usermgmt.UserManagement;
import com.kakao.usermgmt.callback.MeV2ResponseCallback;
import com.kakao.usermgmt.response.MeV2Response;
import com.kakao.util.exception.KakaoException;
import com.nhn.android.naverlogin.OAuthLogin;
import com.nhn.android.naverlogin.OAuthLoginHandler;

import org.json.JSONObject;

import java.util.Arrays;

import static com.etech.starranking.data.prefs.AppPreferencesHelper.PREF_IsAutoLogin;
import static com.etech.starranking.utils.Constants.LOGIN_TYPE_FACEBOOK;
import static com.etech.starranking.utils.Constants.LOGIN_TYPE_GOOGLE;
import static com.etech.starranking.utils.Constants.LOGIN_TYPE_KAKAO;
import static com.etech.starranking.utils.Constants.LOGIN_TYPE_NAVER;
import static com.etech.starranking.utils.Constants.OAUTH_CLIENT_ID;
import static com.etech.starranking.utils.Constants.OAUTH_CLIENT_NAME;
import static com.etech.starranking.utils.Constants.OAUTH_CLIENT_SECRET;

public class LoginActivity extends BaseActivity implements
        LoginContract.View {
    private static final String TAG = "LoginActivity";
    private static final int GOOGLE_SIGN_IN_CODE = 124;
    private static final int SOCIAL_SIGN_UP_CODE = 125;
    //1 true 0 false
    ActivityLoginBinding binding;
    //    SharedPrefHelper helper;
    LoginContract.Presenter<LoginContract.View> presenter;
    int auto_login = 1;

    ISessionCallback sessionCallback;
    private GoogleSignInClient mGoogleSignInClient;
    private CallbackManager callbackManager;

    // naver login id, secret, name

    private OAuthLogin mOAuthLoginInstance;

    String social_id;
    String login_type;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        AppUtils.gradientStatusbar(LoginActivity.this);
        binding = DataBindingUtil.setContentView(this, R.layout.activity_login);
        setupView(binding.extraViews);
        presenter = new LoginPresenter<>();
        presenter.onAttach(this);
//        helper = new SharedPrefHelper(this);
        binding.layoutTool.ibBack.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                onBackPressed();
            }
        });
        binding.layoutTool.ibCharge.setVisibility(View.GONE);
//        setSupportActionBar(binding.layoutTool.tool);
//        getSupportActionBar().setElevation(10);
        binding.btnLogin.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (isValid()) {
                    presenter.doLogin(AppUtils.LANGUAGE_DEFAULT_VALUE,
                            binding.etLoginName.getText().toString(),
                            binding.etLoginPwd.getText().toString(),
                            String.valueOf(auto_login), "auth");


                }
            }
        });
        binding.cbautoLogin.setOnCheckedChangeListener(new CompoundButton.OnCheckedChangeListener() {
            @Override
            public void onCheckedChanged(CompoundButton buttonView, boolean isChecked) {
                if (isChecked) {
                    auto_login = 1;
                    StarRankingApp.getDataManager().setBoolean(PREF_IsAutoLogin, true);

                } else {
                    auto_login = 0;
                    StarRankingApp.getDataManager().setBoolean(PREF_IsAutoLogin, false);
                }

            }
        });
        binding.cbautoLogin.setChecked(true);
        binding.tvForgotPwd.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Intent intent=new Intent(LoginActivity.this, ForgotPasswordActivity.class);
                startActivity(intent);
            }
        });

        initUi();
    }

    private void initUi() {
        setUpGoogleLogin();
        setUpFacebookLogin();
        setUpNaver();
        setClickListeners();
    }

    private void setUpNaver() {
        mOAuthLoginInstance = OAuthLogin.getInstance();

        mOAuthLoginInstance.showDevelopersLog(true);
        mOAuthLoginInstance.init(this, OAUTH_CLIENT_ID, OAUTH_CLIENT_SECRET, OAUTH_CLIENT_NAME);
        binding.rlLoginNaver.setOnClickListener(new View.OnClickListener() {
            @SuppressLint("HandlerLeak")
            @Override
            public void onClick(View v) {
                mOAuthLoginInstance.startOauthLoginActivity(LoginActivity.this, new OAuthLoginHandler() {
                    @Override
                    public void run(boolean success) {
                        if (success) {
                            String accessToken = mOAuthLoginInstance.getAccessToken(LoginActivity.this);
                            requestMeNaver(accessToken);
//                            String refreshToken = mOAuthLoginInstance.getRefreshToken(mContext);
//                            long expiresAt = mOAuthLoginInstance.getExpiresAt(mContext);
//                            String tokenType = mOAuthLoginInstance.getTokenType(mContext);
                        } else {
                            hideLoader();
//                            AppUtils.setToast(LoginActivity.this, getString(R.string.str_msg_something_went_wrong));
                        }
                    }
                });


            }
        });
    }

    private void requestMeNaver(String accessToken) {
        new RequestApiTask().execute();
    }

    @SuppressLint("StaticFieldLeak")
    private class RequestApiTask extends AsyncTask<Void, Void, String> {
        @Override
        protected void onPreExecute() {
            super.onPreExecute();
            if (presenter.getView() != null) {
                showLoader();
            }
        }

        @Override
        protected String doInBackground(Void... params) {
            String url = "https://openapi.naver.com/v1/nid/me";
            String at = mOAuthLoginInstance.getAccessToken(LoginActivity.this);
            return mOAuthLoginInstance.requestApi(LoginActivity.this, at, url);
        }

        protected void onPostExecute(String content) {
            Log.d(TAG, "naver me  onPostExecute: success " + content);

            try {
                JSONObject jsonObject = new JSONObject(content);
                if (jsonObject.getString("resultcode").equals("00")) {
                    JSONObject response = jsonObject.getJSONObject("response");
                    String id = null;
                    if (response.has("id")) {
                        id = response.getString("id");
                    }
                    String nickName = null;
                    if (response.has("nickname")) {
                        nickName = response.getString("nickname");
                    }
                    String email = null;
                    if (response.has("email")) {
                        email = response.getString("email");
                    }
                    String name = null;
                    if (response.has("name")) {
                        name = response.getString("name");
                    }
                    generateAndVerify(id, LOGIN_TYPE_NAVER, email, name, nickName);
                }

            } catch (Exception e) {
                if (presenter.getView() != null) {
                    hideLoader();
                    AppUtils.setToast(LoginActivity.this, getString(R.string.str_msg_something_went_wrong));
                }

            }

        }
    }


    private void setUpFacebookLogin() {
        callbackManager = CallbackManager.Factory.create();
        LoginManager.getInstance().registerCallback(callbackManager, new FacebookCallback<LoginResult>() {
            @Override
            public void onSuccess(LoginResult loginResult) {
                requestMeFacebook(loginResult.getAccessToken());
            }

            @Override
            public void onCancel() {
                Log.d(TAG, "fb login onCancel: ");
                hideLoader();
            }

            @Override
            public void onError(FacebookException error) {
                hideLoader();
                AppUtils.setToast(LoginActivity.this, getString(R.string.str_msg_something_went_wrong));
                Log.e(TAG, "fb onError: ", error);
            }
        });
        binding.rlLoginFb.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                LoginManager.getInstance().logIn(LoginActivity.this, Arrays.asList("email"));
            }
        });
    }

    private void requestMeFacebook(AccessToken accessToken) {
        GraphRequest request = GraphRequest.newMeRequest(accessToken, new GraphRequest.GraphJSONObjectCallback() {
            @Override
            public void onCompleted(JSONObject object, GraphResponse response) {
                if (response.getError() == null) {
//                    social_id=?;
//                    login_type = "facebook";
                    Log.d(TAG, "fb me onCompleted: success" + response.toString());

                    try {
                        String id = null;
                        String name = null;
                        String email = null;
                        JSONObject jsonObject = response.getJSONObject();
                        if (jsonObject.has("id")) {
                            id = jsonObject.getString("id");
                        }
                        if (jsonObject.has("name")) {
                            name = jsonObject.getString("name");
                        }
                        if (jsonObject.has("email")) {
                            email = jsonObject.getString("email");
                        }
                        generateAndVerify(id, LOGIN_TYPE_FACEBOOK, email, name, null);
                    } catch (Exception e) {
                        hideLoader();
                        AppUtils.setToast(LoginActivity.this, getString(R.string.str_msg_something_went_wrong));
                        e.printStackTrace();
                    }

                } else {
                    Log.e(TAG, "fb me onCompleted: err", response.getError().getException());
                    hideLoader();
                    AppUtils.setToast(LoginActivity.this, getString(R.string.str_msg_something_went_wrong));
                }
            }
        });
        Bundle parameters = new Bundle();
        parameters.putString("fields", "id,name,email");
        request.setParameters(parameters);
        showLoader();
        request.executeAsync();
    }

    private void setUpGoogleLogin() {
        // Configure sign-in to request the user's ID, email address, and basic
// profile. ID and basic profile are included in DEFAULT_SIGN_IN.
        GoogleSignInOptions gso = new GoogleSignInOptions.Builder(GoogleSignInOptions.DEFAULT_SIGN_IN)
                .requestEmail()
//                .requestIdToken("885105275445-mp0t7k4619efb0iik292pq5n4ogbkdsk.apps.googleusercontent.com")
                .build();
        mGoogleSignInClient = GoogleSignIn.getClient(this, gso);

    }

    private void setClickListeners() {
        binding.rlLoginKakao.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Log.d(TAG, "onClick: ");
                sessionCallback = new ISessionCallback() {
                    @Override
                    public void onSessionOpened() {
//                        Toast.makeText(LoginActivity.this,"onSessionOpened",Toast.LENGTH_SHORT).show();
                        Log.d(TAG, "onSessionOpened: ");
                        requestMeKakao();
                    }

                    @Override
                    public void onSessionOpenFailed(KakaoException exception) {
//                        Toast.makeText(LoginActivity.this, "fail", Toast.LENGTH_SHORT).show();
                        hideLoader();
//                        AppUtils.setToast(LoginActivity.this, getString(R.string.str_msg_something_went_wrong));
                    }
                };
                Session.getCurrentSession().addCallback(sessionCallback);
                binding.kakaoLoginBtn.performClick();
            }
        });

        binding.rlLoginGoogle.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                googleSignIn();
            }
        });
    }

    private void googleSignIn() {
        Intent signInIntent = mGoogleSignInClient.getSignInIntent();
        startActivityForResult(signInIntent, GOOGLE_SIGN_IN_CODE);

    }

    @Override
    protected void onDestroy() {
        Session.getCurrentSession().removeCallback(sessionCallback);
        super.onDestroy();
    }

    private void requestMeKakao() {
        Log.d(TAG, "requestMeKakao: ");
        showLoader();
        UserManagement.getInstance().me(new MeV2ResponseCallback() {
            @Override
            public void onSessionClosed(ErrorResult errorResult) {
                Log.d(TAG, "onSessionClosed: ");
                hideLoader();
                AppUtils.setToast(LoginActivity.this, getString(R.string.str_msg_something_went_wrong));
            }

            @Override
            public void onSuccess(MeV2Response result) {
//                social_id = String.valueOf(result.getId());
//                login_type = "kakao";
                generateAndVerify(String.valueOf(result.getId()), LOGIN_TYPE_KAKAO, result.getKakaoAccount().getEmail(), result.getKakaoAccount().getLegalName(), result.getKakaoAccount().getProfile().getNickname());
                Log.d(TAG, "onSuccess: " + result);
            }
        });
    }

    boolean isValid() {
        if (binding.etLoginName.getText().toString().equals("")) {
            AppUtils.setToast(getApplicationContext(), getString(R.string.str_val_email));
            binding.etLoginName.requestFocus();
            return false;
        } else if (!Patterns.EMAIL_ADDRESS.matcher(binding.etLoginName.getText().toString()).matches()) {
            AppUtils.setToast(getApplicationContext(), getResources().getString(R.string.str_hint_enter_valid_email));
            binding.etLoginName.requestFocus();
            return false;
        } else if (binding.etLoginPwd.getText().toString().equals("")) {
            AppUtils.setToast(getApplicationContext(), getString(R.string.str_hint_password));
            binding.etLoginPwd.requestFocus();
            return false;
        } else if (binding.etLoginPwd.getText().toString().length() < 8) {
            AppUtils.setToast(getApplicationContext(), getString(R.string.str_hint_valid_password));
            binding.etLoginPwd.requestFocus();
            return false;
        }
        return true;
    }

    @Override
    public void onBackPressed() {
        Intent i = new Intent(LoginActivity.this, DashboardActivity.class);
        startActivity(i);
        finish();

    }


    @Override
    public void onSuccessLogin(LoginProfile model) {
//        AppUtils.setToast(getApplicationContext(), "You are logged in successfully");
        Intent i = new Intent(LoginActivity.this, DashboardActivity.class);
        startActivity(i);
        finish();


    }

 /*   @Override
    public void onSuccessRegisterd() {
//        AppUtils.setToast(this, "registered");
    }*/


    /*@Override
    public void gotoVerification() {
        //signup
//        Log.d(TAG, "gotoVerification: ");
//        Intent intent = new Intent(LoginActivity.this, SignUpActivity.class);
//        intent.putExtra("LoginFrom", login_type);
//        intent.putExtra("socialid", social_id);
//        startActivity(intent);

    }*/

    @Override
    public void socialLoginSuccess(LoginProfile model) {
        StarRankingApp.getDataManager().saveUserToPref(model);
        Intent i = new Intent(LoginActivity.this, DashboardActivity.class);
        startActivity(i);
        finish();
    }

    @Override
    public void onfail(String message) {
        AppUtils.setToast(getApplicationContext(), message);
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, @Nullable Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (Session.getCurrentSession().handleActivityResult(requestCode, resultCode, data)) {
            Log.d(TAG, "onActivityResult: ");
            return;
        }
        //google sign in start
        if (requestCode == GOOGLE_SIGN_IN_CODE) {
            Log.d(TAG, "onActivityResult: google sign in result");
            Task<GoogleSignInAccount> task = GoogleSignIn.getSignedInAccountFromIntent(data);
            handleGoogleSignInResult(task);

        }
        //google sign in end
        callbackManager.onActivityResult(requestCode, resultCode, data);
        if (requestCode == SOCIAL_SIGN_UP_CODE && resultCode == Activity.RESULT_OK) {
            finish();
        }
    }

    private void handleGoogleSignInResult(Task<GoogleSignInAccount> completedTask) {
        try {
            showLoader();
            GoogleSignInAccount account = completedTask.getResult(ApiException.class);
            if (account != null)
                Log.d(TAG, "handleGoogleSignInResult: id=" + account.getId() + " email " + account.getEmail() + " name=" + account.getDisplayName());

            generateAndVerify(account.getId(), LOGIN_TYPE_GOOGLE, account.getEmail(), account.getDisplayName(), account.getGivenName());
//            presenter.verifyLoginUser(AppUtils.LANGUAGE_DEFAULT_VALUE, account.getId(), "google");
        } catch (ApiException e) {
//            AppUtils.setToast(this, getString(R.string.str_msg_something_went_wrong));
            hideLoader();
            e.printStackTrace();
//            Log.e(TAG, "handleGoogleSignInResult: "+e.getStatusCode(), e);
        }

    }

    private void generateAndVerify(String social_id, String login_type, String email, String name, String nickName) {
        Log.d(TAG, "generateAndVerify: ");
        LoginProfile loginProfile = new LoginProfile();
        loginProfile.setSocial_id(social_id);
        loginProfile.setLogin_type(login_type);
        loginProfile.setEmail(email);
        loginProfile.setName(name);
        loginProfile.setNick_name(nickName);
//        loginProfile.setMobile(mobile);
        presenter.doSocialLogin(loginProfile);
    }

    @Override
    public void gotoSignUp(LoginProfile loginProfile) {
        Log.d(TAG, "gotoSignUp: ");
        Intent signUpIntent = new Intent(LoginActivity.this, SignUpActivity.class);
        signUpIntent.putExtra(SignUpActivity.ARG_IS_SOCIAL_SIGN_UP, true);
        signUpIntent.putExtra(SignUpActivity.ARG_LOGIN_PROFILE, loginProfile);
        startActivityForResult(signUpIntent, SOCIAL_SIGN_UP_CODE);
//        intent.putExtra("LoginFrom", login_type);
//        intent.putExtra("socialid", social_id);
//        startActivity(intent);
    }

    @Override
    public void onRetryClicked() {
        super.onRetryClicked();
        presenter.retry();
    }
}

