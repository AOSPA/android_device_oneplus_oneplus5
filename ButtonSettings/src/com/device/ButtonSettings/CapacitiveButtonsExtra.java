package src.com.device.ButtonSettings;

import android.app.AlertDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.content.SharedPreferences;
import android.text.InputType;
import android.widget.EditText;
import android.widget.Toast;

import static android.content.Context.MODE_PRIVATE;

public class CapacitiveButtonsExtra {

    private static final String TAG = "CapacitiveButtonsExtra";

    private static final boolean DEBUG = MainService.DEBUG;

    private String m_Text = "";

    protected void showCapacitiveButtonsOptions(Context mContext) {
        Context deviceProtectedContext = mContext.createDeviceProtectedStorageContext();
        SharedPreferences pref = deviceProtectedContext.getSharedPreferences(mContext.getPackageName() + "_preferences", MODE_PRIVATE);

        String capacitiveButtonsBacklightTimeoutString = pref.getString(Utils.capacitiveBacklightTimeoutString, "1500");

        AlertDialog.Builder builder = new AlertDialog.Builder(mContext);
        builder.setTitle("Capacitive buttons backlight timeout in ms (>0)");

        // Set up the input
        final EditText input = new EditText(mContext);
        input.setText(capacitiveButtonsBacklightTimeoutString);
        // Specify the type of input expected; this, for example, sets the input as a password, and will mask the text
        input.setInputType(InputType.TYPE_CLASS_TEXT);
        builder.setView(input);

        // Set up the buttons
        builder.setPositiveButton("OK", new DialogInterface.OnClickListener() {
            @Override
            public void onClick(DialogInterface dialog, int which) {
                m_Text = input.getText().toString();
                if (m_Text.matches("-?\\d+") && Integer.valueOf(m_Text) >=0) {
                    SharedPreferences.Editor editor = pref.edit();
                    editor.putString(Utils.capacitiveBacklightTimeoutString, m_Text);
                    editor.commit();
                } else {
                    Toast.makeText(mContext, "Set an integer greater than 0", Toast.LENGTH_LONG).show();
                }
            }
        });
        builder.setNegativeButton("Cancel", new DialogInterface.OnClickListener() {
            @Override
            public void onClick(DialogInterface dialog, int which) {
                dialog.cancel();
            }
        });

        builder.show();
    }
}
