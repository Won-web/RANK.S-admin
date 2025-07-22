package com.etech.starranking.ui.activity.ui.dashboard;


import android.app.ActionBar;
import android.app.Dialog;
import android.content.Context;
import android.content.Intent;
import android.graphics.Color;
import android.graphics.PixelFormat;
import android.graphics.Rect;
import android.graphics.Typeface;
import android.graphics.drawable.ColorDrawable;
import android.graphics.drawable.Drawable;
import android.os.Build;
import android.os.Bundle;
import android.os.Handler;
import android.text.Editable;
import android.text.Spannable;
import android.text.SpannableString;
import android.text.TextWatcher;
import android.util.Log;
import android.view.Gravity;
import android.view.LayoutInflater;
import android.view.Menu;
import android.view.MenuItem;
import android.view.MotionEvent;
import android.view.SubMenu;
import android.view.View;
import android.view.ViewGroup;
import android.view.WindowManager;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;

import androidx.annotation.NonNull;
import androidx.annotation.RequiresApi;
import androidx.appcompat.app.ActionBarDrawerToggle;
import androidx.appcompat.widget.AppCompatButton;
import androidx.appcompat.widget.AppCompatEditText;
import androidx.appcompat.widget.AppCompatImageView;
import androidx.appcompat.widget.AppCompatTextView;
import androidx.core.view.GravityCompat;
import androidx.databinding.DataBindingUtil;
import androidx.drawerlayout.widget.DrawerLayout;
import androidx.navigation.NavController;
import androidx.navigation.Navigation;
import androidx.navigation.ui.AppBarConfiguration;
import androidx.navigation.ui.NavigationUI;

import com.etech.starranking.R;
import com.etech.starranking.app.StarRankingApp;
import com.etech.starranking.base.BaseActivity;
import com.etech.starranking.data.prefs.AppPreferencesHelper;
import com.etech.starranking.databinding.ActivityDashboardBinding;

import com.etech.starranking.ui.activity.SampleWebViewActivity;
import com.etech.starranking.ui.activity.StarChargingWebview;
import com.etech.starranking.ui.activity.model.GiftDetails;
import com.etech.starranking.ui.activity.model.LoginProfile;
import com.etech.starranking.ui.activity.model.UserDetailsFromMobile;
import com.etech.starranking.ui.activity.ui.dashboard.Settings.FragmentSettingsActivity;
import com.etech.starranking.ui.activity.ui.dashboard.history.FragmentHistoryActivity;
import com.etech.starranking.ui.activity.ui.dashboard.home.ContestListsFragment;
import com.etech.starranking.ui.activity.ui.dashboard.notice.FragmentNoticeActivity;
import com.etech.starranking.ui.activity.ui.dashboard.notification.FragmentNotificationActivity;
import com.etech.starranking.ui.activity.ui.dashboard.webview.FragmentWebviewActivity;
import com.etech.starranking.ui.activity.ui.dashboard.webview.WebviewFragment;
import com.etech.starranking.ui.activity.ui.searchResult.SearchResultActivity;
import com.etech.starranking.ui.activity.ui.editUserProfile.EditUserProfileActivity;
import com.etech.starranking.ui.activity.ui.login.LoginActivity;
import com.etech.starranking.ui.activity.ui.signin.SignUpActivity;
import com.etech.starranking.utils.AppUtils;
import com.etech.starranking.utils.Constants;
import com.etech.starranking.utils.CustomTypeFace;
import com.etech.starranking.utils.OnBackPressed;
import com.google.android.material.navigation.NavigationView;
import com.mikhaellopez.circularimageview.CircularImageView;

import static com.etech.starranking.data.prefs.AppPreferencesHelper.PREF_IsAutoLogin;
import static com.etech.starranking.utils.Constants.LOGIN_TYPE_FACEBOOK;
import static com.etech.starranking.utils.Constants.LOGIN_TYPE_GOOGLE;
import static com.etech.starranking.utils.Constants.LOGIN_TYPE_KAKAO;
import static com.etech.starranking.utils.Constants.LOGIN_TYPE_NAVER;

