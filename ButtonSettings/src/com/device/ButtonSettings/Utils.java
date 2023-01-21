package src.com.device.ButtonSettings;

import android.app.Service;
import android.content.Context;
import android.content.SharedPreferences;
import android.content.res.Resources;
import android.util.Log;
import android.hardware.display.DisplayManager;
import android.view.Display;

import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.io.File;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.FileNotFoundException;

import android.provider.Settings;
import android.widget.Toast;

import static android.content.Context.MODE_PRIVATE;

public final class Utils {

    private static final String TAG = "ButtonSettingsUtils";

    private static final boolean DEBUG = MainService.DEBUG;

    protected static String keySwapNode = "/proc/s1302/key_rep";

    protected static String dozeWakeupNode = "/proc/touchpanel/tp_f4";

    protected static String doubleTapToWakeNode = "/proc/touchpanel/double_tap_enable";

    protected static String disableCapacitiveKeyNode = "/proc/touchpanel/key_disable";

    protected static String disableHomeKey = "/sys/module/fpc1020_tee/parameters/ignor_home_for_ESD";

    protected static final String capacitiveBacklightTimeoutString = "capacitiveButtonsBacklightTimeout";

    protected static final String CHEESEBURGER_FP_PROXIMITY_FILE =
            "/sys/devices/soc/soc:fpc_fpc1020/proximity_state";

    private static boolean isCapacitiveButtonsUsed = false;

    protected static String readFromFile(String path) {
        String aBuffer = "";
        try {
            File myFile = new File(path);
            FileInputStream fIn = new FileInputStream(myFile);
            BufferedReader myReader = new BufferedReader(new InputStreamReader(fIn));
            String aDataRow = "";
            while ((aDataRow = myReader.readLine()) != null) {
                aBuffer += aDataRow;
            }
            myReader.close();
        } catch (FileNotFoundException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        }
        return aBuffer;
    }

    protected static void writeToFile(String path, String data, Context context) {
        try {
            OutputStreamWriter outputStreamWriter = new OutputStreamWriter(new FileOutputStream(new File(path)));

            //OutputStreamWriter outputStreamWriter = new OutputStreamWriter(context.openFileOutput(path, Context.MODE_PRIVATE));
            outputStreamWriter.write(data);
            outputStreamWriter.close();
        } catch (IOException e) {
            Log.e("Exception", "File write failed: " + e.toString());
        }
    }

    protected static boolean isScreenOn(Context mContext) {
        DisplayManager dm = (DisplayManager) mContext.getSystemService(Context.DISPLAY_SERVICE);
        for (Display display : dm.getDisplays()) {
            if (DEBUG) Log.d(TAG, "Display state: " + display.getState());
            if (display.getState() != Display.STATE_OFF) {
                return true;
            }
        }
        return false;
    }

    protected static void setProp(String property, String value) {
        Process sh = null;
        String[] cmd = {"setprop", property, value};
        try {
            sh = Runtime.getRuntime().exec(cmd);
        } catch (IOException e) {
            e.printStackTrace();
        }
        try {
            sh.waitFor();
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
    }

    protected static String getProp(String property) {
        Process sh = null;
        BufferedReader reader = null;
        String[] cmd = {"getprop", property};
        try {
            sh = Runtime.getRuntime().exec(cmd);
            reader = new BufferedReader(new InputStreamReader(sh.getInputStream()));
        } catch (IOException e) {
            e.printStackTrace();
        }

        try {
            return reader.readLine();
        } catch (IOException e) {
            e.printStackTrace();
        }
        return null;
    }


    protected static boolean isAlwaysOnDisplayEnabled(Context context) {
        return Settings.Secure.getInt(context.getContentResolver(),
                "double_tap_to_wake", 0) != 0;
    }

    protected static void manageNavBar (Context mContext) {
        if (DEBUG) Log.d(TAG, "manageNavBar");
        String currentMainkeysStatus = Utils.getProp("qemu.hw.mainkeys");
        boolean mainKeysEnabled = false;
        if (currentMainkeysStatus.equals("1") || currentMainkeysStatus.isEmpty()) mainKeysEnabled = true;
        if (DEBUG) Log.d(TAG, "mainKeysEnabled: " + mainKeysEnabled);

        Resources resources = mContext.getResources();
        int navBarMode = resources.getIdentifier("config_navBarInteractionMode", "integer", "android");
        if (DEBUG) Log.d(TAG, "navBarMode RAW: " + navBarMode);

        if (navBarMode < 0) {
            return;
        }

        navBarMode = resources.getInteger(navBarMode);
        if (DEBUG) Log.d(TAG, "navBarMode: " + navBarMode);

        Context deviceProtectedContext = mContext.createDeviceProtectedStorageContext();
        SharedPreferences pref = deviceProtectedContext.getSharedPreferences(mContext.getPackageName() + "_preferences", MODE_PRIVATE);

        boolean navBarEnabled = pref.getBoolean("navBarEnabled", false);
        if (DEBUG) Log.d(TAG, "navBarEnabled: " + navBarEnabled);

        if (navBarMode == 0){
            // Navigation is displaying with 3 buttons
            // Do we want nav bar on screen?
            if (navBarEnabled) {
                // check if qemu.hw.mainkeys is correct
                // qemu.hw.mainkeys needs to be 0 to have navigation bar visible
                Utils.setProp("persist.qemu.hw.mainkeys", "0");
                if (mainKeysEnabled) {
                    Toast.makeText(mContext, "A reboot is required to apply the new settings", Toast.LENGTH_LONG).show();
                } else {
                    isCapacitiveButtonsUsed = false;
                    Utils.manageCapacitiveButtons(mContext);
                }
            } else {
                // qemu.hw.mainkeys needs to be 1 to use capacitive buttons (no nav bar on screen)
                Utils.setProp("persist.qemu.hw.mainkeys", "1");
                if(!mainKeysEnabled) {
                    Toast.makeText(mContext, "A reboot is required to apply the new settings", Toast.LENGTH_LONG).show();
                } else {
                    isCapacitiveButtonsUsed = true;
                    Utils.manageCapacitiveButtons(mContext);
                }
            }
        }
        else if (navBarMode == 1){
            // Navigation is displaying with 2 button(Android P navigation mode)
            // not supported
            return;
        }
        else if (navBarMode == 2){
            // Full screen gesture(Gesture on android Q)
            // qemu.hw.mainkeys needs to be 0
            Utils.setProp("persist.qemu.hw.mainkeys", "0");
            if (mainKeysEnabled) {
                Toast.makeText(mContext, "A reboot is required to apply the new settings", Toast.LENGTH_LONG).show();
            } else {
                isCapacitiveButtonsUsed = false;
                Utils.manageCapacitiveButtons(mContext);
            }
        }
    }

    protected static void manageCapacitiveButtons (Context mContext) {
        boolean enabled = isCapacitiveButtonsUsed;
        if (enabled) {
            if (DEBUG) Log.d(TAG, "Enabling capacitive buttons");
            // Enable capacitive keys
            Utils.writeToFile(Utils.disableCapacitiveKeyNode, "0", mContext);
            // Enable fingerprint sensor home button
            Utils.writeToFile(Utils.disableHomeKey, "0", mContext);
        } else {
            if (DEBUG) Log.d(TAG, "Disabling capacitive buttons");
            // Disable capacitive keys
            Utils.writeToFile(Utils.disableCapacitiveKeyNode, "1", mContext);
            // Disable fingerprint sensor home button
            Utils.writeToFile(Utils.disableHomeKey, "1", mContext);
        }
    }
}
