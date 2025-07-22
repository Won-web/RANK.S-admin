package com.etech.starranking.ui.adapter;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;

import com.etech.starranking.R;
import com.etech.starranking.base.BaseMainAdpter;
import com.etech.starranking.databinding.ItemUsingStarHistoryBinding;
import com.etech.starranking.ui.activity.model.UsedStar;
import com.etech.starranking.utils.AppUtils;
import com.etech.starranking.utils.Constants;

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;


public class UsedStarListAdapter extends BaseMainAdpter {


    private ArrayList<UsedStar> listArrayList = new ArrayList<>();
    private DateFormat displayDate = new SimpleDateFormat("yyyy-MM-dd");
    private DateFormat serverDate = new SimpleDateFormat("yyyy-MM-dd hh:mm:ss");

    public UsedStarListAdapter(Context context,
                               OnRecyclerviewClick<UsedStar> click) {
        init(context, listArrayList, click);
        setAddFooter(false);
    }

    public void addData(ArrayList<UsedStar> list) {
        this.listArrayList.clear();
        this.listArrayList.addAll(list);
        notifyDataSetChanged();
    }

    public ArrayList<UsedStar> get_ArrayList() {
        return listArrayList;
    }

    public UsedStar getAllData(int position) {
        return listArrayList.get(position);
    }

    @NonNull
    @Override
    public RecyclerView.ViewHolder onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {

        RecyclerView.ViewHolder viewHolder = super.onCreateViewHolder(parent, viewType);
        if (viewType == TYPE_ITEM) {
            LayoutInflater layoutInflater = LayoutInflater.from(parent.getContext());
            ItemUsingStarHistoryBinding binding = ItemUsingStarHistoryBinding.inflate(layoutInflater, parent, false);
            viewHolder = new viewHolder(binding);

        }
        return viewHolder;

    }

    @Override
    public void onBindViewHolder(@NonNull RecyclerView.ViewHolder holder, int position) {
        super.onBindViewHolder(holder, position);
        if (holder instanceof viewHolder) {
            final viewHolder viewHolder = (viewHolder) holder;
            UsedStar list = listArrayList.get(position);
//            viewHolder.bind(list);
            viewHolder.itemView.setOnClickListener(
                    new View.OnClickListener() {
                        @Override
                        public void onClick(View view) {
                            onRecycleItemClickListener.onClick
                                    (UsedStarListAdapter.this.getAllData(viewHolder.getAdapterPosition()),
                                            view, viewHolder.getAdapterPosition(),
                                            OnRecyclerviewClick.ViewType.View);
                        }
                    });
            if (Constants.VOTE.equals(list.getDescription())) {
                viewHolder.binding.tvUsedIn.setText(list.getContest_name()+" - "+list.getReceiver_name() + " " + list.getType());
            } else if(Constants.GIFT.equals(list.getDescription())){
                viewHolder.binding.tvUsedIn.setText(  list.getType()+ "- "+list.getReceiver_name() );
            } else {
                viewHolder.binding.tvUsedIn.setText(list.getReceiver_name() + " " + list.getType());
            }
            viewHolder.binding.tvUsedStarAmount.setText("-" + AppUtils.getFormatedString(list.getStar()) + context.getString(R.string.str_lbl_history_postfix));
            try {
                Date date = serverDate.parse(list.getVote_date());
                viewHolder.binding.tvDate.setText(displayDate.format(date));
            } catch (Exception e) {
                e.printStackTrace();
            }


        }
    }

    public class viewHolder extends RecyclerView.ViewHolder {
        ItemUsingStarHistoryBinding binding;

        public viewHolder(@NonNull ItemUsingStarHistoryBinding binding) {
            super(binding.getRoot());
            this.binding = binding;
        }

    }

}
