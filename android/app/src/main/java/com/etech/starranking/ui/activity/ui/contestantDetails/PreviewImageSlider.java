package com.etech.starranking.ui.activity.ui.contestantDetails;

import androidx.appcompat.app.AppCompatActivity;
import androidx.databinding.DataBindingUtil;

import android.os.Bundle;
import android.view.View;
import android.view.Window;
import android.view.WindowManager;

import com.etech.starranking.R;
import com.etech.starranking.databinding.ActivityPreviewImageSliderBinding;
import com.etech.starranking.ui.activity.model.ContestantMedia;
import com.etech.starranking.ui.adapter.previewImgSliderAdapter;

import java.util.ArrayList;

public class PreviewImageSlider extends AppCompatActivity {

    public static final String ARG_POSITION="arg_PreviewImageSlider_postion";

    ActivityPreviewImageSliderBinding binding;
    ArrayList<ContestantMedia> list;

    previewImgSliderAdapter adapter;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        requestWindowFeature(Window.FEATURE_NO_TITLE);
        getWindow().setFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN, WindowManager.LayoutParams.FLAG_FULLSCREEN);
//        getSupportActionBar().hide();
        binding = DataBindingUtil.setContentView(this, R.layout.activity_preview_image_slider);
        binding.preViewExit.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                finish();
            }
        });
        if (getIntent().hasExtra("previewlist")) {
            list = (ArrayList<ContestantMedia>) getIntent().getSerializableExtra("previewlist");
        }
        adapter = new previewImgSliderAdapter(getApplicationContext());

        adapter.addData(list);
        binding.vpSliderPreview.setAdapter(adapter);
        binding.vpSliderPreview.setCurrentItem(getIntent().getIntExtra(ARG_POSITION,0));
    }
}
