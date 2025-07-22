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
import com.etech.starranking.databinding.ItemNoticeBinding;
import com.etech.starranking.ui.activity.model.NoticeList;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;


public class NoticeListAdapter extends BaseMainAdpter {


    private ArrayList<NoticeList> listArrayList = new ArrayList<>();

    public NoticeListAdapter(Context context,
                             OnRecyclerviewClick<NoticeList> click) {
        init(context, listArrayList, click);
        setAddFooter(false);
    }

    public void addData(ArrayList<NoticeList> list) {
        this.listArrayList.clear();
        this.listArrayList.addAll(list);
        notifyDataSetChanged();
    }

    public ArrayList<NoticeList> getHomeArrayList() {
        return listArrayList;
    }

    public NoticeList getAllData(int position) {
        return listArrayList.get(position);
    }

    @NonNull
    @Override
    public RecyclerView.ViewHolder onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {

        RecyclerView.ViewHolder viewHolder = super.onCreateViewHolder(parent, viewType);
        if (viewType == TYPE_ITEM) {
            LayoutInflater layoutInflater = LayoutInflater.from(parent.getContext());
            ItemNoticeBinding binding = ItemNoticeBinding.inflate(layoutInflater,parent,false);
            viewHolder = new viewHolder(binding);

        }
        return viewHolder;

    }


    @Override
    public void onBindViewHolder(@NonNull RecyclerView.ViewHolder holder, int position) {
        super.onBindViewHolder(holder, position);
        if (holder instanceof viewHolder) {
            final viewHolder viewHolder = (viewHolder) holder;
            NoticeList list = listArrayList.get(position);

            viewHolder.itemView.setOnClickListener(
                    new View.OnClickListener() {
                        @Override
                        public void onClick(View view) {
                            onRecycleItemClickListener.onClick
                                    (NoticeListAdapter.this.getAllData(viewHolder.getAdapterPosition()),
                                            view, viewHolder.getAdapterPosition(),
                                            OnRecyclerviewClick.ViewType.View);
                        }
                    });


            SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd hh:mm:ss");
            Date newDate = null;
            try {
                newDate = format.parse(list.getCreated_date());
            } catch (ParseException e) {
            }

            format = new SimpleDateFormat("yyyy.MM.dd");
            String date = format.format(newDate);

            viewHolder.binding.tvNoticeTime.setText(date);

            viewHolder.binding.tvNoticeTitle.setText(list.getMessage_title());

            viewHolder.binding.tvGotoNotice.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    onRecycleItemClickListener.onClick
                            (NoticeListAdapter.this.getAllData(viewHolder.getAdapterPosition()),
                                    v, viewHolder.getAdapterPosition(),
                                    OnRecyclerviewClick.ViewType.Text);
                }
            });


        }
    }

    public class viewHolder extends RecyclerView.ViewHolder {
        ItemNoticeBinding binding;

        public viewHolder(@NonNull ItemNoticeBinding binding) {
            super(binding.getRoot());
            this.binding = binding;
        }


    }

}