public class DashboardActivity extends BaseActivity
        implements OnBackPressed, NavigationView.OnNavigationItemSelectedListener, DashboardContract.View {

    private AppBarConfiguration mAppBarConfiguration;
    public ActivityDashboardBinding binding;
    AppCompatButton btnNavEdit, btnNavSignOut;

    AppCompatTextView tvNavProfileName, tvNavProfileEmail, staramt, login_btn, signin_btn;
    RelativeLayout rlstars;
    AppCompatImageView header_logo;
    LinearLayout editLoginSign;
    ActionBarDrawerToggle toggle;
    private boolean doubleBackToExitPressedOnce;
    //    SharedPrefHelper sharedPrefHelper;
    String checklogin;
    NavController navController;
    int id;
    LoginProfile user;
    CircularImageView mobileProfile, starGift;
    String gift_username = "";
    String gift_amt_to_user = "";
    String gift_userid;
    DashboardContract.Presenter<DashboardContract.View> presenter;
    UserDetailsFromMobile mobmodel;
    AppCompatTextView giftto_name;
    ActionBarDrawerToggle mDrawerToggle;


    boolean ismobilenumbervalid;
    boolean isstarAmtvalid;


    @RequiresApi(api = Build.VERSION_CODES.O)
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        AppUtils.gradientStatusbar(DashboardActivity.this);
        binding = DataBindingUtil.setContentView(this, R.layout.activity_dashboard);
        setupView(binding.extraViews);
//        sharedPrefHelper = new SharedPrefHelper(this);/**/

        presenter = new DashboardPresenter<>();
        presenter.onAttach(this);


        initUi();
    }

    //@RequiresApi(api = Build.VERSION_CODES.O)
    public void initUi() {

        setSupportActionBar(binding.includedAppbar.toolbar);
        setHamBurger();


        mAppBarConfiguration = new AppBarConfiguration.Builder(
                R.id.nav_home, R.id.nav_guide, R.id.nav_sendStar, R.id.nav_history, R.id.nav_freeCahrging, R.id.nav_notice,
                R.id.nav_notification, R.id.nav_settings)
                .setDrawerLayout(binding.drawerLayout)
                .build();

        navController = Navigation.findNavController(this, R.id.nav_host_fragment);
//        NavigationUI.setupActionBarWithNavController(this, navController, mAppBarConfiguration);
        addFragment(new ContestListsFragment(), true,false);

        Menu m = binding.navView.getMenu();
        for (int i = 0; i < m.size(); i++) {
            MenuItem mi = m.getItem(i);

            SubMenu subMenu = mi.getSubMenu();
            if (subMenu != null && subMenu.size() > 0) {
                for (int j = 0; j < subMenu.size(); j++) {
                    MenuItem subMenuItem = subMenu.getItem(j);
                    applyFontToMenuItem(subMenuItem);
                }
            }
            applyFontToMenuItem(mi);
        }
        NavigationUI.setupWithNavController(binding.navView, navController);
        binding.navView.setNavigationItemSelectedListener(this);
        //        NavigationUI.setupWithNavController(binding.navView, navController);


        binding.includedAppbar.searchview.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Intent i = new Intent(DashboardActivity.this, SearchResultActivity.class);
                startActivity(i);
            }
        });

        View header = binding.navView.getHeaderView(0);


        login_btn = header.findViewById(R.id.btnNavLogin);
        btnNavEdit = (AppCompatButton) header.findViewById(R.id.btnNavEdit);
        signin_btn = header.findViewById(R.id.btnNavSignin);
        btnNavSignOut = (AppCompatButton) header.findViewById(R.id.btnNavSignOut);
        tvNavProfileName = (AppCompatTextView) header.findViewById(R.id.tvNavProfileName);
        tvNavProfileEmail = (AppCompatTextView) header.findViewById(R.id.tvNavProfileEmail);
        staramt = (AppCompatTextView) header.findViewById(R.id.tvstarsSmt);
        header_logo = (AppCompatImageView) header.findViewById(R.id.header_logo);

        rlstars = (RelativeLayout) header.findViewById(R.id.rlstars);
        editLoginSign = (LinearLayout) header.findViewById(R.id.editLoginSign);
        StarRankingApp.getDataManager().getUserFromPref().getUser_id();
        user = StarRankingApp.getDataManager().getUserFromPref();

        if (!user.getUser_id().equals("")) {
            //logged in

            presenter.getUserProfileAlways(user.getUser_id(), user.getUser_type());

            tvNavProfileName.setVisibility(View.VISIBLE);
            tvNavProfileEmail.setVisibility(View.VISIBLE);
            rlstars.setVisibility(View.VISIBLE);
            btnNavEdit.setVisibility(View.VISIBLE);
            btnNavSignOut.setVisibility(View.VISIBLE);
            editLoginSign.setVisibility(View.GONE);

            tvNavProfileName.setText(user.getName());
            staramt.setText(AppUtils.getFormatedString(user.getRemaining_star()));
            header_logo.setVisibility(View.GONE);
            if (user.getLogin_type().equals(LOGIN_TYPE_FACEBOOK)) {
                tvNavProfileEmail.setText(getString(R.string.str_lbl_loggedin_fb));
            } else if (user.getLogin_type().equals(LOGIN_TYPE_NAVER)) {
                tvNavProfileEmail.setText(getString(R.string.str_lbl_loggedin_naver));
            } else if (user.getLogin_type().equals(LOGIN_TYPE_GOOGLE)) {
                tvNavProfileEmail.setText(getString(R.string.str_lbl_loggedin_google));
            } else if (user.getLogin_type().equals(LOGIN_TYPE_KAKAO)) {
                tvNavProfileEmail.setText(getString(R.string.str_lbl_loggedin_kako));
            } else {
                tvNavProfileEmail.setText(user.getEmail());
            }
        } else {


            btnNavEdit.setVisibility(View.GONE);
            btnNavSignOut.setVisibility(View.GONE);
            tvNavProfileName.setVisibility(View.GONE);
            tvNavProfileEmail.setVisibility(View.GONE);
            rlstars.setVisibility(View.GONE);
            header_logo.setVisibility(View.VISIBLE);
            editLoginSign.setVisibility(View.VISIBLE);
        }
