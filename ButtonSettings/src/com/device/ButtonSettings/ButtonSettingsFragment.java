package src.com.device.ButtonSettings;

import android.os.Bundle;

import androidx.preference.Preference;
import androidx.preference.PreferenceManager;
import androidx.preference.Preference.OnPreferenceChangeListener;
import androidx.preference.Preference.OnPreferenceClickListener;
import androidx.preference.PreferenceScreen;
import androidx.preference.PreferenceFragmentCompat;
import androidx.preference.SwitchPreference;

import android.util.Log;

public class ButtonSettingsFragment extends PreferenceFragmentCompat {

    private static String TAG = "ButtonSettingsFragment";

    private static boolean DEBUG = MainService.DEBUG;

    @Override
    public void onCreatePreferences(Bundle savedInstanceState, String rootKey) {
        PreferenceManager currentManager = this.getPreferenceManager();
        currentManager.setStorageDeviceProtected();
        setPreferencesFromResource(R.xml.preferences, rootKey);
    }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        final Preference buttonSwap = getPreferenceScreen().findPreference("buttonSwap");
        buttonSwap.setOnPreferenceChangeListener(new OnPreferenceChangeListener() {
            @Override
            public boolean onPreferenceChange(Preference preference, Object newValue) {
                String key = preference.getKey();
                if (DEBUG) Log.d(TAG, key);
                if ((boolean) newValue) Utils.writeToFile(Utils.keySwapNode, "1", getActivity());
                else Utils.writeToFile(Utils.keySwapNode, "0", getActivity());
                return true;
            }
        });

        final Preference capacitiveButtonBacklightTimeout = getPreferenceScreen().findPreference("capacitive_buttons_timeout");
        capacitiveButtonBacklightTimeout.setOnPreferenceClickListener(new OnPreferenceClickListener() {
            @Override
            public boolean onPreferenceClick(Preference preference){
                if (DEBUG) Log.d(TAG, "Selected capacitive buttons Settings");
                CapacitiveButtonsExtra mCapacitiveButtonsExtra = new CapacitiveButtonsExtra();
                mCapacitiveButtonsExtra.showCapacitiveButtonsOptions(getActivity());
                return true;
            }
        });
    }
}
