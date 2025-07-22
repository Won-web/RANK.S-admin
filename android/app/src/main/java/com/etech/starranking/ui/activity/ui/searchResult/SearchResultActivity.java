package com.etech.starranking.ui.activity.ui.searchResult;

import android.content.Intent;
import android.os.Bundle;
import android.view.Menu;
import android.view.MenuInflater;
import android.view.MenuItem;
import android.view.View;
import android.view.inputmethod.EditorInfo;
import android.widget.EditText;

import androidx.annotation.NonNull;
import androidx.appcompat.widget.SearchView;
import androidx.databinding.DataBindingUtil;
import androidx.recyclerview.widget.LinearLayoutManager;

import com.etech.starranking.R;
import com.etech.starranking.base.BaseActivity;
import com.etech.starranking.base.BaseMainAdpter;
import com.etech.starranking.databinding.ActivitySearchResultBinding;
import com.etech.starranking.ui.activity.model.SearchList;
import com.etech.starranking.ui.activity.ui.dashboard.home.ContestantDetailsFragmentActivity;
import com.etech.starranking.ui.adapter.SearchAdapter;
import com.etech.starranking.utils.AppUtils;
import com.jakewharton.rxbinding3.appcompat.RxSearchView;

import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.TimeUnit;

import io.reactivex.Scheduler;
import io.reactivex.android.schedulers.AndroidSchedulers;
import io.reactivex.disposables.Disposable;
import io.reactivex.functions.Consumer;

public class SearchResultActivity extends BaseActivity implements SearchResultContract.View {
    SearchAdapter adapter;
    List<SearchList> examplelist;
    private static final String TAG = "SearchResultActivity";

