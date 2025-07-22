package com.etech.starranking.ui.adapter;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;

import com.etech.starranking.base.BaseMainAdpter;
import com.etech.starranking.databinding.ItemVoteHistoryBinding;
import com.etech.starranking.ui.activity.model.ContestantVoteHistoryList;
import com.etech.starranking.utils.AppUtils;

import java.util.ArrayList;


public class ContestantVoteListAdapter extends BaseMainAdpter {

    private ArrayList<ContestantVoteHistoryList> listArrayList = new ArrayList<>();

    public ContestantVoteListAdapter(Context context,
                                     OnRecyclerviewClick<ContestantVoteHistoryList> click) {
        init(context, listArrayList, click);
        setAddFooter(false);
    }

    public void addData(ArrayList<ContestantVoteHistoryList> list) {
        this.listArrayList.clear();
        this.listArrayList.addAll(list);
        notifyDataSetChanged();
    }

    public ArrayList<ContestantVoteHistoryList> get_ArrayList() {
        return listArrayList;
    }

    public ContestantVoteHistoryList getAllData(int position) {
        return listArrayList.get(position);
    }

    @NonNull
    @Override
    public RecyclerView.ViewHolder onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {

        RecyclerView.ViewHolder viewHolder = super.onCreateViewHolder(parent, viewType);
        if (viewType == TYPE_ITEM) {
            LayoutInflater layoutInflater = LayoutInflater.from(parent.getContext());
            ItemVoteHistoryBinding binding = ItemVoteHistoryBinding.inflate(layoutInflater,parent,false);
            viewHolder = new viewHolder(binding);

        }
        return viewHolder;

    }

    @Override
    public void onBindViewHolder(@NonNull RecyclerView.ViewHolder holder, int position) {
        super.onBindViewHolder(holder, position);
        if (holder instanceof viewHolder) {
            final viewHolder viewHolder = (viewHolder) holder;
            ContestantVoteHistoryList list = listArrayList.get(position);
//            viewHolder.bind(list);
            viewHolder.itemView.setOnClickListener(
                    new View.OnClickListener() {
                        @Override
                        public void onClick(View view) {
                            onRecycleItemClickListener.onClick
                                    (ContestantVoteListAdapter.this.getAllData(viewHolder.getAdapterPosition()),
                                            view, viewHolder.getAdapterPosition(),
                                            OnRecyclerviewClick.ViewType.View);
                        }
                    });
            viewHolder.binding.tvVoteSrNo.setText(list.getRanking());
            viewHolder.binding.tvVotername.setText(list.getNick_name());
            viewHolder.binding.tvVotesCount.setText(AppUtils.getFormatedString(list.getVote()));


        }
    }

    public class viewHolder extends RecyclerView.ViewHolder {
        ItemVoteHistoryBinding binding;

        public viewHolder(@NonNull ItemVoteHistoryBinding binding) {
            super(binding.getRoot());
            this.binding = binding;
        }


    }

}
