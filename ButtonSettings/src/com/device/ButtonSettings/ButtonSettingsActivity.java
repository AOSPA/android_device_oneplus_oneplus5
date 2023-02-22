package src.com.device.ButtonSettings;

import android.os.Bundle;

import androidx.appcompat.app.AppCompatActivity;

public class ButtonSettingsActivity extends AppCompatActivity {

    private static String TAG = "ButtonsExtraActivity";

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.main_settings);
        getSupportFragmentManager()
                .beginTransaction()
                .replace(R.id.main_setting, new ButtonSettingsFragment())
                .commit();
    }

}
