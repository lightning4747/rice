# Lightning Fan — Audit & Refinement Tasks

Tasks to resolve the current issues and implement the requested features.

## Phase 1: Resetting Problem (WATCHDOG REVISION)
- [x] Remove/disable client heartbeat watchdog timer in the daemon so that the manual fan speed or curve persists when the GUI is closed.
- [x] Keep the daemon's SIGINT/SIGTERM handlers intact to safely revert to BIOS Auto control (mode 2) when the daemon service itself is stopped.
- [x] Recompile daemon and restart `lightning-faud` service.
- [x] Verify that closing the Tauri UI application does NOT drop the fan speed to 0 RPM/Auto mode.

## Phase 2: Theme Refinement (BLACK & WHITE UI)
- [x] Redesign React frontend styling in `App.css` and `App.tsx` to use a clean grayscale (black/white/gray) color palette.
- [x] Restructure card layouts, sliders, and borders to look less "vibe-coded" (clean borders, crisp margins, no heavy gradients/glows).
- [x] Retain colored indicators/accents ONLY for functional status icons (e.g. CPU temp = rose/red, GPU temp = purple/blue, Fan spinning = teal, connection badge).
- [x] Rebuild Tauri frontend application.

## Phase 3: Desktop Integration & Shortcuts (LAUNCHER & CLI)
- [x] Create a shell script named `fan` in `/home/bow/.local/bin/fan` to launch the Tauri frontend app.
- [x] Make the script executable.
- [x] Create a desktop entry file `/home/bow/.local/share/applications/lightning-fan.desktop` to make the application show up in the application launcher (Super + d).
- [x] Verify desktop integration and CLI command access.
