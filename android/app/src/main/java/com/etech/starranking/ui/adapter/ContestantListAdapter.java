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
import com.etech.starranking.databinding.ItemContestantListBinding;
import com.etech.starranking.ui.activity.model.ContestantList;
import com.etech.starranking.utils.AppUtils;

import java.util.ArrayList;


public class ContestantListAdapter extends BaseMainAdpter {


    private ArrayList<ContestantList> listArrayList = new ArrayList<>();

    public ContestantListAdapter(Context context,
                                 OnRecyclerviewClick<ContestantList> click) {
        init(context, listArrayList, click);
        setAddFooter(false);
    }

    public void addData(ArrayList<ContestantList> list) {
        this.listArrayList.clear();
        this.listArrayList.addAll(list);
        notifyDataSetChanged();
    }

    public ArrayList<ContestantList> getHomeArrayList() {
        return listArrayList;
    }

    public ContestantList getAllData(int position) {
        return listArrayList.get(position);
    }

    @NonNull
    @Override
    public RecyclerView.ViewHolder onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {

        RecyclerView.ViewHolder viewHolder = super.onCreateViewHolder(parent, viewType);
        if (viewType == TYPE_ITEM) {
            LayoutInflater layoutInflater = LayoutInflater.from(parent.getContext());
            ItemContestantListBinding binding = ItemContestantListBinding.inflate(layoutInflater,parent,false);
            viewHolder = new viewHolder(binding);

        }
        return viewHolder;

    }


    @Override
    public void onBindViewHolder(@NonNull RecyclerView.ViewHolder holder, int position) {
        super.onBindViewHolder(holder, position);
        if (holder instanceof viewHolder) {
            final viewHolder viewHolder = (viewHolder) holder;
            ContestantList list = listArrayList.get(position);
            String rank=list.getRank();
             if (rank.equals("1")|| rank.equals("2")||rank.equals("3")) {
                 if ("1".equals(rank)) {
                     rank = rank + context.getString(R.string.str_first);
                 } else if ("2".equals(rank)) {
                     rank = rank + context.getString(R.string.str_second);
                 } else if ("3".equals(rank)) {
                     rank = rank + context.getString(R.string.str_thrid);
                 }
//                 viewHolder.binding.rlContestantRank.setBackgroundResource(R.color.colorAccent);
            } else {
//                viewHolder.binding.rlContestantRank.setBackgroundResource(R.color.status_lightgrey);
            }
            viewHolder.binding.rlContestantRank.setBackgroundResource(R.color.colorAccent);
            viewHolder.itemView.setOnClickListener(
                    new View.OnClickListener() {
                        @Override
                        public void onClick(View view) {
                            onRecycleItemClickListener.onClick
                                    (ContestantListAdapter.this.getAllData(viewHolder.getAdapterPosition()),
                                            view, viewHolder.getAdapterPosition(),
                                            OnRecyclerviewClick.ViewType.View);
                        }
                    });

            viewHolder.binding.btnVote.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    onRecycleItemClickListener.onClick
                            (ContestantListAdapter.this.getAllData(viewHolder.getAdapterPosition()),
                                    v, viewHolder.getAdapterPosition(),
                                    OnRecyclerviewClick.ViewType.Button);
                }
            });
            viewHolder.binding.tvContestantRank.setText(rank);
            viewHolder.binding.tvContestantName.setText(list.getConetstantname());
            String rs = String.format("%,d", Long.parseLong(list.getContestantVotes()));
            viewHolder.binding.tvContestantVotes.setText(rs);
            AppUtils.setImageUrl(context, list.getThumb_image(), viewHolder.binding.ivContestantImg);


        }
    }

    public class viewHolder extends RecyclerView.ViewHolder {
        ItemContestantListBinding binding;

        public viewHolder(@NonNull ItemContestantListBinding binding) {
            super(binding.getRoot());
            this.binding = binding;
        }


    }

}
