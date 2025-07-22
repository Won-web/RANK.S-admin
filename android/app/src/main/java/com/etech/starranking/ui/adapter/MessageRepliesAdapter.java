package com.etech.starranking.ui.adapter;

import android.content.Context;
import android.graphics.Typeface;
import android.text.SpannableString;
import android.text.style.StyleSpan;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;

import com.etech.starranking.base.BaseMainAdpter;
import com.etech.starranking.databinding.ItemMessageRepliesBinding;
import com.etech.starranking.ui.activity.model.CommentsModel;

import java.util.ArrayList;


public class MessageRepliesAdapter extends BaseMainAdpter {


    private ArrayList<CommentsModel> listArrayList = new ArrayList<>();

    public MessageRepliesAdapter(Context context,
                                 OnRecyclerviewClick<CommentsModel> click) {
        init(context, listArrayList, click);
    }

    public void addData(ArrayList<CommentsModel> list) {
        this.listArrayList.clear();
        this.listArrayList.addAll(list);
        notifyDataSetChanged();
    }

    public ArrayList<CommentsModel> getHomeArrayList() {
        return listArrayList;
    }

    public CommentsModel getAllData(int position) {
        return listArrayList.get(position);
    }

    @NonNull
    @Override
    public RecyclerView.ViewHolder onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {

        RecyclerView.ViewHolder viewHolder = super.onCreateViewHolder(parent, viewType);
        if (viewType == TYPE_ITEM) {
            LayoutInflater layoutInflater = LayoutInflater.from(parent.getContext());
            ItemMessageRepliesBinding binding = ItemMessageRepliesBinding.inflate(layoutInflater,parent,false);
            viewHolder = new viewHolder(binding);

        }
        return viewHolder;

    }

    @Override
    public void onBindViewHolder(@NonNull RecyclerView.ViewHolder holder, int position) {
        super.onBindViewHolder(holder, position);


        if (holder instanceof viewHolder) {
            final viewHolder viewHolder = (viewHolder) holder;
            CommentsModel list = listArrayList.get(position);
            viewHolder.itemView.setOnClickListener(
                    new View.OnClickListener() {
                        @Override
                        public void onClick(View view) {
                            onRecycleItemClickListener.onClick
                                    (MessageRepliesAdapter.this.getAllData(viewHolder.getAdapterPosition()),
                                            view, viewHolder.getAdapterPosition(),
                                            OnRecyclerviewClick.ViewType.View);
                        }
                    });
            //String steps = "Hello Everyone";
            // String title="Bold Please!";
            //
            SpannableString ss1 = new SpannableString(list.getCommenterName());
            ss1.setSpan(new StyleSpan(Typeface.BOLD), 0, ss1.length(), 0);
            // tv.append(ss1);
            // tv.append("\n");
            // tv.append(steps);
//            String boldName = "<b>" + list.getCommenterName() + "</b> ";
            viewHolder.binding.tvNameAndMessage.setText(ss1 + " " + list.getComment());
            viewHolder.binding.tvCommentTime.setText(list.getCommentTime());
            viewHolder.binding.tvReply.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    onRecycleItemClickListener.onClick
                            (MessageRepliesAdapter.this.getAllData(viewHolder.getAdapterPosition()),
                                    v, viewHolder.getAdapterPosition(),
                                    OnRecyclerviewClick.ViewType.Text);
                }
            });


//
        }
    }

    public class viewHolder extends RecyclerView.ViewHolder {
        ItemMessageRepliesBinding binding;

        public viewHolder(@NonNull ItemMessageRepliesBinding binding) {
            super(binding.getRoot());
            this.binding = binding;
        }


    }

}
