package com.etech.starranking.utils;

import android.content.Context;
import android.util.AttributeSet;
import android.util.Log;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.recyclerview.widget.RecyclerView;
import androidx.swiperefreshlayout.widget.SwipeRefreshLayout;

public class FixedRecyclerView extends RecyclerView {
    public FixedRecyclerView(@NonNull Context context) {
        super(context);
        init();
    }

    public FixedRecyclerView(@NonNull Context context, @Nullable AttributeSet attrs) {
        super(context, attrs);
    }

    public FixedRecyclerView(@NonNull Context context, @Nullable AttributeSet attrs, int defStyle) {
        super(context, attrs, defStyle);
    }

    private void init() {

    }

//    SwipeRefreshLayout swipeRefreshLayout;
private static final String TAG = "FixedRecyclerView";
    public void setSwipeRefreshLayout(SwipeRefreshLayout swipeRefreshLayout) {

//        this.swipeRefreshLayout = swipeRefreshLayout;
        addOnScrollListener(new RecyclerView.OnScrollListener() {
            @Override
            public void onScrolled(RecyclerView recyclerView, int dx, int dy) {
//                Log.d(TAG, "onScrolled: x="+dx+" y="+dy);
//                int topRowVerticalPosition =
//                        (recyclerView == null || recyclerView.getChildCount() == 0) ? 0 : recyclerView.getChildAt(0).getTop();
//                if (swipeRefreshLayout != null)
                if(canScrollVertically(-1)){

//                    Log.d(TAG, "onScrolled: swipe refresh disabled");
                    swipeRefreshLayout.setEnabled(false);
                }else{
//                    Log.d(TAG, "onScrolled: swipe refresh enabled");
                    swipeRefreshLayout.setEnabled(true);
                }

            }

            @Override
            public void onScrollStateChanged(RecyclerView recyclerView, int newState) {
                super.onScrollStateChanged(recyclerView, newState);
            }
        });
    }
}
