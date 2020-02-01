package com.example.android.sensorsurvey;

import android.content.Intent;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;

public class ThirdActivity extends AppCompatActivity {

    EditText setDelay,setLength;
    Button saveButton;
    final String TAG = "TEST";


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_third);

        Log.d(TAG, "In On Create 3nd Activity");
        getSupportActionBar().setDisplayHomeAsUpEnabled(true);
        getSupportActionBar().setTitle("Settings Test");
        getSupportActionBar().setSubtitle("Back");


        setDelay=findViewById(R.id.setDelay);
        setLength=findViewById(R.id.setLength);
        saveButton=findViewById(R.id.saveButton);

        saveButton.setOnClickListener(new View.OnClickListener() {




            @Override
            public void onClick(View view)
            {
                String delay = setDelay.getText().toString();
                String length = setLength.getText().toString();


                // Do something
                Intent intent = new Intent(getBaseContext(), MainActivity.class);
                intent.putExtra("set_Delay", delay);
                intent.putExtra("set_Length", length);

                startActivity(intent);
            }
        });

    }


}
