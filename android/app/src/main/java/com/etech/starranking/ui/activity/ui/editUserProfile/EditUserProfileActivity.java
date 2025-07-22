package com.etech.starranking.ui.activity.ui.editUserProfile;

import android.content.Intent;
import android.os.Bundle;
import android.util.Patterns;
import android.view.View;
import android.widget.LinearLayout;

import androidx.appcompat.app.AppCompatActivity;
import androidx.databinding.DataBindingUtil;

import com.etech.starranking.R;
import com.etech.starranking.app.StarRankingApp;
import com.etech.starranking.base.BaseActivity;
import com.etech.starranking.data.prefs.AppPreferencesHelper;
import com.etech.starranking.databinding.ActivityEditUserProfileBinding;
import com.etech.starranking.ui.activity.model.LoginProfile;
import com.etech.starranking.ui.activity.ui.dashboard.DashboardActivity;
import com.etech.starranking.ui.activity.ui.login.LoginActivity;
import com.etech.starranking.utils.AppUtils;
import com.etech.starranking.utils.CustomAlertDialog;

import static com.etech.starranking.utils.Constants.LOGIN_TYPE_AUTH;
import static com.etech.starranking.utils.Constants.LOGIN_TYPE_FACEBOOK;
import static com.etech.starranking.utils.Constants.LOGIN_TYPE_GOOGLE;
import static com.etech.starranking.utils.Constants.LOGIN_TYPE_KAKAO;
import static com.etech.starranking.utils.Constants.LOGIN_TYPE_NAVER;

