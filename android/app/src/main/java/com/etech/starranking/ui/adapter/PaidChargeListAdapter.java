package com.etech.starranking.ui.adapter;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;

import com.etech.starranking.R;
import com.etech.starranking.base.BaseMainAdpter;
import com.etech.starranking.databinding.ItemPaidChargeItemsBinding;
import com.etech.starranking.ui.activity.model.PaidChargeList;

import java.util.ArrayList;


public class PaidChargeListAdapter extends BaseMainAdpter {


    private ArrayList<PaidChargeList> listArrayList = new ArrayList<>();

    public PaidChargeListAdapter(Context context,
                                 OnRecyclerviewClick<PaidChargeList> click) {
        init(context, listArrayList, click);
        setAddFooter(false);
    }

    public void addData(ArrayList<PaidChargeList> list) {
        this.listArrayList.clear();
        this.listArrayList.addAll(list);
        notifyDataSetChanged();
    }

    public ArrayList<PaidChargeList> get_ArrayList() {
        return listArrayList;
    }

    public PaidChargeList getAllData(int position) {
        return listArrayList.get(position);
    }

    @NonNull
    @Override
    public RecyclerView.ViewHolder onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {

        RecyclerView.ViewHolder viewHolder = super.onCreateViewHolder(parent, viewType);
        if (viewType == TYPE_ITEM) {
            LayoutInflater layoutInflater = LayoutInflater.from(parent.getContext());
            ItemPaidChargeItemsBinding binding = ItemPaidChargeItemsBinding.inflate(layoutInflater,parent,false);
            viewHolder = new viewHolder(binding);

        }
        return viewHolder;

    }

    @Override
    public void onBindViewHolder(@NonNull RecyclerView.ViewHolder holder, int position) {
        super.onBindViewHolder(holder, position);
        if (holder instanceof viewHolder) {
            final viewHolder viewHolder = (viewHolder) holder;
            PaidChargeList list = listArrayList.get(position);
//            viewHolder.bind(list);
            viewHolder.binding.btnPurchaseAmt.setOnClickListener(
                    new View.OnClickListener() {
                        @Override
                        public void onClick(View view) {
                            onRecycleItemClickListener.onClick
                                    (list,
                                            view, viewHolder.getAdapterPosition(),
                                            OnRecyclerviewClick.ViewType.View);
                        }
                    });
            String listrs = String.format("%,d", Long.parseLong(list.getStar()));
            viewHolder.binding.tvStars.setText(listrs + context.getString(R.string.str_lbl_paid_charge_list_postfix));
            String rs = String.format("%,d", Long.parseLong(list.getPrice()));
            viewHolder.binding.btnPurchaseAmt.setText("₩" + rs);


        }
    }

    public class viewHolder extends RecyclerView.ViewHolder {
        ItemPaidChargeItemsBinding binding;

        public viewHolder(@NonNull ItemPaidChargeItemsBinding binding) {
            super(binding.getRoot());
            this.binding = binding;
        }

    }

}
