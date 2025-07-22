package com.etech.starranking.ui.adapter;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;

import androidx.annotation.NonNull;
import androidx.appcompat.widget.AppCompatTextView;
import androidx.recyclerview.widget.RecyclerView;

import com.etech.starranking.R;
import com.etech.starranking.base.BaseMainAdpter;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

public class HashMapAdapter extends BaseMainAdpter {

    private HashMap<String, String> mData = new HashMap<String, String>();
    private ArrayList<String > keys;
//    private String[] mKeys;

    public HashMapAdapter(Context context, HashMap<String, String> data) {
        mData = data;
        keys=new ArrayList<>();
        keys.addAll(mData.keySet());
        init(context, new ArrayList(), new OnRecyclerviewClick() {
            @Override
            public void onClick(Object model, View view, int position, ViewType viewType) {

            }

            @Override
            public void onLastItemReached() {

            }
        });

//        mKeys = mData.keySet().toArray(new String[data.size()]);
        setAddFooter(false);
    }

    @Override
    public int getItemCount() {
        return mData.size();
    }


    @Override
    public RecyclerView.ViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        if(viewType == TYPE_ITEM){
            return new ViewHolder(LayoutInflater.from(context).inflate(R.layout.item_other_contestant_details,parent,false));
        }
        return super.onCreateViewHolder(parent, viewType);
    }

    @Override
    public void onBindViewHolder(@NonNull RecyclerView.ViewHolder holder, int position, @NonNull List<Object> payloads) {
        if(holder instanceof ViewHolder){
            AppCompatTextView tvtitle = (AppCompatTextView) holder.itemView.findViewById(R.id.textTitle);
            AppCompatTextView tvdesc = (AppCompatTextView) holder.itemView.findViewById(R.id.tvDesc);
            tvtitle.setText(keys.get(position));
            tvdesc.setText(mData.get(keys.get(position)));
        }
        super.onBindViewHolder(holder, position, payloads);
    }

    class ViewHolder extends RecyclerView.ViewHolder{
        public ViewHolder(@NonNull View itemView) {
            super(itemView);
        }
    }

    /*  @Override
    public Object getItem(int position) {
        return mData.get(mKeys[position]);
    }

    @Override
    public long getItemId(int arg0) {
        return arg0;
    }

    @Override
    public View getView(int pos, View convertView, ViewGroup parent) {
        LayoutInflater layoutInflater = LayoutInflater.from(parent.getContext());
        convertView = layoutInflater.inflate(R.layout.item_other_contestant_details, null);
//        String key = mKeys[pos];
//        String Value = getItem(pos).toString();

        AppCompatTextView tvtitle = (AppCompatTextView) convertView.findViewById(R.id.textTitle);
        tvtitle.setText(mKeys[pos]);

        AppCompatTextView tvdesc = (AppCompatTextView) convertView.findViewById(R.id.tvDesc);
        tvdesc.setText(getItem(pos).toString());

        return convertView;
    }*/
}