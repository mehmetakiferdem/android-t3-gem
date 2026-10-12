/*
 * SPDX-License-Identifier: Apache-2.0
 *
 * The board carries an LPS22DF (pressure, temperature), an HDC2010 (humidity,
 * temperature) and an ICM-20948 (IMU). Android cannot see any of them through
 * SensorManager, because this port has no sensors HAL: the VINTF manifest
 * declares only the camera provider. Rather than stub a HAL, this reads the
 * IIO sysfs nodes the kernel drivers expose and shows whatever is there, which
 * is enough to tell whether a sensor is alive and what it reports.
 *
 * The ICM-20948 has no driver in this kernel, so it will not appear until one
 * is written or ported; it stays bound to spidev.
 */
package com.t3gemstone.sensors;

import android.app.Activity;
import android.graphics.Color;
import android.graphics.Typeface;
import android.os.Bundle;
import android.os.Handler;
import android.os.Looper;
import android.util.TypedValue;
import android.view.Gravity;
import android.view.ViewGroup;
import android.widget.LinearLayout;
import android.widget.TextView;

import java.io.File;
import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Locale;

public class SensorsActivity extends Activity {

    private static final String IIO_ROOT = "/sys/bus/iio/devices";
    private static final long REFRESH_MS = 1000;

    private static final class Reading {
        final String channel;
        final String value;

        Reading(String channel, String value) {
            this.channel = channel;
            this.value = value;
        }
    }

    private final Handler mHandler = new Handler(Looper.getMainLooper());
    private LinearLayout mList;

    private final Runnable mTick = new Runnable() {
        @Override
        public void run() {
            refresh();
            mHandler.postDelayed(this, REFRESH_MS);
        }
    };

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.main);
        mList = findViewById(R.id.list);
    }

    @Override
    protected void onResume() {
        super.onResume();
        mHandler.post(mTick);
    }

    @Override
    protected void onPause() {
        super.onPause();
        mHandler.removeCallbacks(mTick);
    }

    private void refresh() {
        mList.removeAllViews();

        File root = new File(IIO_ROOT);
        File[] devices = root.listFiles();
        if (devices == null) {
            // An unreadable directory and a missing one look the same from
            // here, so say which is which: either the drivers are not loaded
            // or sepolicy is in the way.
            addMessage(root.exists() ? R.string.denied : R.string.no_devices);
            return;
        }

        Arrays.sort(devices);
        boolean any = false;
        for (File dev : devices) {
            if (!dev.getName().startsWith("iio:device")) {
                continue;
            }
            any = true;
            addDevice(dev);
        }
        if (!any) {
            addMessage(R.string.no_devices);
        }
    }

    private void addDevice(File dev) {
        String name = read(new File(dev, "name"));
        addHeading((name != null ? name : getString(R.string.unknown_sensor))
                + "  (" + dev.getName() + ")");

        List<Reading> rows = new ArrayList<>();
        File[] files = dev.listFiles();
        if (files != null) {
            Arrays.sort(files);
            for (File f : files) {
                String n = f.getName();
                if (!n.startsWith("in_")) {
                    continue;
                }
                if (n.endsWith("_input")) {
                    String raw = read(f);
                    if (raw != null) {
                        rows.add(new Reading(n, withUnit(n, raw)));
                    }
                } else if (n.endsWith("_raw")) {
                    // Parts that expose raw counts plus a scale rather than a
                    // ready _input value: apply the scale so the number means
                    // something.
                    String raw = read(f);
                    if (raw == null) {
                        continue;
                    }
                    String base = n.substring(0, n.length() - 3);
                    String scale = read(new File(dev, base + "scale"));
                    String offset = read(new File(dev, base + "offset"));
                    rows.add(new Reading(n, withUnit(n, scaled(raw, scale, offset))));
                }
            }
        }

        if (rows.isEmpty()) {
            addRow("-", "no readable channel");
        } else {
            for (Reading r : rows) {
                addRow(r.channel, r.value);
            }
        }
    }

    private String scaled(String raw, String scale, String offset) {
        try {
            double v = Double.parseDouble(raw.trim());
            if (offset != null) {
                v += Double.parseDouble(offset.trim());
            }
            if (scale != null) {
                v *= Double.parseDouble(scale.trim());
            }
            return String.format(Locale.US, "%.3f", v);
        } catch (NumberFormatException e) {
            return raw;
        }
    }

    private String withUnit(String channel, String value) {
        if (channel.contains("temp")) {
            return value + " (milli C)";
        }
        if (channel.contains("pressure")) {
            return value + " kPa";
        }
        if (channel.contains("humidityrelative")) {
            return value + " (milli %RH)";
        }
        return value;
    }

    private String read(File f) {
        try {
            return new String(Files.readAllBytes(f.toPath()), StandardCharsets.UTF_8).trim();
        } catch (IOException | RuntimeException e) {
            return null;
        }
    }

    private void addHeading(String text) {
        TextView tv = new TextView(this);
        tv.setText(text);
        tv.setTextSize(TypedValue.COMPLEX_UNIT_SP, 18);
        tv.setTypeface(Typeface.DEFAULT_BOLD);
        tv.setPadding(0, 24, 0, 8);
        mList.addView(tv);
    }

    private void addRow(String channel, String value) {
        LinearLayout row = new LinearLayout(this);
        row.setOrientation(LinearLayout.HORIZONTAL);

        TextView left = new TextView(this);
        left.setText(channel);
        left.setTextSize(TypedValue.COMPLEX_UNIT_SP, 15);
        left.setLayoutParams(new LinearLayout.LayoutParams(0,
                ViewGroup.LayoutParams.WRAP_CONTENT, 3f));

        TextView right = new TextView(this);
        right.setText(value);
        right.setTextSize(TypedValue.COMPLEX_UNIT_SP, 15);
        right.setTypeface(Typeface.MONOSPACE);
        right.setGravity(Gravity.END);
        right.setLayoutParams(new LinearLayout.LayoutParams(0,
                ViewGroup.LayoutParams.WRAP_CONTENT, 2f));

        row.addView(left);
        row.addView(right);
        mList.addView(row);
    }

    private void addMessage(int resId) {
        TextView tv = new TextView(this);
        tv.setText(getString(resId));
        tv.setTextSize(TypedValue.COMPLEX_UNIT_SP, 16);
        tv.setTextColor(Color.rgb(0xb0, 0x00, 0x20));
        tv.setPadding(0, 24, 0, 0);
        mList.addView(tv);
    }
}
