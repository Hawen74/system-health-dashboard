# 🖥️ System Health Dashboard

> A color-coded, at-a-glance Linux system diagnostic tool — built for sysadmins, students, and anyone who wants to know if their server is healthy in seconds.

---

## 📋 Table of Contents
- [The Problem It Solves](#-the-problem-it-solves)
- [What It Does](#-what-it-does)
- [Sample Output](#-sample-output)
- [How to Use It](#-how-to-use-it)
- [Test It Instantly in Codespaces](#-test-it-instantly-in-codespaces)
- [Project Structure](#-project-structure)
- [License](#-license)
- [Attribution](#-attribution)

---

## 🔍 The Problem It Solves

**Case Study:** When managing a Linux server, checking system health usually means running 4–5 separate commands (`top`, `free`, `df`, `uptime`, `who`) and mentally piecing together the results. This is slow and error-prone — especially under pressure.

**Solution:** `health-check.sh` runs all those checks at once and presents the results in a single, color-coded dashboard. Green means you're fine. Yellow means watch out. Red means act now.

This is useful for:
- 🧑‍💻 Students learning Linux administration
- 🛠️ Sysadmins doing quick server diagnostics
- 🚀 DevOps engineers checking on a fresh deployment

---

## ✅ What It Does

| Check | What It Reports |
|---|---|
| **CPU Usage** | % of CPU currently in use |
| **Memory Usage** | MB used / total, and percentage |
| **Disk Usage** | Storage used on root partition `/` |
| **Uptime** | How long the system has been running |
| **Load Average** | 1/5/15 minute system load |
| **Active Users** | Who is currently logged in |

**Color coding:**

| Color | Meaning | Threshold |
|---|---|---|
| 🟢 Green | OK | Under 70% |
| 🟡 Yellow | Warning | 70% – 89% |
| 🔴 Red | Critical | 90%+ |

---

## 🖼️ Sample Output

```
  ╔═══════════════════════════════════════╗
  ║     🖥️  SYSTEM HEALTH DASHBOARD        ║
  ╚═══════════════════════════════════════╝

  Host:  my-linux-server
  IP:    10.0.0.42
  Date:  Friday, March 13 2026  14:22:05

══════════════════════════════════════
  ⚡ Performance
══════════════════════════════════════
  CPU Usage:           23%
  Memory Usage:        512MB / 1024MB (50%)
  Disk Usage:          8.2G / 30G (27%)

══════════════════════════════════════
  🕒 System Info
══════════════════════════════════════
  Uptime:              up 3 hours, 14 minutes
  Load Average:        0.12, 0.08, 0.05

══════════════════════════════════════
  👥 Active Users
══════════════════════════════════════
  1 user(s): vscode
```

---

## 🚀 How to Use It

### Basic Run
```bash
health-check.sh
```

### Show Help
```bash
health-check.sh -h
```

### Debug Mode (shows internal values step by step)
```bash
health-check.sh -d
```

---

## ☁️ Test It Instantly in Codespaces

No installation needed — run this project live in your browser in under a minute:

1. Click the green **`<> Code`** button at the top of this repo
2. Select the **`Codespaces`** tab
3. Click **`Create codespace on main`**
4. Wait for the environment to finish loading (about 30–60 seconds)
5. In the terminal, run the setup command:
   ```bash
   . ./bin/repo.sh
   ```
6. Then launch the health dashboard:
   ```bash
   health-check.sh
   ```

> 💡 **Tip:** Try `health-check.sh -d` to see debug output and understand how each value is collected.

---

## 📁 Project Structure

```
.
├── bin/
│   ├── health-check.sh      # ← Main script (run this!)
│   └── repo.sh              # Workspace navigation helper
├── lib/
│   └── tools.sh             # Shared library (input validation, debug tools)
├── .devcontainer/
│   ├── devcontainer.json    # Codespaces configuration
│   ├── install-tools.sh     # Installs system dependencies
│   └── setup-env.sh         # Configures shell environment
├── .bashrc                  # Custom shell prompt and aliases
├── .gitignore               # Ignores temp/log files
├── LICENSE                  # Apache 2.0
└── README.md                # You are here!
```

---

## 📄 License

This project is licensed under the **Apache License 2.0** — free to use, modify, and share in educational and professional contexts.  
See [LICENSE](./LICENSE) for full details.

---

## 🤝 Attribution

| Role | Contributor |
|---|---|
| **Script Author** | Huy Nguyen Gia Le |
| **AI Assistance** | Claude (Anthropic) — code structure, documentation, best practices |
| **Template Base** | [Script Template Repo](https://github.com/) by Bill Newman |
| **Environment** | North Seattle College IT135 — Intro to Linux |

> This project follows the **AI-Augmented Engineering** model: the human drives the design and learning; AI assists with syntax, structure, and documentation standards.