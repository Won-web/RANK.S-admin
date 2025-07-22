package com.etech.starranking.ui.activity.ui.update;

import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;
import android.util.Log;
import android.view.View;

import androidx.annotation.Nullable;
import androidx.databinding.DataBindingUtil;

import com.etech.starranking.R;
import com.etech.starranking.app.StarRankingApp;
import com.etech.starranking.base.BaseActivity;
import com.etech.starranking.databinding.ActivityUpdateVersionBinding;
import com.etech.starranking.utils.Constants;

import org.json.JSONException;
import org.json.JSONObject;

public class ActivityUpdateAvailable extends BaseActivity {
    ActivityUpdateVersionBinding binding;
    JSONObject androidUpdate;
    String isForceUpdate;
    String URL = "";

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        binding = DataBindingUtil.setContentView(this, R.layout.activity_update_version);
        Intent intent = getIntent();
        String intentString = intent.getStringExtra("UpdateData");
        binding.layoutTool.ibCharge.setVisibility(View.GONE);

        try {
            JSONObject obj = new JSONObject(intentString);
            androidUpdate = obj.getJSONObject(Constants.RES_HAS_UPGRADE_ANDROID);
            isForceUpdate = androidUpdate.getString(Constants.FORCE_UPDATE_APP);
            URL = androidUpdate.getString(Constants.URL);
            binding.tvMessage.setText(androidUpdate.getString("MessageType"));
            binding.buttonUpdate.setText(androidUpdate.getString("update_button_title"));
            binding.buttonSkip.setText(androidUpdate.getString("skip_button_title"));


        } catch (JSONException e) {
            e.printStackTrace();
        }
        if(isForceUpdate.equals(Constants.YES)){
            binding.buttonSkip.setVisibility(View.GONE);
            binding.layoutTool.ibBack.setVisibility(View.GONE);
        }
        if(isForceUpdate.equals("no")){
            binding.buttonSkip.setVisibility(View.VISIBLE);
            binding.layoutTool.ibBack.setVisibility(View.VISIBLE);
        }

        binding.layoutTool.ibBack.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                onBackPressed();
            }
        });
        binding.buttonUpdate.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if(!URL.isEmpty()){
                    startActivity(new Intent(Intent.ACTION_VIEW,
                            Uri.parse(URL)));

                }

               // finish();
            }
        });
        binding.buttonSkip.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {

                StarRankingApp.getDataManager().setResponseOfSkipButton("true");
                finish();
            }
        });
    }

    @Override
    public void onBackPressed() {
        if(!isForceUpdate.equals("yes")){
            StarRankingApp.getDataManager().setResponseOfSkipButton("true");
            super.onBackPressed();
        }


    }


}

