package com.etech.starranking.ui.adapter;

import android.content.Context;
import android.os.Build;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import androidx.annotation.NonNull;
import androidx.annotation.RequiresApi;
import androidx.recyclerview.widget.RecyclerView;

import com.etech.starranking.R;
import com.etech.starranking.base.BaseMainAdpter;
import com.etech.starranking.databinding.ItemVideoListBinding;
import com.etech.starranking.ui.activity.model.ContestantMedia;
import com.etech.starranking.utils.AppUtils;

import java.util.ArrayList;


public class VideoListAdapter extends BaseMainAdpter {


    private ArrayList<ContestantMedia> listArrayList = new ArrayList<>();

    public VideoListAdapter(Context context,
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

    @NonNull
    @Override
    public RecyclerView.ViewHolder onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {

        RecyclerView.ViewHolder viewHolder = super.onCreateViewHolder(parent, viewType);
        if (viewType == TYPE_ITEM) {
            LayoutInflater layoutInflater = LayoutInflater.from(parent.getContext());
            ItemVideoListBinding binding = ItemVideoListBinding.inflate(layoutInflater,parent,false);
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


            viewHolder.itemView.setOnClickListener(
                    new View.OnClickListener() {
                        @Override
                        public void onClick(View view) {
                            onRecycleItemClickListener.onClick
                                    (VideoListAdapter.this.getAllData(viewHolder.getAdapterPosition()),
                                            view, viewHolder.getAdapterPosition(),
                                            OnRecyclerviewClick.ViewType.View);
                        }
                    });


            AppUtils.setImageUrl(context, list.getThumbPath(), viewHolder.binding.ivthumblineimg, false, R.drawable.profile_video_holder);

            viewHolder.binding.ivplaypause.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    onRecycleItemClickListener.onClick(VideoListAdapter.this.getAllData(viewHolder.getAdapterPosition()),
                            v, viewHolder.getAdapterPosition(), OnRecyclerviewClick.ViewType.Button);
                }
            });

        }
    }

    public class viewHolder extends RecyclerView.ViewHolder {
        ItemVideoListBinding binding;

        public viewHolder(@NonNull ItemVideoListBinding binding) {
            super(binding.getRoot());
            this.binding = binding;
        }


    }

}
