package com.etech.starranking.ui.activity.model;

public class CommentsModel {

    String comment;
    String commenterName;
    String commentTime;
    int commenterProfileimg;

    public CommentsModel(int commenterProfileimg, String commenterName, String comment, String commentTime) {
        this.comment = comment;
        this.commenterName = commenterName;
        this.commentTime = commentTime;
        this.commenterProfileimg = commenterProfileimg;
    }

    public String getComment() {
        return comment;
    }

    public void setComment(String comment) {
        this.comment = comment;
    }

    public String getCommenterName() {
        return commenterName;
    }

    public void setCommenterName(String commenterName) {
        this.commenterName = commenterName;
    }

    public String getCommentTime() {
        return commentTime;
    }

    public void setCommentTime(String commentTime) {
        this.commentTime = commentTime;
    }

    public int getCommenterProfileimg() {
        return commenterProfileimg;
    }

    public void setCommenterProfileimg(int commenterProfileimg) {
        this.commenterProfileimg = commenterProfileimg;
    }
}