    private ActivitySearchResultBinding binding;
    private SearchResultContract.Presenter<SearchResultContract.View> presenter;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        binding = DataBindingUtil.setContentView(this, R.layout.activity_search_result);
        presenter = new SearchResultPresenter<>();
        presenter.onAttach(this);
        initUi();
//        filllist();
//        setUpRecy();


    }

    @Override
    protected void onDestroy() {
        if (disposable != null && !disposable.isDisposed()) {
            disposable.dispose();
        }
        presenter.onDetach();
        super.onDestroy();
    }

    private void initUi() {
        setSupportActionBar(binding.toolbar);
        setTitle(null);
        setupView(binding.extraViews);
        binding.toolbar.setCollapseIcon(R.drawable.ic_arrow_back);
        AppUtils.gradientStatusbar(this);

    }

  /*  void filllist() {
        examplelist = new ArrayList<>();
        examplelist.add(new SearchList("seyone kim", "Miss korea", R.drawable.modelimg));
        examplelist.add(new SearchList("aseyone kim", "Miss taiwan", R.drawable.modelimg));
        examplelist.add(new SearchList("bseyone kim", "Miss korea", R.drawable.modelimg));
        examplelist.add(new SearchList("cseyone kim", "Miss taiwan", R.drawable.modelimg));
    }

    void setUpRecy() {
        RecyclerView rec = findViewById(R.id.recsearch);
        rec.setHasFixedSize(true);
        adapter = new SearchedListAdapter(examplelist);
        rec.setAdapter(adapter);

    }*/

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        super.onCreateOptionsMenu(menu);
        MenuInflater inflater = getMenuInflater();
        inflater.inflate(R.menu.example_menu, menu);
        setUpSearchView(menu);
        return true;
    }

    @Override
    public boolean onOptionsItemSelected(@NonNull MenuItem item) {
        return super.onOptionsItemSelected(item);
    }

    Disposable disposable;

    private void setUpSearchView(Menu menu) {
        MenuItem search = menu.findItem(R.id.ac_search);

        search.setOnActionExpandListener(new MenuItem.OnActionExpandListener() {
            @Override
            public boolean onMenuItemActionExpand(MenuItem item) {
                return true;
            }

            @Override
            public boolean onMenuItemActionCollapse(MenuItem item) {
                finish();
                return true;
            }
        });


        SearchView searchView = (SearchView) search.getActionView();
        searchView.setImeOptions(EditorInfo.IME_ACTION_DONE);
        searchView.onActionViewExpanded();
        EditText txtSearch = ((EditText) searchView.findViewById(androidx.appcompat.R.id.search_src_text));
        txtSearch.setHint(getResources().getString(R.string.str_lbl_search_here));
        txtSearch.setHintTextColor(getResources().getColor(R.color.black));
        txtSearch.setTextColor(getResources().getColor(R.color.black));
        searchView.setOnQueryTextListener(new SearchView.OnQueryTextListener() {
            @Override
            public boolean onQueryTextSubmit(String query) {
//                Log.d(TAG, "onQueryTextSubmit: "+query);

        /*        if (query.length() > 0)
                    presenter.search(query);
                else
                    AppUtils.setToast(SearchResultActivity.this, getString(R.string.str_lbl_too_short));*/
                return false;
            }

            @Override
            public boolean onQueryTextChange(String newText) {
//                Log.d(TAG, "onQueryTextChange: "+newText);
                return false;
            }
        });
        disposable = RxSearchView.queryTextChanges(searchView).skipInitialValue().debounce(
                1, TimeUnit.SECONDS
        ).observeOn(AndroidSchedulers.mainThread()).subscribe(new Consumer<CharSequence>() {
            @Override
            public void accept(CharSequence charSequence) throws Exception {
                String query = charSequence.toString();
                if (query.length() > 0)
                    presenter.search(query);
                else
                    AppUtils.setToast(SearchResultActivity.this, getString(R.string.str_lbl_too_short));
            }
        }, new Consumer<Throwable>() {
            @Override
            public void accept(Throwable throwable) throws Exception {
                throwable.printStackTrace();
            }
        });
        search.expandActionView();
//        searchView.setOnQueryTextListener(new SearchView.OnQueryTextListener() {
//            @Override
//            public boolean onQueryTextSubmit(String query) {
//                return false;
//            }
//
//            @Override
//            public boolean onQueryTextChange(String newText) {
////                adapter.getFilter().filter(newText);
//                return false;
//            }
//        });

    }

    @Override
    public void setNoDataFound(boolean isActive) {
        if (isActive) {
            binding.grpNoDataFound.setVisibility(View.VISIBLE);
            binding.recsearch.setVisibility(View.GONE);
        } else {
            binding.grpNoDataFound.setVisibility(View.GONE);
            binding.recsearch.setVisibility(View.VISIBLE);
        }
    }

    @Override
    public void setUpView(boolean isReset) {
        if (isReset) {
            adapter = null;
        }
        if (adapter == null) {
            adapter = new SearchAdapter(
                    this,
                    new ArrayList<SearchList>(),
                    new BaseMainAdpter.OnRecyclerviewClick<SearchList>() {
                        @Override
                        public void onClick(SearchList model, View view, int position, ViewType viewType) {

                            Intent i = new Intent(SearchResultActivity.this, ContestantDetailsFragmentActivity.class);
                            i.putExtra("contestantid", model.getContestantId());
                            i.putExtra("contestid", model.getContestId());
                            startActivity(i);
                        }

                        @Override
                        public void onLastItemReached() {
                            presenter.loadMoreData();
                        }
                    }
            );
        }
        binding.recsearch.setLayoutManager(new LinearLayoutManager(this));
        binding.recsearch.setAdapter(adapter);
        binding.recsearch.setVisibility(View.VISIBLE);

    }

    @Override
    public void loadDataToView(ArrayList<SearchList> data) {
        adapter.addItem(data);
    }

    @Override
    public void showBottomProgress() {
        if (adapter != null) {
            adapter.setAddFooter(true);
            adapter.updateBottomProgress(0);
        }
    }

    @Override
    public void hideBottomProgress() {
        if (adapter != null)
            adapter.updateBottomProgress(1);
    }

    @Override
    public void hidePermanentBottomProgress() {
        if (adapter != null) {
            adapter.setAddFooter(false);
            adapter.updateBottomProgress(2);
        }
    }

    @Override
    public void onRetryClicked() {
        super.onRetryClicked();
        presenter.retry();
    }
}