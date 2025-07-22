package com.etech.starranking.data.network.model;

import java.util.ArrayList;

@SuppressWarnings("unused")
public class Pagging<V> {
    private ArrayList<V> arrayList = new ArrayList<>();
    private int pageNumber = 1;
    private boolean hasMore = true;

    public int getPageNumber() {
        return pageNumber;
    }

    public void setPageNumber(int pageNumber) {
        this.pageNumber = pageNumber;
    }

    public void setArrayList(ArrayList<V> arrayList) {
        this.arrayList = arrayList;
    }

    public ArrayList<V> getArrayList() {
        return arrayList;
    }

    public void setHasMore(boolean hasMore) {
        this.hasMore = hasMore;
    }

    public boolean hasMore() {
        return hasMore;
    }

    public void addItemToList(ArrayList<V> arrayList) {
        this.arrayList.addAll(arrayList);

    }
}
