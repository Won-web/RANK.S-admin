package com.etech.starranking.ui.adapter;

import android.content.Context;
import android.content.Intent;
import android.os.Build;
import android.os.Handler;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import androidx.annotation.NonNull;
import androidx.annotation.RequiresApi;
import androidx.core.content.ContextCompat;
import androidx.core.view.ViewCompat;
import androidx.recyclerview.widget.RecyclerView;


import com.etech.starranking.R;
import com.etech.starranking.base.BaseMainAdpter;
import com.etech.starranking.databinding.ItemSubcontestBannerBinding;
import com.etech.starranking.databinding.ItemViewPagerDashboardBinding;
import com.etech.starranking.ui.activity.model.ContestSliderContents;
import com.etech.starranking.ui.activity.model.SubContestList;
import com.etech.starranking.ui.activity.ui.dashboard.home.ContestDetailsFragmentActivity;
import com.etech.starranking.utils.AppUtils;
import com.etech.starranking.utils.OnRecyclerViewItemClickListener;

import java.util.ArrayList;
import java.util.Timer;
import java.util.TimerTask;


public class SubContestListAdapter extends BaseMainAdpter {


    private ArrayList<SubContestList> listArrayList = new ArrayList<>();
    private ArrayList<ContestSliderContents> listBanners = new ArrayList<>();

    public SubContestListAdapter(Context context,
                                 OnRecyclerviewClick<SubContestList> click) {
        init(context, listArrayList, click);
    }

    public void addData(ArrayList<SubContestList> list) {
//        this.listArrayList.clear();
        this.listArrayList.addAll(list);
        notifyDataSetChanged();
    }

    public ArrayList<SubContestList> getHomeArrayList() {
        return listArrayList;
    }

    public SubContestList getAllData(int position) {
        return listArrayList.get(position);
    }

//    @Override
//    public int getItemCount() {
//        return listArrayList.size();
//    }

    @NonNull
    @Override
    public RecyclerView.ViewHolder onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {

        RecyclerView.ViewHolder viewHolder = super.onCreateViewHolder(parent, viewType);
        if (viewType == TYPE_ITEM) {
            LayoutInflater layoutInflater = LayoutInflater.from(parent.getContext());
            ItemSubcontestBannerBinding binding = ItemSubcontestBannerBinding.inflate(layoutInflater,parent,false);
            viewHolder = new ViewHolder(binding);

        }
        if (viewType == TYPE_HEADER) {
            return new HeaderViewHolder(ItemViewPagerDashboardBinding.inflate(LayoutInflater.from(context)));
        }
        return viewHolder;

    }

    private static final String TAG = "SubContestListAdapter";


    @Override
    public void onBindViewHolder(@NonNull RecyclerView.ViewHolder holder, int position) {
        super.onBindViewHolder(holder, position);
        if (holder instanceof ViewHolder) {
            final ViewHolder viewHolder = (ViewHolder) holder;
            SubContestList list = null;
            if (isAddViewPager()) {
                list = listArrayList.get(position - 1);
            } else {
                list = listArrayList.get(position);
            }
//            viewHolder.bind(list);

            viewHolder.binding.tvstatus.setText(list.getStatus_label());
            viewHolder.binding.contestname.setText(list.getSubContestName());
//            Log.d(TAG, "onBindViewHolder: " + list.getSubContestName() + list.getSubListVotiongStatus());
            if (list.getSubListVotiongStatus().equals("open")) {
                ViewCompat.setBackgroundTintList(
                        viewHolder.binding.tvstatus,
                        ContextCompat.getColorStateList(
                                context,
                                R.color.colorPrimary
                        )
                );
//                .setBackgroundResource(R.color.colorPrimary);
                viewHolder.binding.contestname.setTextColor(context.getResources().getColor(R.color.colorAccent));


            } else if (list.getSubListVotiongStatus().equals("preparing")) {

//                viewHolder.binding.tvstatus.setBackgroundResource(R.color.darkgrey);
                ViewCompat.setBackgroundTintList(
                        viewHolder.binding.tvstatus,
                        ContextCompat.getColorStateList(
                                context,
                                R.color.darkgrey
                        )
                );
                viewHolder.binding.contestname.setTextColor(context.getResources().getColor(R.color.darkgrey));
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                    viewHolder.binding.ivsubcontest.setForeground(context.getDrawable(R.drawable.img_alpha));
                }
            } else {
//                viewHolder.binding.tvstatus.setBackgroundResource( R.color.lightgrey);
                ViewCompat.setBackgroundTintList(
                        viewHolder.binding.tvstatus,
                        ContextCompat.getColorStateList(
                                context,
                                R.color.lightgrey
                        )
                );
                viewHolder.binding.contestname.setTextColor(context.getResources().getColor(R.color.lightgrey));
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                    viewHolder.binding.ivsubcontest.setForeground(context.getDrawable(R.drawable.img_alpha));
                }

            }

