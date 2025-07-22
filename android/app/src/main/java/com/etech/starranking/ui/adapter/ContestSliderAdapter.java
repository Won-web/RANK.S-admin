package com.etech.starranking.ui.adapter;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import androidx.annotation.NonNull;
import androidx.databinding.DataBindingUtil;

import com.etech.starranking.R;
import com.etech.starranking.base.BaseMainAdpter;
import com.etech.starranking.databinding.ItemLayoutSliderBinding;
import com.etech.starranking.ui.activity.model.ContestSliderContents;
import com.etech.starranking.utils.AppUtils;
import com.etech.starranking.utils.OnRecyclerViewItemClickListener;

import java.util.ArrayList;
import java.util.logging.Handler;

public class ContestSliderAdapter extends androidx.viewpager.widget.PagerAdapter {

    ArrayList<ContestSliderContents> sliders = new ArrayList<>();

    LayoutInflater inflater;
    private OnRecyclerViewItemClickListener onRecyclerViewItemClickListener;
    Context context;

    public ContestSliderAdapter(Context context, OnRecyclerViewItemClickListener<ContestSliderContents> onRecyclerViewItemClickListener) {
        this.context = context;
        this.onRecyclerViewItemClickListener = onRecyclerViewItemClickListener;


        inflater = LayoutInflater.from(context);
    }

    @Override
    public int getCount() {

        return sliders.size();
    }

    public ContestSliderContents getdata(int position) {
        return sliders.get(position);
    }

    @Override
    public boolean isViewFromObject(@NonNull View view, @NonNull Object object) {
        return view.equals(object);
    }

    public void addData(ArrayList<ContestSliderContents> homeArrayList) {
        this.sliders.clear();
//        this.sliders.clone();

        this.sliders.addAll(homeArrayList);
        notifyDataSetChanged();

    }

    @NonNull
    @Override
    public Object instantiateItem(@NonNull ViewGroup container, final int position) {


        LayoutInflater inflater = LayoutInflater.from(context);
        ItemLayoutSliderBinding binding = DataBindingUtil.inflate(inflater, R.layout.item_layout_slider, container, false);
        ContestSliderContents list = sliders.get(position);

        binding.tvpgPos.setText("" + (position + 1));
        binding.tvpgCount.setText("/" + sliders.size());


        binding.ivbanner.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                onRecyclerViewItemClickListener.onClicked(sliders.get(position), v, position, OnRecyclerViewItemClickListener.ViewType.ViewPager);
            }
        });
        binding.pause.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                onRecyclerViewItemClickListener.onClicked(sliders.get(position), v, position, OnRecyclerViewItemClickListener.ViewType.Button);
            }
        });


        AppUtils.setImageUrl(context, list.getBannerImage(), binding.ivbanner);
        container.addView(binding.getRoot());
        return binding.getRoot();
    }


    @Override
    public void destroyItem(@NonNull ViewGroup container, int position, @NonNull Object object) {
        container.removeView((View) object);
    }


}
