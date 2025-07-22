package com.etech.starranking.ui.activity.ui.dashboard.home;

import android.app.Activity;
import android.app.Dialog;
import android.content.Context;
import android.content.Intent;
import android.graphics.Color;
import android.graphics.drawable.ColorDrawable;
import android.os.Bundle;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Toast;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.appcompat.widget.AppCompatButton;
import androidx.appcompat.widget.AppCompatEditText;
import androidx.appcompat.widget.AppCompatTextView;
import androidx.databinding.DataBindingUtil;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.swiperefreshlayout.widget.SwipeRefreshLayout;

import com.etech.starranking.R;
import com.etech.starranking.app.StarRankingApp;
import com.etech.starranking.base.BaseFragment;
import com.etech.starranking.base.BaseMainAdpter;
import com.etech.starranking.data.prefs.AppPreferencesHelper;
import com.etech.starranking.databinding.ActivityContestantDashboardBinding;
import com.etech.starranking.ui.activity.SampleWebViewActivity;
import com.etech.starranking.ui.activity.model.CategoryList;
import com.etech.starranking.ui.activity.model.ContestDetails;
import com.etech.starranking.ui.activity.model.ContestantList;
import com.etech.starranking.ui.activity.model.LoginProfile;
import com.etech.starranking.ui.activity.model.StarDetails;
import com.etech.starranking.ui.activity.ui.contestantList.ListContract;
import com.etech.starranking.ui.activity.ui.contestantList.ListPresenter;
import com.etech.starranking.ui.adapter.ContestantCategoryListAdapter;
import com.etech.starranking.ui.adapter.ContestantListAdapter;
import com.etech.starranking.utils.AppUtils;
import com.etech.starranking.utils.Constants;
import com.etech.starranking.utils.CustomAlertDialog;

import java.util.ArrayList;
import java.util.Date;


public class ContestDetailFragment extends BaseFragment implements ListContract.View {
    private static int CONTESTANT_DETAILS_CODE = 124;
    //2nd scr
    ContestantListAdapter adapter;
    ContestantCategoryListAdapter catAdapter;
    ListContract.Presenter<ListContract.View> presenter;
    ActivityContestantDashboardBinding binding;
    String contestId = "";
    String webviewurl = "";
    String homepg = "";
    LoginProfile user;
    String voteOpenDate,voteCloseDate;
    Date voteStartDate,voteEndDate;
    public ContestDetailFragment() {

    }


    public static ContestDetailFragment newInstance(Bundle bundle) {
        ContestDetailFragment fragment = new ContestDetailFragment();
        if (bundle != null)
            fragment.setArguments(bundle);
        return fragment;
    }

    public View onCreateView(@NonNull LayoutInflater inflater,
                             ViewGroup container, Bundle savedInstanceState) {

        contestId = getArguments().getString("contest_id", "");
        voteOpenDate= getArguments().getString("vote_open_date","");
        voteCloseDate = getArguments().getString("vote_close_date","");
        voteEndDate = AppUtils.getVoteStartAndCloseDate(voteCloseDate);
        voteStartDate = AppUtils.getVoteStartAndCloseDate(voteOpenDate);

        Log.e("contest_id", contestId);
        binding = DataBindingUtil.inflate(inflater, R.layout.activity_contestant_dashboard, container, false);
        presenter = new ListPresenter<>();
        presenter.onAttach(this);
        presenter.initView(contestId);
        initUi();
        return binding.getRoot();
    }

