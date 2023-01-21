package src.com.device.ButtonSettings;

import android.content.Context;
import android.database.ContentObserver;
import android.media.AudioManager;
import android.os.Looper;
import android.provider.Settings;
import android.view.KeyEvent;
import android.util.Log;
import android.content.Intent;
import android.accessibilityservice.AccessibilityService;
import android.view.accessibility.AccessibilityEvent;
import android.content.BroadcastReceiver;
import android.content.IntentFilter;

import android.os.Handler;
import android.os.PowerManager;

import android.content.SharedPreferences;

public class MainService extends AccessibilityService {
    private static final String TAG = "MainService";

    protected static final boolean DEBUG = false;

    private boolean buttonsBacklightControl = false;

    private boolean buttonsBacklightControlForced = false;

    private Integer capacitiveButtonsTimeoutInt = 1500;

    // KeyCodes
    private static final int KEYCODE_APP_SELECT = 580;
    private static final int KEYCODE_BACK = 158;
    private static final int KEYCODE_F4 = 62;

    private static final int msDoubleClickThreshold = 250;
    private long msDoubleClick = 0;
    
    private static int clickToShutdown = 0;

    private Context mContext;

    private final SharedPreferences.OnSharedPreferenceChangeListener mPreferenceListener = new SharedPreferences.OnSharedPreferenceChangeListener() {
        @Override
        public void onSharedPreferenceChanged(SharedPreferences prefs, String key) {
            switch (key) {
                case "buttonsBacklightEnabledForced":
                    if (DEBUG)
                        Log.d(TAG, "Settings for Capacitive Buttons Backlight Forced changed");
                    boolean isCapacitiveBacklightForced = prefs.getBoolean("buttonsBacklightEnabledForced", false);
                    if (isCapacitiveBacklightForced) {
                        buttonsBacklightControl = false;
                        buttonsBacklightControlForced = true;
                        Utils.setProp("sys.button_backlight.on", "true");
                    } else {
                        buttonsBacklightControl = prefs.getBoolean("buttonsBacklightEnabled", false);
                        buttonsBacklightControlForced = false;
                        Utils.setProp("sys.button_backlight.on", "false");
                    }
                    break;
                case Utils.capacitiveBacklightTimeoutString:
                    if (DEBUG) Log.d(TAG, "Settings for capacitive buttons timeout changed");
                    capacitiveButtonsTimeoutInt = Integer.parseInt(prefs.getString(Utils.capacitiveBacklightTimeoutString, "1500"));
                    break;
                case "buttonsBacklightEnabled":
                    if (DEBUG) Log.d(TAG, "Settings for Capacitive Buttons Backlight changed");
                    buttonsBacklightControl = prefs.getBoolean("buttonsBacklightEnabled", false);
                    break;
                case "navBarEnabled":
                    if (DEBUG) Log.d(TAG, "Settings for navigation bar changed");
                    Utils.manageNavBar(mContext);
                    break;
            }
        }
    };

    @Override
    public void onDestroy() {
        super.onDestroy();
        mContext.getContentResolver().unregisterContentObserver(mNavigationModeObserver);
        unregisterReceiver(mScreenStateReceiver);
    }

    @Override
    protected void onServiceConnected() {
        super.onServiceConnected();
        if (DEBUG) Log.d(TAG, "service is connected");
        mContext = this;
        AudioManager mAudioManager = mContext.getSystemService(AudioManager.class);

        Context deviceProtectedContext = mContext.createDeviceProtectedStorageContext();
        SharedPreferences pref = deviceProtectedContext.getSharedPreferences(mContext.getPackageName() + "_preferences", MODE_PRIVATE);

        pref.registerOnSharedPreferenceChangeListener(mPreferenceListener);

        // Register here to get the SCREEN_OFF event
        // Used to turn off the capacitive buttons backlight
        IntentFilter screenActionFilter = new IntentFilter();
        screenActionFilter.addAction(Intent.ACTION_SCREEN_OFF);
        screenActionFilter.addAction(Intent.ACTION_SCREEN_ON);
        registerReceiver(mScreenStateReceiver, screenActionFilter);

        // Get capacitive buttons backlight timeout
        capacitiveButtonsTimeoutInt = Integer.parseInt(pref.getString(Utils.capacitiveBacklightTimeoutString, "1500"));

        // Check if the capacitive buttons backlight should be controlled
        boolean isCapacitiveBacklightForced = pref.getBoolean("buttonsBacklightEnabledForced", false);
        if (isCapacitiveBacklightForced) {
            buttonsBacklightControl = false;
            buttonsBacklightControlForced = true;
            Utils.setProp("sys.button_backlight.on", "true");
        } else {
            buttonsBacklightControl = pref.getBoolean("buttonsBacklightEnabled", false);
            buttonsBacklightControlForced = false;
            Utils.setProp("sys.button_backlight.on", "false");
        }

        // Listen for Navigation Mode changes
        mContext.getContentResolver().registerContentObserver(Settings.Secure.getUriFor("navigation_mode"),true, mNavigationModeObserver);

        Utils.manageNavBar(mContext);

    }

