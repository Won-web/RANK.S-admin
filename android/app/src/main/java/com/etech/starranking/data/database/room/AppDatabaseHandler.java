package com.etech.starranking.data.database.room;

import android.content.Context;

import androidx.room.Database;
import androidx.room.Room;
import androidx.room.RoomDatabase;

import com.etech.starranking.data.database.room.dao.LoginDao;
import com.etech.starranking.data.database.room.table.LoginTable;

@Database(entities = {LoginTable.class}, version = 1, exportSchema = false)
public abstract class AppDatabaseHandler extends RoomDatabase {

    public abstract LoginDao loginDao();

    private static volatile AppDatabaseHandler INSTANCE;

    public static AppDatabaseHandler getDatabase(final Context context) {

        if (INSTANCE == null) {
            synchronized (AppDatabaseHandler.class) {
                if (INSTANCE == null) {
                    INSTANCE = Room.databaseBuilder(context,
                            AppDatabaseHandler.class,
                            "MVP_DATABASE")
                            .fallbackToDestructiveMigration()
                            .allowMainThreadQueries()
                            .build();

                }
            }
        }
        return INSTANCE;
    }


}