    private void initUi() {
        binding.swipeRefreshLayout.setOnRefreshListener(new SwipeRefreshLayout.OnRefreshListener() {
            @Override
            public void onRefresh() {
                binding.swipeRefreshLayout.setRefreshing(true);
                presenter.resetData();
            }
        });
        binding.rvContestnatList.setSwipeRefreshLayout(binding.swipeRefreshLayout);
//        binding.rvContestnatList.setNestedScrollingEnabled(false);
        binding.rvCategories.setLayoutManager(new LinearLayoutManager(getContext(), LinearLayoutManager.HORIZONTAL, false));
        binding.ivBannerContest.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Intent i = new Intent(getContext(), SampleWebViewActivity.class);
                i.putExtra("from", "Contestbanner");
                i.putExtra("bannerWebview", webviewurl);
                i.putExtra("homepgview", homepg);
                startActivity(i);

            }
        });
        user = StarRankingApp.getDataManager().getUserFromPref();
    }

    @Override
    public void hideLoader() {
        super.hideLoader();
        if (binding != null)
            binding.swipeRefreshLayout.setRefreshing(false);
    }

    @Override
    public void onDestroyView() {
        presenter.onDetach();
        super.onDestroyView();
    }

    private ArrayList<ContestantList> homes, homes1;
    ContestDetails currentContest;

    @Override
    public void loadData(ArrayList<ContestantList> homes, ArrayList<ContestDetails> homes1) {
        this.homes = homes;
        currentContest = homes1.get(0);
        adapter.addData(homes);
        AppUtils.setImageUrl(getContext(), homes1.get(0).getSub_banner(), binding.ivBannerContest, true, R.drawable.home_samll_holder);
        webviewurl = homes1.get(0).getWeb_view_url();
        homepg = homes1.get(0).getHome_page();

    }

    @Override
    public void loadCat(ArrayList<CategoryList> cats) {
        catAdapter.addData(cats);
        if (cats.size() > 0) {
            toogleModel(cats.get(0));
        }
    }


    @Override
    public void successfulltVoted(ContestantList contestantList, String vote, StarDetails response) {
//        AppUtils.setToast(getContext(), "Your vote added");
//        if (adapter != null)
//            adapter.notifyDataSetChanged();
        StarRankingApp.getDataManager().set(AppPreferencesHelper.PREF_USER_STARS, response.getRemaining_star());
//        CustomAlertDialog.showAlert(this.getContext(),vote+" "+getString(R.string.str_star_sent_to)+" "+contestantList.getConetstantname());
        CustomAlertDialog.showVoteSuccessPopUp(getContext(), vote, contestantList.getConetstantname());
        presenter.resetData();

    }


//    public void addDetails(ArrayList<ContestDetails> list) {
//        arrayList.clear();
//        arrayList.addAll(list);
//
//    }
//
//    @Override
//    public void loadContestData(ArrayList<ContestDetails> homes) {
//        arrayList.add(homes);
//    }

    //    @Override