    @Override
    public void onAccessibilityEvent(AccessibilityEvent accessibilityEvent) {
    }

    @Override
    public void onInterrupt() {
    }

    private final ContentObserver mNavigationModeObserver = new ContentObserver(new Handler(Looper.getMainLooper())) {
        @Override
        public void onChange(boolean selfChange) {
            super.onChange(selfChange);
            if (DEBUG) Log.d(TAG, "NAVIGATION_MODE changed");
            Utils.manageNavBar(mContext);
        }
    };

    @Override
    protected boolean onKeyEvent(KeyEvent event) {
        return handleKeyEvent(event);
    }

    private final BroadcastReceiver mScreenStateReceiver = new BroadcastReceiver() {
        @Override
        public void onReceive(Context context, Intent intent) {
            Context deviceProtectedContext = mContext.createDeviceProtectedStorageContext();
            SharedPreferences pref = deviceProtectedContext.getSharedPreferences(mContext.getPackageName() + "_preferences", MODE_PRIVATE);
            switch (intent.getAction()) {
                case Intent.ACTION_SCREEN_OFF:
                    if (DEBUG) Log.d(TAG, "Screen OFF");
                    // Set the variable for the slider keys
                    clickToShutdown = 0;
                    if (DEBUG)
                        Log.d(TAG, "Always On Display is: " + Utils.isAlwaysOnDisplayEnabled(mContext));
                    if (Utils.isAlwaysOnDisplayEnabled(mContext))
                        Utils.writeToFile(Utils.dozeWakeupNode, "1", mContext);
                    Utils.setProp("sys.button_backlight.on", "false");
                    break;
                case Intent.ACTION_SCREEN_ON:
                    if (DEBUG) Log.d(TAG, "Screen ON");
                    if (Utils.isAlwaysOnDisplayEnabled(mContext))
                        Utils.writeToFile(Utils.dozeWakeupNode, "0", mContext);
                    if (buttonsBacklightControlForced) Utils.setProp("sys.button_backlight.on", "true");
                    break;
            }
        }
    };

    private boolean handleKeyEvent(KeyEvent event) {
        PowerManager manager = (PowerManager) getSystemService(Context.POWER_SERVICE);
        int scanCode = event.getScanCode();
        if (DEBUG) Log.d(TAG, "key event detected: " + scanCode);
        switch (scanCode) {
            case KEYCODE_BACK:
            case KEYCODE_APP_SELECT:
                if (!buttonsBacklightControl) return false;
                if (event.getAction() == 0) {
                    clickToShutdown += 1;
                    Utils.setProp("sys.button_backlight.on", "true");
                } else {
                    Handler handler = new Handler(Looper.myLooper());
                    handler.postDelayed(() -> {
                        clickToShutdown -= 1;
                        if (clickToShutdown <= 0) {
                            clickToShutdown = 0;
                            Utils.setProp("sys.button_backlight.on", "false");
                        }
                    }, capacitiveButtonsTimeoutInt);
                }
                return false;
            case KEYCODE_F4:
                if (DEBUG) Log.d(TAG, "F4 detected");
                if (Integer.parseInt(Utils.readFromFile(Utils.dozeWakeupNode)) == 0) {
                    if (DEBUG) Log.d(TAG, "F4 ignored (not enabled)");
                    return false;
                } else if (event.getAction() == KeyEvent.ACTION_UP) {
                    if (DEBUG) Log.d(TAG, "F4 UP detected");
                    if (doubleClick()) {
                        PowerManager.WakeLock wakeLock;
                        wakeLock = manager.newWakeLock(PowerManager.FULL_WAKE_LOCK |
                                PowerManager.ACQUIRE_CAUSES_WAKEUP |
                                PowerManager.ON_AFTER_RELEASE, "ButtonSettings: WakeLock");
                        wakeLock.acquire(5 * 1000L /*5 seconds*/);
                        wakeLock.release();
                        return true;
                    }
                }
                return true;
            default:
                return false;
        }
    }

    private boolean doubleClick() {
        boolean result = false;
        long thisTime = System.currentTimeMillis();

        if ((thisTime - msDoubleClick) < msDoubleClickThreshold) {
            if (DEBUG) Log.d(TAG, "doubleClick");
            result = true;
        } else {
            msDoubleClick = thisTime;
        }
        return result;
    }
}
