package com.etech.starranking.base;

import android.content.Context;
import android.os.Handler;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;

import com.etech.starranking.databinding.LayoutProgressbarBinding;

import java.util.ArrayList;

public class BaseMainAdpter extends RecyclerView.Adapter<RecyclerView.ViewHolder> {

    protected static final int TYPE_ITEM = 0;
    protected static final int TYPE_HEADER = 1;
    private static final int TYPE_FOOTER = 2;
    protected static final int TYPE_ITEM1 = 3;

    protected ArrayList arrayList;
    protected Context context;
    protected OnRecyclerviewClick onRecycleItemClickListener;
    protected int isShowProgressBar = 1;
    private int currentPosition;
    private Handler handler;
    private boolean isAddFooter = true;

    public boolean isAddFooter() {
        return isAddFooter;
    }

    public void setAddFooter(boolean addFooter) {
        isAddFooter = addFooter;
        notifyDataSetChanged();
    }

    public void init(Context context, ArrayList arrayList, OnRecyclerviewClick onRecycleItemClickListener) {
        this.context = context;
        this.arrayList = arrayList;
        this.onRecycleItemClickListener = onRecycleItemClickListener;
        handler = new Handler();
    }


    @Override
    public RecyclerView.ViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        LayoutInflater layoutInflater = LayoutInflater.from(parent.getContext());
        if (viewType == TYPE_FOOTER) {
            LayoutProgressbarBinding itemBinding = LayoutProgressbarBinding.inflate(layoutInflater, parent, false);
            return new FooterViewHolder(itemBinding);
        }
        return null;
    }

    public void updateBottomProgress(int isShowProgressBar) {
        this.isShowProgressBar = isShowProgressBar;
        try {
            notifyDataSetChanged();
        } catch (Exception e) {

        }
    }

    private static final String TAG = "BaseMainAdpter";

    @Override
    public void onBindViewHolder(@NonNull RecyclerView.ViewHolder holder, int position) {
        currentPosition = position;

        if (holder instanceof FooterViewHolder) {
            final FooterViewHolder viewHolder = (FooterViewHolder) holder;
            if (isShowProgressBar == 0) {
                viewHolder.binding.relProgressBottomView.setVisibility(View.VISIBLE);
            } else if (isShowProgressBar == 1) {
                viewHolder.binding.relProgressBottomView.setVisibility(View.INVISIBLE);
            } else {
                viewHolder.binding.relProgressBottomView.setVisibility(View.GONE);
            }
        }
        if (position == getItemCount() - 1) {
            Log.d(TAG, "last item reached call: ");
            handler.postDelayed(new Runnable() {
                @Override
                public void run() {
                    if (currentPosition >= arrayList.size()) {
                        onRecycleItemClickListener.onLastItemReached();
                    }
                }
            }, 1000);
        }
    }

    //    @Override
//    public int getItemCount() {
//        return arrayList.size() + 1;
//    }
    @Override
    public int getItemCount() {
        if (isAddFooter)
            return arrayList.size() + 1;
        else
            return arrayList.size();
    }

    @Override
    public int getItemViewType(int position) {

        if (isAddFooter && position == getItemCount() - 1) {
            return TYPE_FOOTER;
        } else
            return TYPE_ITEM;
    }

    private class FooterViewHolder extends RecyclerView.ViewHolder {
        LayoutProgressbarBinding binding;

        public FooterViewHolder(LayoutProgressbarBinding binding) {
            super(binding.getRoot());
            this.binding = binding;
        }
    }

    public interface OnRecyclerviewClick<V> {

        public static enum ViewType {
            View, Button, Image, Text, Video, Delete, Add
        }

        public void onClick(V model, View view, int position, ViewType viewType);

        void onLastItemReached();
    }

}
