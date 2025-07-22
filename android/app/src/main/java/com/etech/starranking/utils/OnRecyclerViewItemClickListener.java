package com.etech.starranking.utils;

import android.view.View;


public interface OnRecyclerViewItemClickListener<V> {
    public static enum ViewType {
        View,
        ViewPager,
        More,
        Button,
        CategoryTitle,
        Approve,
        Reject
    }

    void onClicked(V bean, View view, int position, ViewType viewType);

    void onLastItemReached();
}