public class EditUserProfileActivity extends BaseActivity implements
        EditUserprofileContract.View {

    ActivityEditUserProfileBinding binding;
    LoginProfile user;

    EditUserprofileContract.Presenter<EditUserprofileContract.View> presenter;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        AppUtils.gradientStatusbar(EditUserProfileActivity.this);
        binding = DataBindingUtil.setContentView(this, R.layout.activity_edit_user_profile);
        setupView(binding.extraViews);
        presenter = new EditUserProfilePresenter<>();
        presenter.onAttach(this);

        user = StarRankingApp.getDataManager().getUserFromPref();
        binding.layoutTool.ibBack.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                onBackPressed();
            }
        });
        binding.layoutTool.ibCharge.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                AppUtils.callStarChargigWebview(EditUserProfileActivity.this);
            }
        });


        binding.tvEditName.setText(user.getName());
        binding.tvEditEmail.setText(user.getEmail());
        binding.tvEditNickName.setText(user.getNick_name());
        binding.tvEditPhonNo.setText(user.getMobile());

        if (user.getLogin_type().equals(LOGIN_TYPE_FACEBOOK)) {
            binding.tvFBLoggedintxt.setVisibility(View.VISIBLE);
        } else if (user.getLogin_type().equals(LOGIN_TYPE_GOOGLE)) {
            binding.tvGoogleLoggedintxt.setVisibility(View.VISIBLE);
        } else if (user.getLogin_type().equals(LOGIN_TYPE_KAKAO)) {
            binding.tvKakaoLoggedintxt.setVisibility(View.VISIBLE);
        } else if (user.getLogin_type().equals(LOGIN_TYPE_NAVER)) {
            binding.tvLoggedintxt.setVisibility(View.VISIBLE);
        }
        if (!LOGIN_TYPE_AUTH.equals(user.getLogin_type())) {
            binding.llpwd.setVisibility(View.GONE);
//            binding.llemail.setVisibility(View.GONE);
        }

        binding.btnEdit.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (LOGIN_TYPE_AUTH.equals(user.getLogin_type())) {
                    if (isValid()) {
                        presenter.updateProfile(user.getUser_id(), user.getUser_type(), user.getEmail(), binding.tvEditPhonNo.getText().toString(),
                                user.getName(), binding.tvEditNickName.getText().toString(),
                                binding.tvEditCurrentPwd.getText().toString(), binding.tvEditRePwd.getText().toString());
                    }
                } else {
                    if (isSocialValid()) {
                        presenter.updateProfile(
                                user.getUser_id(),
                                user.getUser_type(),
                                user.getEmail(),
                                binding.tvEditPhonNo.getText().toString(),
                                user.getName(),
                                binding.tvEditNickName.getText().toString(),
                                null,
                                null);
                    }
                }
            }
        });

      binding.deleteAccount.setOnClickListener(new View.OnClickListener() {
          @Override
          public void onClick(View v) {
              CustomAlertDialog.showAlert(
                      EditUserProfileActivity.this,
                      getResources().getString(R.string.str_delete_account_title),
                      getResources().getString(R.string.str_delete_account_confirm),
                      getResources().getString(R.string.go_back),
                      getResources().getString(R.string.btn_ok),

                      new View.OnClickListener() {
                          @Override
                          public void onClick(View v) {

                          }
                      }, new View.OnClickListener() {
                          @Override
                          public void onClick(View v) {
                              presenter.deleteUserProfile(user.getUser_id());
                          }
                      }

              );
          }
      });
    }

    private boolean isSocialValid() {
        if (binding.tvEditName.getText().toString().equals("")) {
            AppUtils.setToast(getApplicationContext(), getResources().getString(R.string.str_hint_name));
            binding.tvEditName.requestFocus();
            return false;
        } else if (binding.tvEditNickName.getText().toString().equals("")) {
            AppUtils.setToast(getApplicationContext(), getResources().getString(R.string.str_hint_enter_nickname));
            binding.tvEditNickName.requestFocus();
            return false;
        } else if (binding.tvEditPhonNo.getText().toString().equals("")) {
            AppUtils.setToast(getApplicationContext(), getResources().getString(R.string.str_hint_phone_number));
            binding.tvEditPhonNo.requestFocus();
            return false;
        } else if (binding.tvEditPhonNo.getText().toString().length() != 11) {
            AppUtils.setToast(getApplicationContext(), getResources().getString(R.string.str_hint_valid_phone_number));
            binding.tvEditPhonNo.requestFocus();
            return false;
        }

        return true;
    }

    boolean isValid() {
        if (binding.tvEditName.getText().toString().equals("")) {
            AppUtils.setToast(getApplicationContext(), getResources().getString(R.string.str_hint_name));
            binding.tvEditName.requestFocus();
            return false;
        } else /*if (binding.tvEditEmail.getText().toString().equals("")) {
            AppUtils.setToast(getApplicationContext(), getResources().getString(R.string.str_val_email));
            binding.tvEditEmail.requestFocus();
            return false;
        } else if (!Patterns.EMAIL_ADDRESS.matcher(binding.tvEditEmail.getText().toString()).matches()) {
            AppUtils.setToast(getApplicationContext(), getResources().getString(R.string.str_hint_enter_valid_email));
            binding.tvEditEmail.requestFocus();
            return false;
        } else */if (binding.tvEditNickName.getText().toString().equals("")) {
            AppUtils.setToast(getApplicationContext(), getResources().getString(R.string.str_hint_enter_nickname));
            binding.tvEditNickName.requestFocus();
            return false;
        } else if (binding.tvEditPhonNo.getText().toString().equals("")) {
            AppUtils.setToast(getApplicationContext(), getResources().getString(R.string.str_hint_phone_number));
            binding.tvEditPhonNo.requestFocus();
            return false;
        } else if (binding.tvEditPhonNo.getText().toString().length() != 11) {
            AppUtils.setToast(getApplicationContext(), getResources().getString(R.string.str_hint_valid_phone_number));
            binding.tvEditPhonNo.requestFocus();
            return false;
        } else if (!binding.tvEditCurrentPwd.getText().toString().equals("")) {
             if (binding.tvEditCurrentPwd.getText().toString().length()<8) {
                AppUtils.setToast(getApplicationContext(), getString(R.string.str_hint_valid_password));
                binding.tvEditCurrentPwd.requestFocus();
                return false;
            }else if (binding.tvEditNewPwd.getText().toString().equals("")) {
                AppUtils.setToast(getApplicationContext(), getResources().getString(R.string.str_hint_new_password));
                binding.tvEditNewPwd.requestFocus();
                return false;
            } else if (binding.tvEditNewPwd.getText().toString().length()<8) {
                AppUtils.setToast(getApplicationContext(), getString(R.string.str_hint_valid_password));
                binding.tvEditNewPwd.requestFocus();
                return false;
            } else if (binding.tvEditRePwd.getText().toString().equals("")) {
                AppUtils.setToast(getApplicationContext(), getResources().getString(R.string.str_hint_new_password));
                binding.tvEditRePwd.requestFocus();
                return false;
            } else if (!binding.tvEditNewPwd.getText().toString().equals(binding.tvEditRePwd.getText().toString())) {
                AppUtils.setToast(getApplicationContext(), getString(R.string.str_val_same_pass));
                binding.tvEditRePwd.requestFocus();
                return false;
            } else if (binding.tvEditNewPwd.getText().toString().equals(binding.tvEditCurrentPwd.getText().toString())) {
                AppUtils.setToast(getApplicationContext(), getString(R.string.str_val_same_old_new_pass));
                binding.tvEditNewPwd.requestFocus();
                return false;
            }
        }
        return true;
    }

    @Override
    public void onSuccessfullyUpdated() {
        AppUtils.setToast(getApplicationContext(), getString(R.string.msg_update_success));
        Intent i = new Intent(getApplicationContext(), DashboardActivity.class);
        startActivity(i);
        finishAffinity();
    }

    @Override
    public void onfail(String message) {
        AppUtils.setToast(getApplicationContext(), message);
    }

    @Override
    public void onSuccessFullyDeleteAccount() {
        StarRankingApp.getDataManager().logout();
        Intent intent = new Intent(getApplicationContext(), LoginActivity.class);
        startActivity(intent);
        finishAffinity();
    }

    @Override
    public void onFailedToDeleteAccount() {

    }

    @Override
    public void onRetryClicked() {
        super.onRetryClicked();
        presenter.retry();
    }
}
