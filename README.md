# VibeReps for Codex

Tend to your quads while Codex tends to your code.

Do exercises and think a little yourself while you wait for Codex.

> "It's the era of tending to your Claudes."
> — [Boris Cherny](https://x.com/bcherny), creator of Claude Code, on [Greg Isenberg's podcast](https://x.com/gregisenberg)

<p align="center">
  <img src="assets/xkcd_waiting_for_claude.png" alt="xkcd: Waiting for Claude" width="500">
  <br>
  <sub>Based on <a href="https://xkcd.com/303/">xkcd #303</a> by Randall Munroe (CC BY-NC 2.5)</sub>
</p>

---

## 🚀 One-Line Install

```bash
curl -sSL https://raw.githubusercontent.com/TheLoroXD/vibereps/main/install.sh | bash
```

This installs the **menubar app** (recommended). For browser-only mode:

```bash
curl -sSL https://raw.githubusercontent.com/TheLoroXD/vibereps/main/install.sh | bash -s -- --webapp
```

Then restart Codex and run **`/hooks`** once to review and trust the new hooks.

<details>
<summary><b>Alternative: Install from local clone</b></summary>

```bash
git clone https://github.com/TheLoroXD/vibereps.git
cd vibereps
./install.sh
```

</details>

<details>
<summary><b>Uninstall</b></summary>

```bash
~/.vibereps/install.sh --uninstall
```

</details>

---

## 🖥️ Menubar App (Electron)

For a more integrated experience, use the **VibeReps menubar app**:

- Always-on menubar presence with exercise/usage stats
- Random exercise auto-selection
- Native desktop notifications
- Multi-instance coding-agent session tracking
- Offline mode with bundled MediaPipe *(coming soon)*

### Install Menubar App

```bash
cd electron
./install.sh
```

This will:
1. Build the native macOS app
2. Install to /Applications
3. Optionally configure Codex and/or Claude Code hooks

Or build a distributable DMG:
```bash
cd electron
npm install
npm run build:dmg
# Output: electron/dist/VibeReps-1.0.0.dmg
```

<details>
<summary><b>Menubar App Features</b></summary>

- **Stats in menu**: Today's reps and agent usage at a glance
- **Auto-refresh**: Stats update after each exercise
- **Random exercise**: Opens with a random exercise (quick mode)
- **Session tracking**: Tracks multiple agent instances
- **Start at login**: Add to Login Items for always-on tracking

</details>

---

## 🎯 How It Works

**The workflow:** Codex edits a file → Exercise until Codex is done → Get notified when ready

```
You: "Hey Codex, refactor this code"
    ↓
🏋️ Exercise tracker launches
    ↓
You exercise ← → Codex processes your request
    ↓
Exercise complete → "⏳ Waiting for Codex..."
    ↓
Codex finishes → App shows "Ready!"
    ↓
You return to check the response
```

<details>
<summary><b>Manual setup (if not using installer)</b></summary>

Add to `~/.codex/hooks.json`:

```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "apply_patch|Edit|Write",
        "hooks": [
          {
            "type": "command",
            "command": "VIBEREPS_EXERCISES=squats,jumping_jacks,standing_crunches,calf_raises,side_stretches /path/to/vibereps.py",
            "statusMessage": "Starting VibeReps"
          }
        ]
      }
    ],
    "Stop": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "/path/to/vibereps.py",
            "statusMessage": "Notifying VibeReps"
          }
        ]
      }
    ]
  }
}
```

</details>

## 🏋️ Features

- **Real-time pose detection** using MediaPipe AI
- **Stand-up verification** - ensures you're fully visible before starting
- **13 exercise types** including:
  - Squats, push-ups, jumping jacks
  - Standing crunches, calf raises, side stretches
  - High knees, torso twists, arm circles
  - Shoulder shrugs, neck rotations, neck tilts (posture correction)
- **Two modes:**
  - Quick mode: Keep exercising while Codex works
  - Normal mode: 10+ reps for breaks
- **Desktop notifications** when Codex is ready (only when terminal isn't focused)
- **CLI control** - `vibereps --toggle` / `--pause` / `--resume` / `--status`
- **Smart suppression** - skips agent sessions, debounces notifications, prevents replay triggers
- **Auto-updates** - daily non-blocking check for new versions
- **Shell completions** - tab completion for bash and zsh
- **No installation required** - uses Python standard library
- **Privacy-focused** - all video processing happens locally in browser

## 📋 Requirements

**Browser Version:**
- Python 3 (standard library only!)
- Modern web browser (Chrome, Firefox, Safari)
- Webcam
- Internet connection (for MediaPipe CDN)

**Menubar App (Electron):**
- macOS 10.15+
- Node.js 18+ (for building)
- Webcam
- No internet required (MediaPipe bundled)

## 🔧 Configuration

### Environment Variables (Optional)

```bash
# Choose which exercises to use (comma-separated, random selection each time)
export VIBEREPS_EXERCISES=squats,jumping_jacks   # Only squats and jumping jacks
export VIBEREPS_EXERCISES=squats,pushups,jumping_jacks,standing_crunches,calf_raises,side_stretches  # All exercises

# --dangerously-skip-leg-day (filters out squats, calf raises, high knees, jumping jacks)
export VIBEREPS_DANGEROUSLY_SKIP_LEG_DAY=1

# Remote VibeReps server (coming soon - not yet deployed)
# export VIBEREPS_API_URL=https://your-server.com
# export VIBEREPS_API_KEY=your_api_key

# Disable tracking entirely
export VIBEREPS_DISABLED=1

# UI mode (for non-interactive install)
export VIBEREPS_UI_MODE=electron  # or webapp

# Trigger mode (when exercises start)
export VIBEREPS_TRIGGER_MODE=edit-only  # (recommended) trigger when Codex edits files
export VIBEREPS_TRIGGER_MODE=prompt     # (experimental) also trigger on prompt submit
```

If `VIBEREPS_EXERCISES` is set, the tracker will randomly pick one exercise from the list and auto-start it (no manual selection needed).

### Customize Exercise Reps

Edit `exercise_ui.html` to change target reps:

```javascript
let targetReps = {squats: 10, pushups: 10, jumping_jacks: 20, standing_crunches: 10, calf_raises: 15, side_stretches: 10};      // Normal mode
let quickModeReps = {squats: 5, pushups: 5, jumping_jacks: 10, standing_crunches: 5, calf_raises: 8, side_stretches: 6};     // Quick mode
```

### Change Detection Sensitivity

Adjust angle thresholds in `exercise_ui.html` (in the detection functions):

```javascript
// Example: Make squats require deeper depth
if (angle < 80 && exerciseState !== 'down') {  // Default: 100
```

## 🧪 Testing

```bash
# Test quick mode with specific exercises
VIBEREPS_EXERCISES=squats,standing_crunches ./vibereps.py post_tool_use '{}'

# Test Codex completion notification (run in another terminal while tracker is open)
echo '{"hook_event_name":"Stop"}' | ./vibereps.py

# Test normal mode
./vibereps.py task_complete '{}'
```

## 🚨 Troubleshooting

**Hooks not triggering?**

```bash
# Check hooks are registered
/hooks list

# Make scripts executable
chmod +x vibereps.py

# Verify paths are correct (use absolute paths)
which python3  # Use this path if needed
```

**Camera permission denied?**
- Grant permission when browser prompts
- macOS: System Preferences > Security & Privacy > Camera
- Browser settings: Check camera permissions for localhost

**Exercises not detecting?**
- Ensure good lighting
- Position camera to see full body (head to feet)
- Stand 3-6 feet from camera
- Check browser console (F12) for errors

**Desktop notifications not showing?**
- Grant notification permission when prompted
- Check browser notification settings
- Check system notification preferences

**Menubar app camera not working?**
- Check System Settings > Privacy & Security > Camera
- Ensure VibeReps has camera permission
- Try: `tccutil reset Camera com.vibereps.app`

**Menubar app not showing stats?**
- Click "Refresh Stats" in the menu
- Ensure exercises are being logged to `~/.vibereps/exercises.jsonl`
- For Claude usage, ensure `ccusage` is installed: `npm install -g ccusage`

## 🤖 Claude Code Skill

VibeReps still includes the upstream Claude Code skill:

```
/vibereps
```

The skill handles everything based on context:
- **Setup/install** → Runs installer or configures hooks
- **Test/launch** → Starts the exercise tracker
- **Add exercise** → Guides through creating custom exercises
- **Tune detection** → Helps adjust thresholds if reps aren't counting

**Example:** After installing, run `/vibereps` in Claude Code to set up your preferred exercises.

### Install via skills.sh

```bash
npx skills add TheLoroXD/vibereps
```

## 📊 Usage Statistics

Track Claude Code usage alongside exercise data with `vibereps-usage.py`.

Built on top of [**ccusage**](https://github.com/ryoppippi/ccusage) by [@ryoppippi](https://github.com/ryoppippi) - a fantastic tool for tracking Claude Code token usage and costs. Our usage script was inspired by ccusage's clean table format and adds exercise tracking alongside your coding stats.

```bash
./vibereps-usage.py
```

<p align="center">
  <img src="assets/vibereps-usage.gif" alt="vibereps-usage demo" width="800">
</p>

Combines ccusage output with your exercise log into a single table:

```
┌────────────┬───────────────────────────────────────┬───────────┬───────────┬───────────────┬──────────────┬───────────────┬─────────────┬───────────────────────────┐
│ Date       │ Models                                │     Input │    Output │ Cache Create  │   Cache Read │ Total Tokens  │        Cost │ Exercises                 │
├────────────┼───────────────────────────────────────┼───────────┼───────────┼───────────────┼──────────────┼───────────────┼─────────────┼───────────────────────────┤
│ 2026-01-27 │ - opus-4-5                            │   890,234 │    45,678 │     1,234,567 │    8,901,234 │    11,071,713 │     $12.34  │ 45 Squats, 30 Jumping     │
│            │ - sonnet-4-5                          │           │           │               │              │               │             │ Jacks, 20 Calf Raises     │
├────────────┼───────────────────────────────────────┼───────────┼───────────┼───────────────┼──────────────┼───────────────┼─────────────┼───────────────────────────┤
│ 2026-01-28 │ - opus-4-5                            │   456,789 │    23,456 │       567,890 │    4,567,890 │     5,616,025 │      $6.78  │ 25 Squats, 15 Standing    │
│            │                                       │           │           │               │              │               │             │ Crunches                  │
├────────────┼───────────────────────────────────────┼───────────┼───────────┼───────────────┼──────────────┼───────────────┼─────────────┼───────────────────────────┤
│ Total      │                                       │ 1,347,023 │    69,134 │     1,802,457 │   13,469,124 │    16,687,738 │     $19.12  │ 70 Squats, 30 Jumping     │
│            │                                       │           │           │               │              │               │             │ Jacks, 20 Calf Raises,    │
│            │                                       │           │           │               │              │               │             │ 15 Standing Crunches      │
└────────────┴───────────────────────────────────────┴───────────┴───────────┴───────────────┴──────────────┴───────────────┴─────────────┴───────────────────────────┘
```

### Options

```bash
# Filter by date range (passed to ccusage)
./vibereps-usage.py --since 2026-01-01
./vibereps-usage.py --since 2026-01-20 --until 2026-01-27

# Show only exercises (no Claude usage)
./vibereps-usage.py --exercises-only
```

### Requirements

- [ccusage](https://github.com/ryoppippi/ccusage): `npm install -g ccusage`
- Exercise data logged to `~/.vibereps/exercises.jsonl` (automatic when using hooks)

## 📚 More Info

- `CLAUDE.md` - Technical architecture and implementation details
- `exercise_ui.html` - UI and pose detection logic (customize reps and sensitivity here)
- `server/` - Remote server for multi-user stats, leaderboards, and MCP integration *(coming soon)*

## 💡 Tips

- **Too easy?** Increase reps or choose harder exercises
- **Too hard?** Decrease reps or choose easier exercises
- **Want variety?** The tracker suggests exercises you haven't done recently
- **Track progress?** Use `./vibereps-usage.py` to see stats alongside Claude Code usage

---

**Stay healthy and keep coding!** 💪🚀
