package com.etech.starranking.ui.adapter;

import android.content.Context;
import android.net.Uri;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;

import androidx.annotation.NonNull;
import androidx.databinding.DataBindingUtil;
import androidx.viewpager.widget.PagerAdapter;
import androidx.viewpager.widget.ViewPager;


import com.etech.starranking.R;
import com.etech.starranking.databinding.ItemPreviewImgBinding;
import com.etech.starranking.ui.activity.model.ContestantMedia;
import com.etech.starranking.utils.AppUtils;
import com.etech.starranking.utils.OnRecyclerViewItemClickListener;

import java.util.ArrayList;

public class previewImgSliderAdapter extends androidx.viewpager.widget.PagerAdapter {

    ArrayList<ContestantMedia> sliders = new ArrayList<>();

    LayoutInflater inflater;
    Context context;

    public previewImgSliderAdapter(Context context) {
        this.context = context;
        inflater = LayoutInflater.from(context);
    }

    @Override
    public int getCount() {

        return sliders.size();
    }

    public ContestantMedia getdata(int position) {
        return sliders.get(position);
    }

    @Override
    public boolean isViewFromObject(@NonNull View view, @NonNull Object object) {
        return view.equals(object);
    }

    public void addData(ArrayList<ContestantMedia> homeArrayList) {
        this.sliders.clear();
//        this.sliders.clone();

        this.sliders.addAll(homeArrayList);
        notifyDataSetChanged();

    }

    @NonNull
    @Override
    public Object instantiateItem(@NonNull ViewGroup container, final int position) {


        LayoutInflater inflater = LayoutInflater.from(context);
        ItemPreviewImgBinding binding = DataBindingUtil.inflate(inflater, R.layout.item_preview_img, container, false);
        ContestantMedia list = sliders.get(position);


        binding.tvpagenumber.setText((position + 1) + " / " + sliders.size());
        AppUtils.setImageUrl(context, list.getMediaPath(), binding.itemImgPreview, false);
        container.addView(binding.getRoot());
        return binding.getRoot();
    }


    @Override
    public void destroyItem(@NonNull ViewGroup container, int position, @NonNull Object object) {
        container.removeView((View) object);
    }


}

