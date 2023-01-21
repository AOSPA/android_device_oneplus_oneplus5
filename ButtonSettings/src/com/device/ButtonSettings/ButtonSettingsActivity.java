package src.com.device.ButtonSettings;

import android.os.Bundle;

import com.android.settingslib.collapsingtoolbar.CollapsingToolbarBaseActivity;
import com.android.settingslib.widget.R;

public class ButtonSettingsActivity extends CollapsingToolbarBaseActivity {

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
