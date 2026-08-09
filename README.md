# Job Counter

A macOS SwiftUI app and desktop widget for tracking job-application counts together (“My Applications” vs “His Applications”), with local App Group storage and optional Firebase Firestore sync.

## Run in Xcode

1. Open **`JobCounter.xcodeproj`** (double-click it, or `open JobCounter.xcodeproj`).
2. Wait for Swift packages (**Firebase**) to finish resolving if prompted.
3. Select the **JobCounter** scheme and destination **My Mac**.
4. Confirm **Signing & Capabilities** uses your **Personal Team** for both **JobCounter** and **JobCounterWidget**.
5. Press **⌘R** to build and run.

Local counting works without Firebase. Cloud sync needs a **`GoogleService-Info.plist`** from your Firebase project added to the **JobCounter** (and optionally widget) target.

> The project is defined by `project.yml`. If you regenerate it with [XcodeGen](https://github.com/yonaskolb/XcodeGen), run `xcodegen generate` from the repo root.

## Distribute a standalone `.app` (free Apple ID / Personal Team)

You can build and share Job Counter using a free Apple ID signed with your **Personal Team** (no paid Developer Program membership required for ad‑hoc local installs).

### 1. Sign in and select your team in Xcode

1. Open the project in **Xcode**.
2. Go to **Xcode → Settings… → Accounts**.
3. Click **+** and sign in with your free **Apple ID** if you haven’t already.
4. Select the **JobCounter** app target → **Signing & Capabilities**.
5. Enable **Automatically manage signing**.
6. Set **Team** to your **Personal Team** (usually your name).
7. Confirm the Bundle Identifier is unique (e.g. `com.yourname.JobCounter`).
8. Repeat signing for the **widget extension** target if present, using the same team and a matching App Group (`group.com.jobcounter.app`).

> Note: Personal Team builds expire after a limited period (often about 7 days). Rebuild and resend when the partner’s copy stops launching.

### 2. Archive and export the `.app` bundle

1. In the Xcode toolbar, set the run destination to **Any Mac** (or your Mac if “Any Mac” isn’t listed).
2. Choose **Product → Archive**. Wait for the archive to finish; the **Organizer** window should open.
3. In **Organizer**, select the new archive → **Distribute App**.
4. Choose **Copy App** (or **Custom** → option that exports a local macOS app, depending on your Xcode version).
5. Finish the wizard and pick an export folder.
6. You should get a folder containing **`JobCounter.app`**.

### 3. Zip the app and send it

1. In Finder, locate `JobCounter.app`.
2. Right‑click → **Compress “JobCounter.app”** to create `JobCounter.app.zip`.
3. Upload the zip to **Google Drive** (or attach it in **Email** / Messages).
4. Share the link or send the zip to your partner.

Ask your partner to:

1. Download and unzip the archive.
2. Drag **`JobCounter.app`** into **/Applications**.
3. Run the quarantine bypass command below before opening the app (recommended), **or** right‑click → **Open** the first time if macOS shows a warning.

## Bypass download quarantine (partner Mac)

macOS marks apps downloaded from the internet (Drive, email, etc.) with a quarantine flag, which can block launch (“app can’t be opened because Apple cannot check it for malicious software”).

After placing the app in **Applications**, open **Terminal** and run:

```bash
xattr -cr /Applications/JobCounter.app
```

Then open **Job Counter** from Applications (or Spotlight).

> This only clears the quarantine attributes on that copy of the app; it does not disable Gatekeeper system‑wide.

## Auto-refresh signing (bypass the ~7 day Personal Team expiry)

Personal Team builds expire after about a week. Ship the **whole project folder** (including `JobCounter.xcodeproj` and `installer.sh`), not only the `.app`.

### Before you zip (you)

```bash
chmod +x installer.sh
```

Zip the project directory and send it (Drive/Email).

### What your partner does

**Requirements on his Mac:** Xcode installed, signed into Xcode with his Apple ID (Personal Team).

1. Unzip the project folder somewhere permanent (e.g. `~/Developer/JobCounter`) — don’t delete it later; the refresher rebuilds from this path.
2. Drag **`JobCounter.app`** into **/Applications** (if you included a prebuilt app), or build once from Xcode first.
3. Open **Terminal**, `cd` into the unzipped project folder, and run:

```bash
xattr -cr /Applications/JobCounter.app && ./installer.sh
```

That installs a LaunchAgent (`com.jobcounter.refresh`) which rebuilds and reinstalls the app about every **5 days** (`StartInterval` = 432000 seconds). Logs: `~/.jobcounter/refresh.log`.
