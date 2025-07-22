package com.etech.starranking.ui.adapter;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;

import com.etech.starranking.base.BaseMainAdpter;
import com.etech.starranking.databinding.ItemOtherContestantDetailsBinding;

import com.etech.starranking.ui.activity.model.OtherContestantDetails;

import java.util.ArrayList;


public class OtherContestantDetailsAdapter extends BaseMainAdpter {


    private ArrayList<OtherContestantDetails> listArrayList = new ArrayList<>();

    public OtherContestantDetailsAdapter(Context context,
                                         OnRecyclerviewClick<OtherContestantDetails> click) {
        init(context, listArrayList, click);
    }

    public void addData(ArrayList<OtherContestantDetails> list) {
        this.listArrayList.clear();
        this.listArrayList.addAll(list);
        notifyDataSetChanged();
    }

    public ArrayList<OtherContestantDetails> getHomeArrayList() {
        return listArrayList;
    }

    public OtherContestantDetails getAllData(int position) {
        return listArrayList.get(position);
    }

    @NonNull
    @Override
    public RecyclerView.ViewHolder onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {

        RecyclerView.ViewHolder viewHolder = super.onCreateViewHolder(parent, viewType);
        if (viewType == TYPE_ITEM) {
            LayoutInflater layoutInflater = LayoutInflater.from(parent.getContext());
            ItemOtherContestantDetailsBinding binding = ItemOtherContestantDetailsBinding.inflate(layoutInflater,parent,false);
            viewHolder = new viewHolder(binding);

        }
        return viewHolder;

    }

    @Override
    public void onBindViewHolder(@NonNull RecyclerView.ViewHolder holder, int position) {
        super.onBindViewHolder(holder, position);
        if (holder instanceof viewHolder) {
            final viewHolder viewHolder = (viewHolder) holder;
            OtherContestantDetails list = listArrayList.get(position);
            viewHolder.itemView.setOnClickListener(
                    new View.OnClickListener() {
                        @Override
                        public void onClick(View view) {
                            onRecycleItemClickListener.onClick
                                    (OtherContestantDetailsAdapter.this.getAllData(viewHolder.getAdapterPosition()),
                                            view, viewHolder.getAdapterPosition(),
                                            OnRecyclerviewClick.ViewType.View);
                        }
                    });
//            viewHolder.binding.tvTitle.setText(list.getTitle());
//            viewHolder.binding.tvDesc.setText(list.getDesc());


//
        }
    }

    public class viewHolder extends RecyclerView.ViewHolder {
        ItemOtherContestantDetailsBinding binding;

        public viewHolder(@NonNull ItemOtherContestantDetailsBinding binding) {
            super(binding.getRoot());
            this.binding = binding;
        }


    }

}
