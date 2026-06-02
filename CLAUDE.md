# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Running the app

```bash
cd src
python main.py
```

Requires the pedal connected on `/dev/ttyUSB0`. If the serial device is absent, `PedalReader` will crash on startup — run without the pedal by simply not connecting the pedal thread, or comment out `threadpool.start(pedal_reader)` temporarily.

Music control via `playerctl` must be installed for `SoundHandler.play_music()` / `pause_music()` to work.

## Installing dependencies

```bash
pip install -r src/requirements.txt
```

## Compiling the PIC firmware

Run from the `build/` directory. Requires `xc8-cc` and the Microchip DFP pack extracted there:

```bash
cd build
xc8-cc -mcpu=12F683 -mdfp="./Microchip.PIC10-12Fxxx_DFP.1.8.184/xc8" ../src/PIC_program/main.c
```

## Architecture

The project has two independent parts:

**Embedded pedal (C / PIC12F683)**
- `src/PIC_program/main.c` — bit-banged 9600 baud serial TX. Reads GP2 (button), mirrors it to an LED on GP1, and continuously streams the button byte over GP0. The CH340 USB-serial adapter makes it appear as `/dev/ttyUSB0`.

**Python/QML UI**
- `src/main.py` — entry point. Creates `BoxingTimer` and `PedalReader`, exposes `boxing_timer` as a QML context property, starts `PedalReader` in a `QThreadPool` thread, then loads `main.qml`.
- `src/logic/timer.py` — `BoxingTimer(QObject)`. Owns a 1 Hz `QTimer`. State machine: work/rest alternation driven by `interval_number`. Properties exposed to QML: `time_remaining_property`, `timer_active_property`, `time_to_rest_property`, `work_interval_property`, `rest_interval_property`, `total_repetitions_property` / `current_repetition_property`.
- `src/logic/pedal_reader.py` — `PedalReader(QRunnable)`. Blocking serial read loop on `/dev/ttyUSB0`. Emits `pedal_pressed` signal on falling edge (byte `\x01` → `\x00`). Connected to `BoxingTimer.pedal_pressed()`.
- `src/logic/sound_handler.py` — plays `sound/beep.wav` via `QMediaPlayer` for countdown beeps; calls `playerctl play/pause` for background music.
- `src/config.yaml` — timer configuration (currently only `timer_update_interval`). Read by `config_loader.load_config("timer_settings")`.

**QML UI** (`src/main.qml`, `src/ui/`)
- `main.qml` — fullscreen `ApplicationWindow`. Composes `BoxingClock` (top 90 %) and `ToolBar` (bottom 10 %).
- `ui/BoxingClock.qml` — big countdown display. Background is red during work, green during rest.
- `ui/ToolBar.qml` — start/stop button + `Stats` panel.
- `ui/Stats.qml` — editable fields for repetition count, work interval, and rest interval (binds to `boxing_timer` properties).

## Key design notes

- `interval` is always a two-element list `[work_seconds, rest_seconds]`. `interval_number` indexes into it mod 2: even = work, odd = rest. `interval_repetitions` is stored as `rounds * 2`.
- Time strings for `set_work_interval` / `set_rest_interval` must be in `"m:ss"` format (e.g. `"2:00"`).
- `SoundHandler` calls `playerctl` via `os.system` — this controls whatever media player is currently active on the desktop session.
