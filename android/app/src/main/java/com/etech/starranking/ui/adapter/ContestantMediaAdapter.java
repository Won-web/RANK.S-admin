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
import com.etech.starranking.databinding.ItemProfileImgGridBinding;
import com.etech.starranking.ui.activity.model.ContestantMedia;
import com.etech.starranking.utils.AppUtils;

import java.util.ArrayList;

import static com.etech.starranking.utils.Constants.MAX_MEDIA_IMAGE_COUNT;
import static com.etech.starranking.utils.Constants.MAX_MEDIA_VIDEO_COUNT;
import static com.etech.starranking.utils.Constants.MEDIA_TYPE_IMAGE;
import static com.etech.starranking.utils.Constants.MEDIA_TYPE_VIDEO;


public class ContestantMediaAdapter extends BaseMainAdpter {


    private ArrayList<ContestantMedia> listArrayList = new ArrayList<>();

    public ContestantMediaAdapter(Context context,
                                  OnRecyclerviewClick click) {
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

    @Override
    public int getItemViewType(int position) {
        if (position == getItemCount() - 1 && isAddItemNeedToShow()) {
            return TYPE_ITEM1;
        }
        return super.getItemViewType(position);
    }

    @Override
    public int getItemCount() {
        if (isAddItemNeedToShow()) {
            return arrayList.size() + 1;
        } else {
            return arrayList.size();
        }
    }

    private boolean isAddItemNeedToShow() {
        return  canWeAddNewImage()|| canWeAddNewVideo();
    }
    private boolean canWeAddNewImage() {
        int count = 0;
        for (int i = 0; i < arrayList.size(); i++) {
            ContestantMedia item = (ContestantMedia) arrayList.get(i);
            if (MEDIA_TYPE_IMAGE.equals(item.getMediaType())) {
                count = count + 1;
            }
        }
        if (count < MAX_MEDIA_IMAGE_COUNT) {
            return true;
        }
        return false;
    }

    private boolean canWeAddNewVideo() {
        int count = 0;
        for (int i = 0; i < arrayList.size(); i++) {
            ContestantMedia item = (ContestantMedia) arrayList.get(i);
            if (MEDIA_TYPE_VIDEO.equals(item.getMediaType())) {
                count = count + 1;
            }
        }
        if (count < MAX_MEDIA_VIDEO_COUNT) {
            return true;
        }
        return false;
    }

    @NonNull
    @Override
    public RecyclerView.ViewHolder onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {

        RecyclerView.ViewHolder viewHolder = super.onCreateViewHolder(parent, viewType);
        if (viewType == TYPE_ITEM) {
            LayoutInflater layoutInflater = LayoutInflater.from(parent.getContext());
            ItemProfileImgGridBinding binding = ItemProfileImgGridBinding.inflate(layoutInflater,parent,false);
            viewHolder = new MyViewHolder(binding);
        } else if (viewType == TYPE_ITEM1) {
            return new AddMediaViewHolder(LayoutInflater.from(context).inflate(R.layout.item_add_media, parent, false));
        }
        return viewHolder;
    }


    @Override
    public void onBindViewHolder(@NonNull RecyclerView.ViewHolder holder, int position) {
        super.onBindViewHolder(holder, position);
        if (holder instanceof MyViewHolder) {
            final MyViewHolder myViewHolder = (MyViewHolder) holder;
            ContestantMedia item = listArrayList.get(position);
            myViewHolder.itemView.setOnClickListener(
                    new View.OnClickListener() {
                        @Override
                        public void onClick(View view) {
                            onRecycleItemClickListener.onClick
                                    (ContestantMediaAdapter.this.getAllData(myViewHolder.getAdapterPosition()),
                                            view, myViewHolder.getAdapterPosition(),
                                            OnRecyclerviewClick.ViewType.View);
                        }
                    });
            myViewHolder.binding.ivDelete.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    onRecycleItemClickListener.onClick(item, v, myViewHolder.getAdapterPosition(), OnRecyclerviewClick.ViewType.Delete);
                }
            });
            if (item.isLocal()) {
                AppUtils.setImageUrl(context, item.getMediaUri(), myViewHolder.binding.ivEditpic);
            } else {
                AppUtils.setImageUrl(context, item.getThumbPath(), myViewHolder.binding.ivEditpic);
            }
        } else if (holder instanceof AddMediaViewHolder) {
            holder.itemView.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    onRecycleItemClickListener.onClick(new Object(), v, holder.getAdapterPosition(), OnRecyclerviewClick.ViewType.Add);
                }
            });
        }
    }

    private static class MyViewHolder extends RecyclerView.ViewHolder {
        ItemProfileImgGridBinding binding;

        MyViewHolder(@NonNull ItemProfileImgGridBinding binding) {
            super(binding.getRoot());
            this.binding = binding;
        }
    }

    private static class AddMediaViewHolder extends RecyclerView.ViewHolder {
        public AddMediaViewHolder(@NonNull View itemView) {
            super(itemView);
        }
    }

}