//        if (sharedPrefHelper.getLoginSharedPref().equals("islogin")) {
//
//            tvNavProfileName.setVisibility(View.VISIBLE);
//            tvNavProfileEmail.setVisibility(View.VISIBLE);
//            rlstars.setVisibility(View.VISIBLE);
//            btnNavEdit.setVisibility(View.VISIBLE);
//            btnNavSignOut.setVisibility(View.VISIBLE);
//            editLoginSign.setVisibility(View.GONE);
//
//            header_logo.setVisibility(View.GONE);
//
//
//        }
//        else {


//        }
        binding.navTermsConditions.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Intent i = new Intent(DashboardActivity.this, SampleWebViewActivity.class);
                i.putExtra("from", "signinterms");
                startActivity(i);

            }
        });


        login_btn.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Intent i = new Intent(DashboardActivity.this, LoginActivity.class);
                startActivity(i);
                finish();
            }
        });

        signin_btn.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Intent i = new Intent(DashboardActivity.this, SignUpActivity.class);
                startActivity(i);

            }
        });
        btnNavEdit.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Intent i = new Intent(DashboardActivity.this, EditUserProfileActivity.class);
                startActivity(i);
            }
        });

        btnNavSignOut.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                final Dialog dialog = new Dialog(DashboardActivity.this);
                dialog.setContentView(R.layout.popup_logout_alert);
                dialog.getWindow().setLayout(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.WRAP_CONTENT);
                dialog.getWindow().setBackgroundDrawable(new ColorDrawable(Color.TRANSPARENT));
                dialog.setCancelable(true);

                final AppCompatButton btnpopuplogoutYes = (AppCompatButton) dialog.findViewById(R.id.btnpopuplogoutyes);
                final AppCompatButton btnpopuplogoutNo = (AppCompatButton) dialog.findViewById(R.id.btnpopuplogoutno);

                btnpopuplogoutNo.setOnClickListener(new View.OnClickListener() {
                    @Override
                    public void onClick(View v) {
                        dialog.dismiss();

                    }
                });
                btnpopuplogoutYes.setOnClickListener(new View.OnClickListener() {
                    @Override
                    public void onClick(View v) {
                        StarRankingApp.getDataManager().logout();
                        btnNavEdit.setVisibility(View.GONE);
                        btnNavSignOut.setVisibility(View.GONE);
                        tvNavProfileName.setVisibility(View.GONE);
                        tvNavProfileEmail.setVisibility(View.GONE);
                        rlstars.setVisibility(View.GONE);
                        header_logo.setVisibility(View.VISIBLE);
                        editLoginSign.setVisibility(View.VISIBLE);
                        dialog.dismiss();

                        Intent i = new Intent(DashboardActivity.this, DashboardActivity.class);
                        startActivity(i);
                        finishAffinity();
                    }
                });

                dialog.show();


            }
        });
    }


    private void setHamBurger() {


        mDrawerToggle = new ActionBarDrawerToggle(this, binding.drawerLayout, binding.includedAppbar.toolbar, 0, 0);
        mDrawerToggle.syncState();
//        binding.drawerLayout.setDrawerListener(mDrawerToggle);
        binding.btnclose.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {

                if (binding.drawerLayout.isDrawerOpen(GravityCompat.START)) {

//                    binding.drawerLayout.setDrawerLockMode(DrawerLayout.LOCK_MODE_LOCKED_OPEN);
                    binding.btnclose.setVisibility(View.GONE);
                    binding.drawerLayout.closeDrawers();
//                    binding.closelayout.setVisibility(View.GONE);
//                    new Handler().postDelayed(new Runnable() {
//                        @Override
//                        public void run() {
//
//                        }
//                    },100);


                } else {

                    binding.drawerLayout.openDrawer(GravityCompat.START);
//                    binding.closelayout.setVisibility(View.VISIBLE);
                }
            }
        });


        binding.drawerLayout.addDrawerListener(new DrawerLayout.DrawerListener() {
            @Override
            public void onDrawerSlide(@NonNull View drawerView, float slideOffset) {
//                if (slideOffset == 0) {
//                    // drawer closed
//                    binding.closelayout.setVisibility(View.GONE);
//                    invalidateOptionsMenu();
//                } else
//                if (slideOffset != 0) {
//                    // started opening
//                    binding.closelayout.setVisibility(View.VISIBLE);
//                    invalidateOptionsMenu();
//                }

            }


            @Override
            public void onDrawerOpened(@NonNull View drawerView) {
                LoginProfile loginProfile = StarRankingApp.getDataManager().getUserFromPref();
                if (loginProfile != null) {
                    staramt.setText(AppUtils.getFormatedString(loginProfile.getRemaining_star()));
                }

                binding.btnclose.setVisibility(View.VISIBLE);
            }

            @Override
            public void onDrawerClosed(@NonNull View drawerView) {
                binding.btnclose.setVisibility(View.GONE);


            }

            @Override
            public void onDrawerStateChanged(int newState) {

            }
        });