//    public void loadData(ArrayList<ContestDetailAndContestantListModel> homes) {
//        adapter.addData(homes);
//    }
    CategoryList previouslySelectedCat;

    @Override
    public void setupView(boolean isreset) {
        if (isreset) {
            adapter = null;
            catAdapter = null;

        }
        if (adapter == null) {
            adapter = new ContestantListAdapter(getContext(),
                    new BaseMainAdpter.OnRecyclerviewClick<ContestantList>() {
                        @Override
                        public void onClick(ContestantList model, View view, int position, ViewType viewType) {
                            if (viewType == viewType.View) {
                                Intent i = new Intent(getContext(), ContestantDetailsFragmentActivity.class);
                                i.putExtra("contestantid", model.getContestant_id());
                                i.putExtra("contestid", model.getContestid());
                                i.putExtra("contestUserid", model.getContestid());
                                i.putExtra("vote_open_date",voteOpenDate);
                                i.putExtra("vote_close_date",voteCloseDate);


                                startActivityForResult(i, CONTESTANT_DETAILS_CODE);
//                                FragmentManager manager = getFragmentManager();
//                                FragmentTransaction transaction = manager.beginTransaction();
//                                transaction.replace(R.id.llframemain, new ContestantDetailsModel()).addToBackStack(null);
//                                transaction.commit();
                            } else if (viewType == viewType.Button) {

                                if (!user.getUser_id().equals("")) {
                                    /*if (Constants.CONTEST_STATUS_OPEN.equals(currentContest.getStatus())) {
                                        showdialog(getActivity(), model, R.layout.popup_layout_vote);
                                    } else {
                                        showError(Constants.FAIL_CODE, getString(R.string.str_msg_voting_period));
                                    }*/
                                    Date d = new Date();
                                    if(d.after(voteStartDate) && d.before(voteEndDate)){
                                        showdialog(getActivity(), model, R.layout.popup_layout_vote);
                                    }
                                    else{
                                        showError(Constants.FAIL_CODE, getString(R.string.str_msg_voting_period));
                                    }
                                } else {
                                    AppUtils.loginPopup(getContext());
                                }

                            }
                        }

                        @Override
                        public void onLastItemReached() {

                        }
                    });
            binding.rvContestnatList.setAdapter(adapter);
        } else {
            binding.rvContestnatList.setAdapter(adapter);
        }
        if (catAdapter == null) {
            catAdapter = new ContestantCategoryListAdapter(getContext(),
                    new BaseMainAdpter.OnRecyclerviewClick<CategoryList>() {
                        @Override
                        public void onClick(CategoryList model, View view, int position, ViewType viewType) {
                            if (viewType == ViewType.View) {
                                toogleModel(model);
                                // view.setBackgroundColor(model.isSelected() ? Color.parseColor("#F04689") : Color.WHITE);
                            }
                        }

                        @Override
                        public void onLastItemReached() {

                        }
                    });
            binding.rvCategories.setAdapter(catAdapter);
        } else {
            binding.rvCategories.setAdapter(catAdapter);
        }
    }

    private void toogleModel(CategoryList model) {
        model.setSelected(!model.isSelected());

        if (model.isSelected()) {
            if (previouslySelectedCat != null)
                previouslySelectedCat.setSelected(false);
            previouslySelectedCat = model;

        } else {
            previouslySelectedCat = null;
        }

        catAdapter.notifyDataSetChanged();
        setFilter();
    }

    private void setFilter() {
        if (previouslySelectedCat == null) {
            adapter.addData(homes);
        } else {
            ArrayList<ContestantList> filteredList = new ArrayList<>();
            for (ContestantList contestant : homes) {
                if (contestant.getCategoryId().equals(previouslySelectedCat.getId())) {
                    filteredList.add(contestant);
                }

            }
            adapter.addData(filteredList);
        }

    }

    @Override
    public void setNoRecordsAvailable(boolean noRecords) {
//        binding.rvCategories.setVisibility(View.GONE);
        if (noRecords) {
            binding.noDataFound.getRoot().setVisibility(View.VISIBLE);
        } else {
            binding.noDataFound.getRoot().setVisibility(View.GONE);
        }
    }

    //    public void showdialog(Activity context, String contestantid, int layoput) {
