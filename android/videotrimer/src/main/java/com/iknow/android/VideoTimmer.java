package com.iknow.android;


import android.app.Application;
import android.content.Context;
import android.util.Log;

import com.arthenica.mobileffmpeg.FFmpeg;

import iknow.android.utils.BaseUtils;
//import nl.bravobit.ffmpeg.FFmpeg;

/**
 * Author：J.Chou
 * Date：  2016.09.27 10:44 AM
 * Email： who_know_me@163.com
 * Describe:
 */
public class VideoTimmer {

  public static void init(Context context){
    BaseUtils.init(context);
    initFFmpegBinary(context);
  }
  private static void initFFmpegBinary(Context context) {
   /* FFmpeg.
    if (!FFmpeg.getInstance(context).isSupported()) {
      Log.e("ZApplication","Android cup arch not supported!");
    }*/
  }
}
