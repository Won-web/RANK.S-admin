package com.etech.starranking.ui.adapter;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;

import com.etech.starranking.base.BaseMainAdpter;
import com.etech.starranking.databinding.ItemProfileImagesBinding;
import com.etech.starranking.ui.activity.model.ContestantMedia;

import com.etech.starranking.utils.AppUtils;

import java.util.ArrayList;


public class ProfileImageAdapter extends BaseMainAdpter {


    private ArrayList<ContestantMedia> listArrayList = new ArrayList<>();

    public ProfileImageAdapter(Context context,
                               OnRecyclerviewClick<ContestantMedia> click) {
        init(context, listArrayList, click);
        setAddFooter(false);
    }

    public void addData(ArrayList<ContestantMedia> list) {
        this.listArrayList.clear();
        this.listArrayList.addAll(list);
        notifyDataSetChanged();
    }

    public ArrayList<ContestantMedia> getHomeArrayList() {
        return listArrayList;
    }

    public ContestantMedia getAllData(int position) {
        return listArrayList.get(position);
    }

//    @Override
//    public int getItemCount() {
//        return listArrayList.size();
//    }

    @NonNull
    @Override
    public RecyclerView.ViewHolder onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {

        RecyclerView.ViewHolder viewHolder = super.onCreateViewHolder(parent, viewType);
        if (viewType == TYPE_ITEM) {
            LayoutInflater layoutInflater = LayoutInflater.from(parent.getContext());
            ItemProfileImagesBinding binding = ItemProfileImagesBinding.inflate(layoutInflater,parent,false);
            viewHolder = new viewHolder(binding);

        }
        return viewHolder;

    }

    @Override
    public void onBindViewHolder(@NonNull RecyclerView.ViewHolder holder, int position) {
        super.onBindViewHolder(holder, position);
        if (holder instanceof viewHolder) {
            final viewHolder viewHolder = (viewHolder) holder;
            ContestantMedia list = listArrayList.get(position);

            AppUtils.setImageUrl(context, list.getThumbPath(), viewHolder.binding.ivProfileImages,false);
            viewHolder.binding.ivProfileImages.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    onRecycleItemClickListener.onClick(ProfileImageAdapter.this.getAllData(viewHolder.getAdapterPosition()),
                            v, viewHolder.getAdapterPosition(), OnRecyclerviewClick.ViewType.Image);
                }
            });


        }
    }

    public class viewHolder extends RecyclerView.ViewHolder {
        ItemProfileImagesBinding binding;

        public viewHolder(@NonNull ItemProfileImagesBinding binding) {
            super(binding.getRoot());
            this.binding = binding;
        }


    }

}
