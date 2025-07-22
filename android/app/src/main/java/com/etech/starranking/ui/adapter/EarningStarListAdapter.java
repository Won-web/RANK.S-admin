package com.etech.starranking.ui.adapter;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;

import com.etech.starranking.R;
import com.etech.starranking.base.BaseMainAdpter;
import com.etech.starranking.databinding.ItemEarningStarHistoryBinding;
import com.etech.starranking.ui.activity.model.EarningStar;
import com.etech.starranking.utils.AppUtils;

import java.util.ArrayList;


public class EarningStarListAdapter extends BaseMainAdpter {


    private ArrayList<EarningStar> listArrayList = new ArrayList<>();

    public EarningStarListAdapter(Context context,
                                  OnRecyclerviewClick<EarningStar> click) {
        init(context, listArrayList, click);
        setAddFooter(false);
    }

    public void addData(ArrayList<EarningStar> list) {
        this.listArrayList.clear();
        this.listArrayList.addAll(list);
        notifyDataSetChanged();
    }

    public ArrayList<EarningStar> get_ArrayList() {
        return listArrayList;
    }

    public EarningStar getAllData(int position) {
        return listArrayList.get(position);
    }

    @NonNull
    @Override
    public RecyclerView.ViewHolder onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {

        RecyclerView.ViewHolder viewHolder = super.onCreateViewHolder(parent, viewType);
        if (viewType == TYPE_ITEM) {
            LayoutInflater layoutInflater = LayoutInflater.from(parent.getContext());
            ItemEarningStarHistoryBinding binding = ItemEarningStarHistoryBinding.inflate(layoutInflater, parent, false);
            viewHolder = new viewHolder(binding);

        }
        return viewHolder;

    }

    @Override
    public void onBindViewHolder(@NonNull RecyclerView.ViewHolder holder, int position) {
        super.onBindViewHolder(holder, position);
        if (holder instanceof viewHolder) {
            final viewHolder viewHolder = (viewHolder) holder;
            EarningStar list = listArrayList.get(position);
//            viewHolder.bind(list);
            viewHolder.itemView.setOnClickListener(
                    new View.OnClickListener() {
                        @Override
                        public void onClick(View view) {
                            onRecycleItemClickListener.onClick
                                    (EarningStarListAdapter.this.getAllData(viewHolder.getAdapterPosition()),
                                            view, viewHolder.getAdapterPosition(),
                                            OnRecyclerviewClick.ViewType.View);
                        }
                    });
            if (!"gift".equals(list.getType()))
                viewHolder.binding.tvEarnedFrom.setText(list.getDescription());
            else
                viewHolder.binding.tvEarnedFrom.setText(list.getDescription()+ " - " + list.getSender_name() );
            viewHolder.binding.tvStarsAmount.setText(AppUtils.getFormatedString(list.getStar()) + context.getString(R.string.str_lbl_history_postfix));
            viewHolder.binding.tvDate.setText(list.getPurchase_date());


        }
    }

    public class viewHolder extends RecyclerView.ViewHolder {
        ItemEarningStarHistoryBinding binding;

        public viewHolder(@NonNull ItemEarningStarHistoryBinding binding) {
            super(binding.getRoot());
            this.binding = binding;
        }


    }


}
