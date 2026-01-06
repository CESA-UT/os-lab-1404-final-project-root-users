# 🛠️ Root-Monitor (Advanced Process Manager)
**Project for OS Lab - Team: Root Users**

## 🌟 Key Features

### 🎨 Smart Resource Visualization
The tool analyzes CPU/RAM usage and applies real-time color-coding:
- 🟢 **[NORMAL]**: Efficient usage (Under 15%)
- 🟡 **[WARNING]**: Moderate load (15% - 70%)
- 🔴 **[CRITICAL]**: High stress (Over 70%)

### 📊 Structured Output
Unlike standard `ps` commands, Root-Monitor uses formatted tables with clear headers, making it easy to read PIDs, Users, and Process names at a glance.

### 🛡️ Safety Confirmation
To prevent accidental system instability, the `kill` command includes a two-step confirmation prompt before terminating any process.

## 🚀 Usage Guide

| Command | Description |
| :--- | :--- |
| `root-monitor --list` | Displays Top 10 processes with status alerts |
| `root-monitor --search [NAME]` | Advanced formatted search for specific processes |
| `root-monitor --kill [PID]` | Safely terminates a process with confirmation |
| `man root-monitor` | Access the official system manual |

----------------------------------------------------------------------------------------------------


## 🛠 Debian Package Architecture
This project is more than just a script; it is a professionally structured Debian package.



* **Standard Directory Hierarchy**: Follows Linux FHS (Filesystem Hierarchy Standard).
* **Automated Configuration**: Deploys global settings to `/etc/root-monitor.conf`.
* **Manual Integration**: Includes a compressed Man-Page (`man root-monitor`) for offline documentation.
* **Dependency Management**: Built using `debhelper` to ensure compatibility across Debian-based distros.

----------------------------------------------------------------------------------------------------

## 📦 Installation & Removal

### Install
Download the `.deb` file and run:
```bash
sudo dpkg -i root-monitor_1.0_all.deb

----------------------------------------------------------------------------------------------------

## ⚙️ Customization
You can change the default sorting behavior (CPU vs Memory) by editing the global configuration file:
```bash
sudo nano /etc/root-monitor.conf
# Change SORT_BY="cpu" to SORT_BY="mem"
