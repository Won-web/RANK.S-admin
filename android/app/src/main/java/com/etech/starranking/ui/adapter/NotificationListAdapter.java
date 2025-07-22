package com.etech.starranking.ui.adapter;

import android.content.Context;
import android.os.Build;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import androidx.annotation.NonNull;
import androidx.annotation.RequiresApi;
import androidx.recyclerview.widget.RecyclerView;

import com.etech.starranking.base.BaseMainAdpter;
import com.etech.starranking.databinding.ItemNotificationBinding;
import com.etech.starranking.ui.activity.model.NotificationsList;

import java.util.ArrayList;


public class NotificationListAdapter extends BaseMainAdpter {


    private ArrayList<NotificationsList> listArrayList = new ArrayList<>();

    public NotificationListAdapter(Context context,
                                   OnRecyclerviewClick<NotificationsList> click) {
        init(context, listArrayList, click);
        setAddFooter(false);
    }

    public void addData(ArrayList<NotificationsList> list) {
        this.listArrayList.clear();
        this.listArrayList.addAll(list);
        notifyDataSetChanged();
    }

    public ArrayList<NotificationsList> getHomeArrayList() {
        return listArrayList;
    }

    public NotificationsList getAllData(int position) {
        return listArrayList.get(position);
    }

    @NonNull
    @Override
    public RecyclerView.ViewHolder onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {

        RecyclerView.ViewHolder viewHolder = super.onCreateViewHolder(parent, viewType);
        if (viewType == TYPE_ITEM) {
            LayoutInflater layoutInflater = LayoutInflater.from(parent.getContext());
            ItemNotificationBinding binding = ItemNotificationBinding.inflate(layoutInflater,parent,false);
            viewHolder = new viewHolder(binding);

        }
        return viewHolder;

    }


    @Override
    public void onBindViewHolder(@NonNull RecyclerView.ViewHolder holder, int position) {
        super.onBindViewHolder(holder, position);
        if (holder instanceof viewHolder) {
            final viewHolder viewHolder = (viewHolder) holder;
            NotificationsList list = listArrayList.get(position);

            viewHolder.itemView.setOnClickListener(
                    new View.OnClickListener() {
                        @Override
                        public void onClick(View view) {
                            onRecycleItemClickListener.onClick
                                    (NotificationListAdapter.this.getAllData(viewHolder.getAdapterPosition()),
                                            view, viewHolder.getAdapterPosition(),
                                            OnRecyclerviewClick.ViewType.View);
                        }
                    });


            viewHolder.binding.tvNotificationTime.setText(list.getCreated_date());
            viewHolder.binding.tvNotificationTitle.setText(list.getMessage_title());
            viewHolder.binding.tvNotificationContent.setText(list.getMessage());
            viewHolder.binding.tvNotificationTime.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    onRecycleItemClickListener.onClick
                            (NotificationListAdapter.this.getAllData(viewHolder.getAdapterPosition()),
                                    v, viewHolder.getAdapterPosition(),
                                    OnRecyclerviewClick.ViewType.Text);
                }
            });


        }
    }

    public class viewHolder extends RecyclerView.ViewHolder {
        ItemNotificationBinding binding;

        public viewHolder(@NonNull ItemNotificationBinding binding) {
            super(binding.getRoot());
            this.binding = binding;
        }


    }

}
