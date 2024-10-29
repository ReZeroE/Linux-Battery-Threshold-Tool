# Linux-Battery-Threshold-Tool
Simple utility that sets the battrey charge threshold on linux devices (ThinkPads, XPS, Latitude, etc).


### Supported OS
Support varies based on the Linux kernel version, laptop model (primarily Lenovo ThinkPads and some Dell and ASUS models), and whether battery management tools are installed. 

Some of the OS with the compatible kernel support are:

- [x] Ubuntu 20.04+
- [x] Fedora 34+
- [x] Arch/Manjaro (kernel 5.10+)
- [x] Debian 11+
- [x] OpenSUSE 15.3+

### How to run
```shell
$ git clone https://github.com/ReZeroE/Linux-Battery-Threshold-Tool.git
$ cd Linux-Battery-Threshold-Tool
$ chmod +x set_max_threshold.sh

$ ./set_max_threshold.sh --help
```
```
Usage: sudo ./set_battery_threshold.sh [options]

Options:
  -h, --help          Display this help message and exit
  --show              Show the current battery threshold for all detected batteries

Description:
This script allows you to set or view the battery charge control end threshold for
laptops that support battery threshold management.

Instructions:
  1. Run the script with superuser privileges.
  2. If multiple batteries are detected, you will be prompted to select one.
  3. Enter a threshold value between 60 and 100.

Examples:
  sudo ./set_battery_threshold.sh          # Set the threshold for a battery
  sudo ./set_battery_threshold.sh --show   # Show the current thresholds

```

### Limitations
This tool relies on Linux kernel support for the specific battery management interface used by the laptop hardware. For laptops that doesn’t have native support for battery threshold control, you might need to rely on tools like `TLP` or specific kernel modules


