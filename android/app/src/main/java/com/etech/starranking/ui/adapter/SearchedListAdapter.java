package com.etech.starranking.ui.adapter;

import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Filter;
import android.widget.Filterable;

import androidx.annotation.NonNull;
import androidx.appcompat.widget.AppCompatImageView;
import androidx.appcompat.widget.AppCompatTextView;
import androidx.recyclerview.widget.RecyclerView;

import com.etech.starranking.R;
import com.etech.starranking.ui.activity.model.SearchList;

import java.util.ArrayList;
import java.util.List;


public class SearchedListAdapter extends RecyclerView.Adapter<SearchedListAdapter.viewHolder> implements Filterable {


    List<SearchList> list;
    List<SearchList> listfull;

    @Override
    public Filter getFilter() {
        return examplefilter;
    }

    @NonNull
    @Override
    public SearchedListAdapter.viewHolder onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {
        View v = LayoutInflater.from(parent.getContext()).inflate(R.layout.item_search_list, parent, false);

        return new viewHolder(v);
    }

    @Override
    public void onBindViewHolder(@NonNull viewHolder holder, int position) {
        SearchList item = list.get(position);
//        holder.img.setImageResource(item.getProfileUrl());
        holder.text.setText(item.getContestantname());
        holder.text2.setText(item.getContestName());
    }


    @Override
    public int getItemCount() {
        return list.size();
    }

    class viewHolder extends RecyclerView.ViewHolder {
        AppCompatTextView text;
        AppCompatTextView text2;
        AppCompatImageView img;

        public viewHolder(@NonNull View itemView) {
            super(itemView);
            text = (AppCompatTextView) itemView.findViewById(R.id.tvSearchContestName);
            text2 = (AppCompatTextView) itemView.findViewById(R.id.tvSearchContestantName);
            img = (AppCompatImageView) itemView.findViewById(R.id.ivsearchpic);
        }
    }

    public SearchedListAdapter(List<SearchList> list) {
        this.list = list;
        listfull = new ArrayList<>(list);
    }

    private Filter examplefilter = new Filter() {
        @Override
        protected FilterResults performFiltering(CharSequence constraint) {
            List<SearchList> filterlist = new ArrayList<>();

            if (constraint == null || constraint.length() == 0) {
                filterlist.addAll(listfull);
            } else {
                String patten = constraint.toString().toLowerCase().trim();
                for (SearchList item : listfull) {
                    if (item.getContestantname().toLowerCase().contains(patten)) {
                        filterlist.add(item);
                    }
                }
            }
            FilterResults results = new FilterResults();
            results.values = filterlist;
            return results;
        }

        @Override
        protected void publishResults(CharSequence constraint, FilterResults results) {
            list.clear();
            ;
            list.addAll((List) results.values);
            notifyDataSetChanged();
        }
    };
}
