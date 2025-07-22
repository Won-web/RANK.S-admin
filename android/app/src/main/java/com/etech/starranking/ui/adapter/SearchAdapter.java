package com.etech.starranking.ui.adapter;

import android.content.Context;
import android.graphics.Outline;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.ViewOutlineProvider;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;

import com.etech.starranking.base.BaseMainAdpter;
import com.etech.starranking.databinding.ItemSearchListBinding;
import com.etech.starranking.ui.activity.model.SearchList;
import com.etech.starranking.utils.AppUtils;

import java.util.ArrayList;

public class SearchAdapter extends BaseMainAdpter {
    public SearchAdapter(Context context, ArrayList<SearchList> arrayList, OnRecyclerviewClick<SearchList> onRecyclerviewClick) {
        init(context, arrayList, onRecyclerviewClick);
    }

    @Override
    public RecyclerView.ViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        if (viewType == TYPE_ITEM) {
            return new MyViewHolder(ItemSearchListBinding.inflate(LayoutInflater.from(context), parent, false));
        }
        return super.onCreateViewHolder(parent, viewType);
    }

    @Override
    public void onBindViewHolder(@NonNull RecyclerView.ViewHolder holder, int position) {
        super.onBindViewHolder(holder, position);
        if (holder instanceof MyViewHolder) {
            ((MyViewHolder) holder).bind((SearchList) arrayList.get(position), position);
        }

    }

    public void addItem(ArrayList<SearchList> arrayList) {
        this.arrayList.addAll(arrayList);
    }

    class MyViewHolder extends RecyclerView.ViewHolder {
        ItemSearchListBinding binding;

        public MyViewHolder(@NonNull ItemSearchListBinding binding) {
            super(binding.getRoot());
            this.binding = binding;
        }

        void bind(SearchList bean, int position) {
            ViewOutlineProvider provider = new ViewOutlineProvider() {
                @Override
                public void getOutline(View view, Outline outline) {
                    int curveRadius = 24;
                    outline.setRoundRect(0, 0, view.getWidth(), view.getHeight(), curveRadius);
                }
            };
            binding.ivsearchpic.setOutlineProvider(provider);
            binding.ivsearchpic.setClipToOutline(true);
//            binding.ivsearchpic.setBackgroundResource(R.drawable.tst);
            AppUtils.setImageUrl(context, bean.getProfileUrl(), binding.ivsearchpic);
            binding.tvSearchContestName.setText(bean.getContestName());
            binding.tvSearchContestantName.setText(bean.getContestantname());
            binding.getRoot().setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    onRecycleItemClickListener.onClick(bean, v, getAdapterPosition(), OnRecyclerviewClick.ViewType.View);
                }
            });
        }
    }
}
