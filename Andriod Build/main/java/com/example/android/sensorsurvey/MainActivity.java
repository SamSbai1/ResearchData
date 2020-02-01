/*
 * Copyright (C) 2017 Google Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package com.example.android.sensorsurvey;

import android.app.Notification;
import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.content.Context;
import android.content.Intent;
import android.hardware.Sensor;
import android.hardware.SensorEvent;
import android.hardware.SensorEventListener;
import android.hardware.SensorManager;
import android.os.Build;
import android.os.Bundle;
import android.os.Handler;
import android.support.annotation.RequiresApi;
import android.support.v4.app.NotificationCompat;
import android.support.v7.app.AppCompatActivity;
import android.util.Log;
import android.view.View;
import android.widget.CompoundButton;
import android.widget.Switch;
import android.widget.TextView;

import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.Timer;
import java.util.TimerTask;

import static java.lang.Integer.decode;

/**
 * SensorSurvey queries the sensor manager for a list of available
 * sensors, and displays the list in a TextView.
 */
public class MainActivity extends AppCompatActivity implements SensorEventListener {

    // Holds an instance of the SensorManager system service.
    private SensorManager mSensorManager;
    final String TAG = "TEST";
    boolean isRunning;
    FileWriter writer;

    private NotificationManager mNotificationManager;
    private static String DEFAULT_CHANNEL_ID = "default_channel";
    private static String DEFAULT_CHANNEL_NAME = "Default";

    String delay,length;