//        mDrawerToggle.setDrawerIndicatorEnabled(false);
//        mDrawerToggle.setToolbarNavigationClickListener(new View.OnClickListener() {
//            @Override
//            public void onClick(View view) {
//                Log.d("drawer", "open");
//                binding.drawerLayout.setDrawerLockMode(DrawerLayout.LOCK_MODE_UNLOCKED);
//                binding.drawerLayout.openDrawer(GravityCompat.START);
//                binding.drawerLayout.setDrawerLockMode(DrawerLayout.LOCK_MODE_LOCKED_OPEN);
//            }
//        });
//        mDrawerToggle.setHomeAsUpIndicator(R.drawable.ic_menu_ic);
        binding.includedAppbar.toolbar.setNavigationIcon(R.drawable.ic_menu_ic);

    }

    //    @RequiresApi(api = Build.VERSION_CODES.O)
    private void applyFontToMenuItem(MenuItem mi) {

        if (Build.VERSION.SDK_INT >= 26) {
            Typeface font = getResources().getFont(R.font.nanum_gothic);
            SpannableString mNewTitle = new SpannableString(mi.getTitle());
            mNewTitle.setSpan(new CustomTypeFace("", font), 0, mNewTitle.length(), Spannable.SPAN_INCLUSIVE_INCLUSIVE);
            mi.setTitle(mNewTitle);
        }

    }


    @Override
    public boolean onSupportNavigateUp() {
        NavController navController = Navigation.findNavController(this, R.id.nav_host_fragment);
        return NavigationUI.navigateUp(navController, mAppBarConfiguration)
                || super.onSupportNavigateUp();
    }

    @Override
    public void onBackPressed() {
//check id to backpress

        if (binding.drawerLayout.isDrawerOpen(GravityCompat.START)) {
            binding.drawerLayout.closeDrawers();
        } else {
//        if (id == 0) {
            if (doubleBackToExitPressedOnce) {
//                super.onBackPressed();
                finishAffinity();
                return;
            }

            this.doubleBackToExitPressedOnce = true;
            AppUtils.setToast(this, getResources().getString(R.string.str_msg_press_back_again));


            new Handler().postDelayed(new Runnable() {

                @Override
                public void run() {
                    doubleBackToExitPressedOnce = false;
                }
            }, 2000);
//        } else {
//            super.onBackPressed();
//        }

        }
    }

    @Override
    public boolean onNavigationItemSelected(@NonNull MenuItem menuItem) {

        menuItem.setChecked(false);// set true if want to highlight selected item

        binding.drawerLayout.closeDrawers();

        id = menuItem.getItemId();

        switch (id) {

            case R.id.nav_home:
                Log.d(TAG, "onNavigationItemSelected: comtestlist fragment added");
                navController.navigate(R.id.nav_home);
                break;

            case R.id.nav_freeCahrging:
//                binding.includedAppbar.searchview.setVisibility(View.GONE);
                if (!user.getUser_id().equals("")) {
                    Intent i = new Intent(getApplicationContext(), StarChargingWebview.class);
                    startActivity(i);
//                    navController.navigate(R.id.nav_freeCahrging);
                } else {
                    AppUtils.loginPopup(this);
                }

                break;
            case R.id.nav_sendStar:
//                Intent ic_star = new Intent(getApplicationContext(), SendStarsActivity.class);
//                startActivity(ic_star);
//                binding.includedAppbar.searchview.setVisibility(View.GONE);
                if (!user.getUser_id().equals("")) {
                    final Dialog dialog = new Dialog(this);
                    dialog.setContentView(R.layout.popup_sendstar);
                    dialog.getWindow().setLayout(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.WRAP_CONTENT);
                    dialog.getWindow().setBackgroundDrawable(new ColorDrawable(Color.TRANSPARENT));
                    dialog.setCancelable(false);
                    final AppCompatTextView votebar = (AppCompatTextView) dialog.findViewById(R.id.bar);
                    final AppCompatTextView tvpopupStarsAmt = (AppCompatTextView) dialog.findViewById(R.id.tvpopupStarsAmt);
                    final AppCompatEditText giftNo = (AppCompatEditText) dialog.findViewById(R.id.giftMobileNo);
                    final AppCompatEditText giftVotesAmt = (AppCompatEditText) dialog.findViewById(R.id.giftVotesAmt);
                    final AppCompatTextView btn = (AppCompatTextView) dialog.findViewById(R.id.giftbtnUseAll);
                    giftto_name = (AppCompatTextView) dialog.findViewById(R.id.giftto_name);
                    final AppCompatTextView giftWarining = (AppCompatTextView) dialog.findViewById(R.id.giftWarining);
                    final AppCompatTextView giftHint = (AppCompatTextView) dialog.findViewById(R.id.giftHint);
                    final AppCompatButton btnConfirm = (AppCompatButton) dialog.findViewById(R.id.btnConfirm);

                    mobileProfile = (CircularImageView) dialog.findViewById(R.id.mobileProfile);
                    starGift = (CircularImageView) dialog.findViewById(R.id.star);

                    LoginProfile user = StarRankingApp.getDataManager().getUserFromPref();


                    tvpopupStarsAmt.setText(AppUtils.getFormatedString(user.getRemaining_star()));
                    btn.setOnClickListener(new View.OnClickListener() {
                        @Override
                        public void onClick(View v) {
                            giftVotesAmt.setText(user.getRemaining_star());

                        }
                    });

                    giftVotesAmt.addTextChangedListener(new TextWatcher() {
                        @Override
                        public void beforeTextChanged(CharSequence s, int start, int count, int after) {

                        }

                        @Override
                        public void onTextChanged(CharSequence s, int start, int before, int count) {
                            giftto_name.setVisibility(View.VISIBLE);
                            gift_amt_to_user = giftVotesAmt.getText().toString();

                            giftto_name.setText(gift_username + " " + getResources().getString(R.string.str_lbl_gift_to) + " " + gift_amt_to_user + " " + getResources().getString(R.string.str_lbl_gift_surity));
                            giftWarining.setVisibility(View.VISIBLE);
                            giftHint.setVisibility(View.GONE);
                            starGift.setBorderColor(getApplicationContext().getResources().getColor(R.color.colorAccent));

                            if (!giftVotesAmt.getText().toString().equals("")) {

                                giftto_name.setVisibility(View.VISIBLE);
                                if (Integer.parseInt(giftVotesAmt.getText().toString()) > Integer.parseInt(user.getRemaining_star())) {
                                    isstarAmtvalid = false;
                                    AppUtils.setToast(getApplicationContext(), getResources().getString(R.string.str_not_enough_star));
                                } else {
                                    isstarAmtvalid = true;

                                }
                            } else {
                                isstarAmtvalid = false;
                            }

                            if (isValiGiftData()) {
                                btnConfirm.setClickable(true);
                                btnConfirm.setBackgroundColor(getResources().getColor(R.color.colorAccent));
                            } else {
                                btnConfirm.setClickable(false);
                                btnConfirm.setBackgroundColor(getResources().getColor(R.color.grey));

                            }
                        }

                        @Override
                        public void afterTextChanged(Editable s) {


                        }
                    });

                    giftNo.addTextChangedListener(new TextWatcher() {
                        @Override
                        public void beforeTextChanged(CharSequence s, int start, int count, int after) {
                        }

                        @Override
                        public void onTextChanged(CharSequence s, int start, int before, int count) {


                            if (s.toString().length() == 11) {
                                if (user.getMobile().equals(s.toString())) {
                                    ismobilenumbervalid = false;
                                    giftto_name.setVisibility(View.GONE);
                                    AppUtils.setToast(getApplicationContext(), getResources().getString(R.string.str_cant_gift_urself));

                                } else {
                                    ismobilenumbervalid = true;
                                    giftto_name.setVisibility(View.VISIBLE);
                                    presenter.getdetails(s.toString());
                                }

                            } else {
                                ismobilenumbervalid = false;

                                giftto_name.setVisibility(View.GONE);
                                mobileProfile.setBorderColor(getApplicationContext().getResources().getColor(R.color.circularimage_border));
                                mobileProfile.setImageResource(R.drawable.profile);
                                gift_username = "";
                                gift_userid = "";
                            }

                            if (isValiGiftData()) {
                                btnConfirm.setClickable(true);
                                btnConfirm.setBackgroundColor(getResources().getColor(R.color.colorAccent));
                            } else {
                                btnConfirm.setClickable(false);
                                btnConfirm.setBackgroundColor(getResources().getColor(R.color.grey));

                            }
                        }

                        @Override
                        public void afterTextChanged(Editable s) {


                        }
                    });


                 votebar.setOnClickListener(new View.OnClickListener() {
                        @Override
                        public void onClick(View v) {
                            dialog.dismiss();
                        }
                    });

                    btnConfirm.setOnClickListener(new View.OnClickListener() {
                        @Override
                        public void onClick(View v) {
                            if (gift_userid == null || gift_userid.isEmpty()) {
                                AppUtils.setToast(DashboardActivity.this, getString(R.string.str_msg_please_povide_valid_user));
                            } else {
                                if (isValiGiftData()) {
                                    if (isValidData()) {
                                        presenter.sendgift(gift_userid, gift_username, user.getUser_id(), user.getName(), giftVotesAmt.getText().toString());
                                        dialog.dismiss();
                                    }
                                } else {
                                    AppUtils.setToast(DashboardActivity.this, getString(R.string.str_msg_enter_proper_data));
                                }

                            }

                        }

                        boolean isValidData() {
                            if (giftVotesAmt.getText() == null || giftVotesAmt.getText().toString().isEmpty()) {
                                AppUtils.setToast(DashboardActivity.this, getString(R.string.str_msg_enter_star));
                                return false;
                            } else if (Integer.parseInt(giftVotesAmt.getText().toString()) == 0) {
                                AppUtils.setToast(DashboardActivity.this, getString(R.string.str_msg_star_can_not_0));
                                return false;
                            }
                            return true;
                        }
                    });

                    dialog.show();
                } else {
                    AppUtils.loginPopup(this);
                }

//                navController.navigate(R.id.nav_sendStar);
                break;

            case R.id.nav_history:

                if (!user.getUser_id().equals("")) {
//                    binding.includedAppbar.searchview.setVisibility(View.GONE);
                    Intent history = new Intent(getApplicationContext(), FragmentHistoryActivity.class);
                    startActivity(history);
//                    navController.navigate(R.id.nav_history);
                } else {
                    AppUtils.loginPopup(this);
                }


                break;

            case R.id.nav_guide:
//                binding.includedAppbar.searchview.setVisibility(View.GONE);
                Intent guide = new Intent(getApplicationContext(), FragmentWebviewActivity.class);
                startActivity(guide);
//                navController.navigate(R.id.nav_guide);
                break;

            case R.id.nav_notice:
//                binding.includedAppbar.searchview.setVisibility(View.GONE);
                Intent notice = new Intent(getApplicationContext(), FragmentNoticeActivity.class);
                startActivity(notice);
//                navController.navigate(R.id.nav_notice);
                break;

            case R.id.nav_notification:

                if (!user.getUser_id().equals("")) {
//                    binding.includedAppbar.searchview.setVisibility(View.GONE);
                    Intent notification = new Intent(getApplicationContext(), FragmentNotificationActivity.class);
                    startActivity(notification);
//                    navController.navigate(R.id.nav_notification);
                } else {
                    AppUtils.loginPopup(this);
                }

                break;

            case R.id.nav_settings:
                if (!user.getUser_id().equals("")) {
//                    binding.includedAppbar.searchview.setVisibility(View.GONE);
                    Intent settings = new Intent(getApplicationContext(), FragmentSettingsActivity.class);
                    startActivity(settings);
//                    navController.navigate(R.id.nav_settings);
                } else {
                    AppUtils.loginPopup(this);
                }
                break;


        }
        return false;

    }

    Menu menu;

    //
    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        getMenuInflater().inflate(R.menu.home_menu, menu);
        this.menu = menu;
        menu.findItem(R.id.charge).setVisible(true);
