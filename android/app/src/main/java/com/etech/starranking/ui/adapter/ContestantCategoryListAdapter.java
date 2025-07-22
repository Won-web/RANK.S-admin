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
import com.etech.starranking.databinding.ItemRvContestantCategoriesBinding;
import com.etech.starranking.ui.activity.model.CategoryList;

import java.util.ArrayList;


public class ContestantCategoryListAdapter extends BaseMainAdpter {


    private ArrayList<CategoryList> listArrayList = new ArrayList<>();

    public ContestantCategoryListAdapter(Context context,
                                         OnRecyclerviewClick<CategoryList> click) {
        init(context, listArrayList, click);
        setAddFooter(false);
    }

    public void addData(ArrayList<CategoryList> list) {
        this.listArrayList.clear();
        this.listArrayList.addAll(list);
        notifyDataSetChanged();
    }

    public ArrayList<CategoryList> getHomeArrayList() {
        return listArrayList;
    }

    public CategoryList getAllData(int position) {
        return listArrayList.get(position);
    }

    @NonNull
    @Override
    public RecyclerView.ViewHolder onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {

        RecyclerView.ViewHolder viewHolder = super.onCreateViewHolder(parent, viewType);
        if (viewType == TYPE_ITEM) {
            LayoutInflater layoutInflater = LayoutInflater.from(parent.getContext());
            ItemRvContestantCategoriesBinding binding = ItemRvContestantCategoriesBinding.inflate(layoutInflater,parent,false);
            viewHolder = new viewHolder(binding);

        }
        return viewHolder;

    }


    @Override
    public void onBindViewHolder(@NonNull RecyclerView.ViewHolder holder, int position) {
        super.onBindViewHolder(holder, position);
        if (holder instanceof viewHolder) {
            final viewHolder viewHolder = (viewHolder) holder;
            CategoryList list = listArrayList.get(position);
            if (list.isSelected()) {

                viewHolder.binding.tvItemCat.setTextColor(context.getResources().getColor(R.color.white));
                viewHolder.binding.tvItemCat.setBackgroundResource(R.drawable.btn_filled_login);
            } else {
                viewHolder.binding.tvItemCat.setTextColor(context.getResources().getColor(R.color.colorAccent));
                viewHolder.binding.tvItemCat.setBackgroundResource(R.drawable.btn_round);
            }

            //  viewHolder.itemView.setBackgroundColor(list.isSelected() ? Color.parseColor("#F04689") : Color.WHITE);
            viewHolder.binding.tvItemCat.setOnClickListener(
                    new View.OnClickListener() {
                        @Override
                        public void onClick(View view) {
                            onRecycleItemClickListener.onClick
                                    (ContestantCategoryListAdapter.this.getAllData(viewHolder.getAdapterPosition()),
                                            view, viewHolder.getAdapterPosition(),
                                            OnRecyclerviewClick.ViewType.View);
                        }
                    });
            viewHolder.binding.tvItemCat.setText(list.getCatName());


        }
    }

    public class viewHolder extends RecyclerView.ViewHolder {
        ItemRvContestantCategoriesBinding binding;

        public viewHolder(@NonNull ItemRvContestantCategoriesBinding binding) {
            super(binding.getRoot());
            this.binding = binding;
        }


    }

}
