# Server Performance Stats (`server-stats.sh`)

A lightweight Bash script to analyze basic server performance metrics on any Linux machine. 

This project was built to fulfill the [Server Stats Project on roadmap.sh](https://roadmap.sh/projects/server-stats).

## 🚀 Features

* **CPU Usage:** Total CPU utilization percentage.
* **Memory Usage:** Total, used, and free memory along with percentage breakdown.
* **Disk Usage:** Root filesystem (`/`) space usage, free space, and percentages.
* **Top Processes:** 
  * Top 5 processes by CPU consumption.
  * Top 5 processes by Memory consumption.
* **Stretch Goal Stats:**
  * OS Version & Kernel information.
  * System Uptime & Load Average.
  * Logged-in users.
  * Total failed login attempts from auth logs.

## 📦 Getting Started

### Prerequisites
* Any Linux distribution (Ubuntu, Debian, CentOS, RHEL, Amazon Linux, etc.)
* Standard command-line utilities (`bash`, `top`, `ps`, `awk`, `df`, `free`)

### Installation & Execution

1. **Clone the repository:**
   ```bash
   git clone [https://github.com/chaituupasi3-wq/server-stats.git](https://github.com/chaituupasi3-wq/server-stats.git)
   cd server-stats