//        MenuItem searchItem = menu.findItem(R.id.search);


        return super.onCreateOptionsMenu(menu);
    }


    @Override
    public boolean onOptionsItemSelected(@NonNull MenuItem item) {
        switch (item.getItemId()) {
            case R.id.charge:
//                Intent i = new Intent(DashboardActivity.this, StarChargingWebview.class);
//                startActivity(i);
                AppUtils.callStarChargigWebview(this);
                return true;


            default:
                return super.onOptionsItemSelected(item);
        }
    }


    @Override
    public void getSuccessdetailsfromMobile(UserDetailsFromMobile model) {


        mobmodel = model;
        mobileProfile.setBorderColor(getApplicationContext().getResources().getColor(R.color.colorAccent));
        AppUtils.setImageUrl(getApplicationContext(), mobmodel.getMain_image(), mobileProfile, false);
        gift_username = mobmodel.getName();
        gift_userid = mobmodel.getUser_id();


    }

    @Override
    public void failfromMobile() {
        gift_userid = "";
        gift_username = "";
        giftto_name.setVisibility(View.GONE);
    }

    @Override
    public void getSuccessGiftSent(GiftDetails response,String receiverName,String stars) {
        StarRankingApp.getDataManager().set(AppPreferencesHelper.PREF_USER_STARS, response.getRemaining_star());
        staramt.setText(AppUtils.getFormatedString(response.getRemaining_star()));
        AppUtils.showGiftSuccessDialog(this, receiverName, stars);
    }

    @Override
    public void getSuccessUserProfileAlways(LoginProfile response) {
        StarRankingApp.getDataManager().saveUserToPref(response);
    }


    @Override
    public void onfail(String message) {

    }


    public boolean isValiGiftData() {

        if (ismobilenumbervalid && isstarAmtvalid) {

            return true;
        } else {
            return false;
        }


    }

    @Override
    public void onReceiverNotification(Context context, String type, Intent intent) {
        super.onReceiverNotification(context, type, intent);
        if(Constants.LB_TYPE_STAR_UPDATED.equals(type)){
            staramt.setText(AppUtils.getFormatedString(StarRankingApp.getDataManager().get(AppPreferencesHelper.PREF_USER_STARS,"0")));
        }
    }

    @Override
    public void onRetryClicked() {
        super.onRetryClicked();
        presenter.retry();
    }
}