//        final Dialog dialog = new Dialog(context);
//
//        dialog.setContentView(layoput);
//        dialog.getWindow().setLayout(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.WRAP_CONTENT);
//        dialog.getWindow().setBackgroundDrawable(new ColorDrawable(Color.TRANSPARENT));
//
//        AppCompatTextView btn = (AppCompatTextView) dialog.findViewById(R.id.btnUseAll);
//        AppCompatButton btnConfirm = (AppCompatButton) dialog.findViewById(R.id.btnConfirm);
//
//        AppCompatTextView votebar = (AppCompatTextView) dialog.findViewById(R.id.votebar);
//        final AppCompatEditText editText = (AppCompatEditText) dialog.findViewById(R.id.etvote);
//        final AppCompatTextView tvpopupStarsAmt = (AppCompatTextView) dialog.findViewById(R.id.tvpopupStarsAmt);
//        LoginProfile user = AppPreferencesHelper.getUserFromPref();
//
//        tvpopupStarsAmt.setText(user.getRemaining_star());
//        btn.setOnClickListener(new View.OnClickListener() {
//            @Override
//            public void onClick(View v) {
//                editText.setText(user.getRemaining_star());
//            }
//        });
//
//
//        votebar.setOnClickListener(new View.OnClickListener() {
//            @Override
//            public void onClick(View v) {
//                dialog.dismiss();
//            }
//        });
//
//        btnConfirm.setOnClickListener(new View.OnClickListener() {
//            @Override
//            public void onClick(View v) {
//                int total = Integer.parseInt(user.getRemaining_star().toString());
//                int wantToVote = Integer.parseInt(editText.getText().toString());
//                if (wantToVote > total) {
//                    AppUtils.setToast(getContext(), "You dont have enough stars");
//                    Intent i = new Intent(getContext(), StarChargingWebview.class);
//                    startActivity(i);
//                } else {
//                    //AppUtils.setToast(getContext(), "done");
//                    dialog.dismiss();
//                    presenter.addvotecall("english", contestId, contestantid, user.getUser_id(), editText.getText().toString(), user.getName());
//                    //api call
//                }
//            }
//        });
//        dialog.show();
//    }

    public void showdialog(Context context, ContestantList contestant, int layoput) {
        final Dialog dialog = new Dialog(context);

        dialog.setContentView(layoput);
        dialog.getWindow().setLayout(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.WRAP_CONTENT);
        dialog.getWindow().setBackgroundDrawable(new ColorDrawable(Color.TRANSPARENT));

        final AppCompatTextView votebar = (AppCompatTextView) dialog.findViewById(R.id.votebar);
        final AppCompatTextView tvpopupStarsAmt = (AppCompatTextView) dialog.findViewById(R.id.tvpopupStarsAmt);
        final AppCompatEditText editText = (AppCompatEditText) dialog.findViewById(R.id.etvote);
        final AppCompatTextView btn = (AppCompatTextView) dialog.findViewById(R.id.btnUseAll);
        final AppCompatButton btnConfirm = (AppCompatButton) dialog.findViewById(R.id.btnConfirm);


        LoginProfile user = StarRankingApp.getDataManager().getUserFromPref();

        tvpopupStarsAmt.setText(AppUtils.getFormatedString(user.getRemaining_star()));
        btn.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                editText.setText(user.getRemaining_star());
            }
        });

        votebar.setText(String.format(getString(R.string.str_lbl_vote_popup_title), contestant.getConetstantname()));
        votebar.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                dialog.dismiss();
            }
        });

        btnConfirm.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
//                int total = Integer.parseInt(user.getRemaining_star().toString());
//                int wantToVote = Integer.parseInt(editText.getText().toString());
//                if (editText.getText().toString().equals("")) {
//                    AppUtils.setToast(getContext(), "Enter votes");
//                }
//                if (wantToVote > total) {
//                    AppUtils.setToast(getContext(), "You dont have enough stars");
//                    Intent i = new Intent(getContext(), StarChargingWebview.class);
//                    startActivity(i);
//                } else {
                if (isValidData()) {
                    presenter.addvotecall(AppUtils.LANGUAGE_DEFAULT_VALUE, contestant, contestId, contestant.getContestant_id(), user.getUser_id(), editText.getText().toString(), user.getName());
                    dialog.dismiss();
                }
//                    //api call
//                }
            }

            boolean isValidData() {
                if (editText.getText()==null||editText.getText().toString().isEmpty()) {
                    AppUtils.setToast(requireContext(), getString(R.string.str_msg_enter_star));
                    return false;
                } else if (Integer.parseInt(editText.getText().toString()) == 0) {
                    AppUtils.setToast(requireContext(), getString(R.string.str_msg_star_can_not_0));
                    return false;
                }
                return true;
            }
        });
        dialog.show();
    }

    @Override
    public void onActivityResult(int requestCode, int resultCode, @Nullable Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (requestCode == CONTESTANT_DETAILS_CODE && resultCode == Activity.RESULT_OK) {
            presenter.resetData();
        }
    }

    @Override
    public void onRetryClicked() {
        super.onRetryClicked();
        presenter.retry();
    }
}