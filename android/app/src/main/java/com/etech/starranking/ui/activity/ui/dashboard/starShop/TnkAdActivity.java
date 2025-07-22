package com.etech.starranking.ui.activity.ui.dashboard.starShop;

import androidx.appcompat.app.AppCompatActivity;

import android.content.Context;
import android.os.Bundle;
import android.util.Log;
import android.view.ViewGroup;
import android.widget.Toast;

import com.etech.starranking.R;
import com.etech.starranking.app.StarRankingApp;
import com.etech.starranking.base.BaseActivity;
import com.etech.starranking.ui.activity.model.LoginProfile;
import com.tnkfactory.ad.AdListView;
import com.tnkfactory.ad.TnkAdListener;
import com.tnkfactory.ad.TnkSession;

public class TnkAdActivity extends BaseActivity {

    public static final String ARG_USER_IDX="arg_user_idx";

    @Override
    protected void onCreate(Bundle savedInstanceState) {

        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_tnk_ad);
        Context mContext = getApplicationContext();

        TnkSession.setUserName( mContext , getIntent().getStringExtra(ARG_USER_IDX));
        TnkSession.showAdList(TnkAdActivity.this,"랭킹스타 무료충전소");
/*
        AdListView adlistView = TnkSession.createAdListView(TnkAdActivity.this, true);

        adlistView.setListener(new TnkAdListener() {

            @Override

            public void onClose(int type) {

                Log.d("tnkad", "#### onClose " + type);
                finish();

            }



            @Override

            public void onShow() {

                Log.d("tnkad", "#### onShow ");

            }



            @Override

            public void onFailure(int errCode) {

            }



            @Override

            public void onLoad() {

            }
        });
        adlistView.setTitle("랭킹스타 무료 충전소");
        adlistView.setAnimationType(TnkSession.ANIMATION_BOTTOM, TnkSession.ANIMATION_BOTTOM);
        adlistView.show(TnkAdActivity.this);


*/


        AdListView adlistView = TnkSession.createAdListView(TnkAdActivity.this, true);
        adlistView.setTitle("Get Free Coins!!");

        ViewGroup viewGroup = (ViewGroup)findViewById(R.id.adlist);
        viewGroup.addView(adlistView);
        adlistView.loadAdList();
    }




}