            AppUtils.setImageUrl(context, list.getImageUrl(), viewHolder.binding.ivsubcontest, true, R.drawable.home_samll_holder);
            SubContestList finalList = list;
            viewHolder.itemView.setOnClickListener(
                    new View.OnClickListener() {
                        @Override
                        public void onClick(View view) {
                            //todo something
                            onRecycleItemClickListener.onClick
                                    (finalList,
                                            view, viewHolder.getAdapterPosition(),
                                            OnRecyclerviewClick.ViewType.View);
                        }
                    });

        } else if (holder instanceof HeaderViewHolder) {
//            Log.d(TAG, "onBindViewHolder: header");
//            ((HeaderViewHolder) holder).bind();

        }
    }

    public void addBanners(ArrayList<ContestSliderContents> homes) {
        Log.d(TAG, "addBanners: ");
        this.listBanners.clear();
        this.listBanners.addAll(homes);
        notifyDataSetChanged();
    }

    public class ViewHolder extends RecyclerView.ViewHolder {
        ItemSubcontestBannerBinding binding;

        public ViewHolder(@NonNull ItemSubcontestBannerBinding binding) {
            super(binding.getRoot());
            this.binding = binding;

        }
    }

    public class HeaderViewHolder extends RecyclerView.ViewHolder {
        ItemViewPagerDashboardBinding binding;
        int i = 0;
        Timer timer;
        final long DELAY_MS = 500;
        final long PERIOD_MS = 5000;
        boolean play_on_pauseoff = true;
        Handler handler;
        Runnable Update;

        HeaderViewHolder(@NonNull ItemViewPagerDashboardBinding binding) {
            super(binding.getRoot());
            Log.d(TAG, "HeaderViewHolder: create");
            this.binding = binding;
            //   setIsRecyclable(false);
            ContestSliderAdapter adapter = new ContestSliderAdapter(binding.getRoot().getContext(), new OnRecyclerViewItemClickListener<ContestSliderContents>() {
                @Override
                public void onClicked(ContestSliderContents bean, View view, int position, ViewType viewType) {
                    {

                        if (viewType == ViewType.ViewPager) {
                            Intent i = new Intent(context, ContestDetailsFragmentActivity.class);
//                        i.putExtra("img_url", bean.getBannerImage());
                            i.putExtra("contest_id", bean.getId());
                            context.startActivity(i);
                        }
                        if (viewType == ViewType.Button) {
                            if (play_on_pauseoff == true) {
//                            AppUtils.setToast(getContext(), "paused");
                                view.setBackground(context.getDrawable(R.drawable.ic_play));
                                play_on_pauseoff = false;
                            } else {
//                            AppUtils.setToast(getContext(), "played");
                                view.setBackground(context.getDrawable(R.drawable.ic_slider_pause));
                                play_on_pauseoff = true;
                            }

//                     handler.removeCallbacks(runnable);
                        }


                    }
                }

                @Override
                public void onLastItemReached() {

                }
            });
            adapter.addData(listBanners);
            binding.vpBannerSlider.setAdapter(adapter);
            handler = new Handler();
            Update = new Runnable() {
                public void run() {
                    if (i <= adapter.getCount() - 1) {
                        binding.vpBannerSlider.setCurrentItem(i, true);

                        i++;
                    }
                    if (i == adapter.getCount()) {
                        i = 0;
                    }
                }
            };


            timer = new Timer();
            timer.schedule(new TimerTask() {
                @Override
                public void run() {
                    if (play_on_pauseoff) {
                        handler.post(Update);
                    } else {
                        handler.removeCallbacks(Update);
                    }
                }
            }, DELAY_MS, PERIOD_MS);


        }


    }

    @Override
    public void onViewDetachedFromWindow(@NonNull RecyclerView.ViewHolder holder) {
        if (holder instanceof HeaderViewHolder) {
        } else
            super.onViewDetachedFromWindow(holder);
    }

    @Override
    public int getItemCount() {

        int count = super.getItemCount();
        if (isAddViewPager()) {
            return count + 1;
        } else {
            return count;
        }
    }

    @Override
    public int getItemViewType(int position) {
        if (position == 0 && isAddViewPager()) {
            return TYPE_HEADER;
        }
        return super.getItemViewType(position);
    }

    private boolean isAddViewPager() {
        return listBanners.size() > 0;
    }
}