    @RequiresApi(api = Build.VERSION_CODES.O)
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);



        //------------------Info From Intents----------------------
        Intent intentInfo = getIntent();
        delay = intentInfo.getStringExtra("set_Delay");
        length = intentInfo.getStringExtra("set_Length");

        if(delay == null){
            delay = "1";
            length = "1";
        }

        Log.d(TAG, "Set Delay " + delay);
        Log.d(TAG, "Set Length " + length);






        //-------------------Notifications-------------------------
        mNotificationManager = (NotificationManager) getSystemService(NOTIFICATION_SERVICE);

        //Create the intent to do a certain task (Here it is opening an activity)
        Intent intent = new Intent(getBaseContext(), MainActivity.class);

        PendingIntent pendingIntent = PendingIntent.getActivity(getBaseContext(), 0, intent, PendingIntent.FLAG_UPDATE_CURRENT);

        //2.Build Notification with NotificationCompat.Builder
        final Notification notification = new NotificationCompat.Builder(this, DEFAULT_CHANNEL_ID)
                .setContentTitle("Active Learning Query")   //Set the title of Notification
                .setContentText("What activity are you curently preforming?")    //Set the text for notification
                .setSmallIcon(android.R.drawable.ic_menu_view)   //Set the icon
                .setAutoCancel(true)    //Close notification after click
                .setContentIntent(pendingIntent)
                .build();

        //Send the notification.
        mNotificationManager.notify(1, notification);

        //---------------------------------------------------------

        final Handler handler = new Handler();
        Timer timer = new Timer();
        TimerTask doAsynchronousTask = new TimerTask() {
            @Override
            public void run() {
                Log.d(TAG, "In Asynctask");
                handler.post(new Runnable() {
                    @SuppressWarnings("unchecked")
                    public void run() {
                        try {
                            Log.d(TAG, "Send Notification");
                            mNotificationManager.notify(1, notification);
                        }
                        catch (Exception e) {
                            // TODO Auto-generated catch block
                        }
                    }
                });
            }
        };
        timer.schedule(doAsynchronousTask, 0, decode(delay)*60000);

        //---------------------------------------------------------

        isRunning = false;

        // Get the sensor service and retrieve the list of sensors.
        mSensorManager = (SensorManager) getSystemService(Context.SENSOR_SERVICE);
        //manager = (SensorManager) getSystemService(Context.SENSOR_SERVICE);
        List<Sensor> sensorList = mSensorManager.getSensorList(Sensor.TYPE_ALL);

        //sensorManager=(SensorManager) getSystemService(SENSOR_SERVICE);
        //sensorManager.registerListener(this, sensorManager.getDefaultSensor(Sensor.TYPE_ACCELEROMETER), SensorManager.SENSOR_DELAY_NORMAL);
        mSensorManager.registerListener((SensorEventListener) this, mSensorManager.getDefaultSensor(Sensor.TYPE_ACCELEROMETER), 0);
        mSensorManager.registerListener((SensorEventListener) MainActivity.this, mSensorManager.getDefaultSensor(Sensor.TYPE_GYROSCOPE), 0);
        mSensorManager.registerListener((SensorEventListener) MainActivity.this, mSensorManager.getDefaultSensor(Sensor.TYPE_GYROSCOPE_UNCALIBRATED), 0);
        mSensorManager.registerListener((SensorEventListener) MainActivity.this, mSensorManager.getDefaultSensor(Sensor.TYPE_MAGNETIC_FIELD), 0);
        mSensorManager.registerListener((SensorEventListener) MainActivity.this, mSensorManager.getDefaultSensor(Sensor.TYPE_MAGNETIC_FIELD_UNCALIBRATED), 0);
        mSensorManager.registerListener((SensorEventListener) MainActivity.this, mSensorManager.getDefaultSensor(Sensor.TYPE_ROTATION_VECTOR), 0);
        mSensorManager.registerListener((SensorEventListener) MainActivity.this, mSensorManager.getDefaultSensor(Sensor.TYPE_GAME_ROTATION_VECTOR), 0);


        // Iterate through the list of sensors, get the sensor name,
        // append it to the string.
        StringBuilder sensorText = new StringBuilder();
        //String sensorText = "";
        for (Sensor currentSensor : sensorList) {
            sensorText.append(currentSensor.getName()).append(
                    System.getProperty("line.separator"));
        }

        // Update the sensor list text view to display the list of sensors.
        TextView sensorTextView = (TextView) findViewById(R.id.sensor_list);
        sensorTextView.setText(sensorText);


        Switch sw = (Switch) findViewById(R.id.switch2);
        sw.setOnCheckedChangeListener(new CompoundButton.OnCheckedChangeListener() {
            public void onCheckedChanged(CompoundButton buttonView, boolean isChecked) {
                if (isChecked) {
                    // The toggle is enabled
                    Log.d(TAG, "Writing to " + getStorageDir());
                    SimpleDateFormat simpleDateFormat = new SimpleDateFormat("dd-MM-yyyy-hh-mm-ss");
                    String format = simpleDateFormat.format(new Date());
                    try {
                        writer = new FileWriter(new File(getStorageDir(), "sensors_" + format + ".csv"));
                        writeCsvHeader("TimeStamp ", "Sensor ", "Value 1", "Value 2", "Value 3", "Value 4", "Value 5", "Value 6");
                    } catch (IOException e) {
                        e.printStackTrace();
                    }
                    isRunning = true;

                } else {
                    // The toggle is disabled
                    isRunning = false;
                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.KITKAT) {
                        mSensorManager.flush(MainActivity.this);
                    }
                    mSensorManager.unregisterListener(MainActivity.this);
                    try {
                        writer.close();
                    } catch (IOException e) {
                        e.printStackTrace();
                    }

                }
            }
        });


    }

    private String getStorageDir() {
        return this.getExternalFilesDir(null).getAbsolutePath();
        //  return "/storage/emulated/0/Android/data/com.iam360.sensorlog/";
    }

    public void onFlushCompleted(Sensor sensor) {

    }

    public void onSensorChanged(SensorEvent evt) {
        if (isRunning) {
            try {
                switch (evt.sensor.getType()) {
                    case Sensor.TYPE_ACCELEROMETER:
                        writer.write(String.format("%d, TYPE_ACCELEROMETER, %f, %f, %f, %f, %f, %f\n", evt.timestamp, evt.values[0], evt.values[1], evt.values[2], 0.f, 0.f, 0.f));
                        break;
                    case Sensor.TYPE_GYROSCOPE_UNCALIBRATED:
                        writer.write(String.format("%d, TYPE_GYROSCOPE_UNCALIBRATED, %f, %f, %f, %f, %f, %f\n", evt.timestamp, evt.values[0], evt.values[1], evt.values[2], evt.values[3], evt.values[4], evt.values[5]));
                        break;
                    case Sensor.TYPE_GYROSCOPE:
                        writer.write(String.format("%d, TYPE_GYROSCOPE, %f, %f, %f, %f, %f, %f\n", evt.timestamp, evt.values[0], evt.values[1], evt.values[2], 0.f, 0.f, 0.f));
                        break;
                    case Sensor.TYPE_MAGNETIC_FIELD:
                        writer.write(String.format("%d, TYPE_MAGNETIC_FIELD, %f, %f, %f, %f, %f, %f\n", evt.timestamp, evt.values[0], evt.values[1], evt.values[2], 0.f, 0.f, 0.f));
                        break;
                    case Sensor.TYPE_MAGNETIC_FIELD_UNCALIBRATED:
                        writer.write(String.format("%d, TYPE_MAGNETIC_FIELD_UNCALIBRATED, %f, %f, %f, %f, %f, %f\n", evt.timestamp, evt.values[0], evt.values[1], evt.values[2], 0.f, 0.f, 0.f));
                        break;
                    case Sensor.TYPE_ROTATION_VECTOR:
                        writer.write(String.format("%d, TYPE_ROTATION_VECTOR, %f, %f, %f, %f, %f, %f\n", evt.timestamp, evt.values[0], evt.values[1], evt.values[2], evt.values[3], 0.f, 0.f));
                        break;
                    case Sensor.TYPE_GAME_ROTATION_VECTOR:
                        writer.write(String.format("%d, TYPE_GAME_ROTATION_VECTOR, %f, %f, %f, %f, %f, %f\n", evt.timestamp, evt.values[0], evt.values[1], evt.values[2], evt.values[3], 0.f, 0.f));
                        break;
                }
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
    }

    public void onAccuracyChanged(Sensor sensor, int i) {

    }

    public void onButtonClick(View v) {
        Log.d(TAG, "In Click");
        Intent myIntent = new Intent(getBaseContext(), SecondActivity.class);
        Log.d(TAG, "Starting Activity");
        startActivity(myIntent);
    }

    public void onSettingsClick(View v) {
        Intent myIntent = new Intent(getBaseContext(), ThirdActivity.class);
        startActivity(myIntent);
    }

    @Override
    public void onPointerCaptureChanged(boolean hasCapture) {

    }

    private void writeCsvHeader(String h1, String h2, String h3, String h4, String h5, String h6, String h7, String h8) throws IOException {
        String line = String.format("%s,%s,%s,%s,%s,%s,%s,%s\n", h1, h2, h3, h4, h5, h6, h7, h8);
        writer.write(line);
    }


    /*
     * Create NotificationChannel as required from Android 8.0 (Oreo)
     * */
    public static void createNotificationChannel(NotificationManager notificationManager) {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            //Create channel only if it is not already created
            if (notificationManager.getNotificationChannel(DEFAULT_CHANNEL_ID) == null) {
                notificationManager.createNotificationChannel(new NotificationChannel(
                        DEFAULT_CHANNEL_ID, DEFAULT_CHANNEL_NAME, NotificationManager.IMPORTANCE_DEFAULT
                ));
            }
        }
    }




}
