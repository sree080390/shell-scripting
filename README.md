# shell-scripting

A collection of Bash scripts used to learn and practice core shell scripting concepts — variables, data types, conditionals, loops, arrays, functions, special variables, logging, and error handling (`trap`/`set -e`) — building up to a small package-installer/service-validator utility.

## Files

| File | Purpose |
|---|---|
| [`hello-world.sh`](./hello-world.sh) | The classic first script — prints `Hello-World`. Sanity check that Bash is working. |
| [`variables.sh`](./variables.sh) | Demonstrates positional parameters (`$1`, `$2`) by taking a person's name and company as command-line arguments and printing a short message with them. |
| [`conversation.sh`](./conversation.sh) | Demonstrates basic string variables (as opposed to positional args) by hard-coding a person/company and printing the same kind of message. |
| [`datatypes.sh`](./datatypes.sh) | Reads two values interactively (`read -p`) and adds them with arithmetic expansion (`$(( ))`). Illustrates that Bash arithmetic silently treats non-numeric input as `0` — worth pairing with input validation. |
| [`read_variables.sh`](./read_variables.sh) | Shows different forms of `read`: plain `read` into a variable, and `read -s` for hidden/silent input (e.g. passwords). |
| [`special-variables.sh`](./special-variables.sh) | Reference sheet for Bash's built-in special variables: `$@`/`$#` (all args / arg count), `$1` (first arg), `$0` (script name), `$USER`, `$PWD`, `$HOME`, `$$` (current PID), `$!` (last background PID), `$?` (last exit status), `$SHELL`, `$LINENO`, `$SECONDS`, and `$RANDOM`. |
| [`dynamic_variables.sh`](./dynamic_variables.sh) | Shows command substitution (`$(...)`) by capturing the output of `date +%s` into a message at run time. |
| [`arrays.sh`](./arrays.sh) | Demonstrates Bash array syntax: declaring an array, printing all elements (`${arr[@]}`), element count (`${#arr[@]}`), and indexing including negative indices (`${arr[-1]}`). |
| [`conditions.sh`](./conditions.sh) | Introduces `if`/`elif`/`else` with a numeric comparison example, then a practical use case: checking the current user is root (`id -u`), checking whether `httpd` is installed via `dnf`, installing it if missing, and validating the service is running via `systemctl status` + `grep`. |
| [`functions.sh`](./functions.sh) | Wraps the install/validate logic from `conditions.sh` into a reusable `INSTALL()` function that takes a package name as an argument (prompted via `read -p`), checks/install it with `dnf`, and starts/validates the corresponding service. |
| [`loops.sh`](./loops.sh) | Extends `functions.sh` to accept **multiple** packages as command-line arguments and loops over them (`for packages in "$@"`), calling `INSTALL` for each. Adds a separate `STATUS_VALIDATE()` function, color-coded (`red`/`yellow`/`green`) `echo -e` output, and a special case mapping the `mysql-server` package name to its `mysqld` service name. |
| [`logs.sh`](./logs.sh) | Same install/validate workflow as `loops.sh`, extended to log every step (with timestamps) to `/var/log/shell-script.log` and `/var/log/shell-script-status.log` via `tee -a`, so execution history persists outside the terminal. |
| [`set_trap.sh`](./set_trap.sh) | The most robust version of the installer script: adds `set -e` (exit immediately on any unhandled command failure) and a `trap ... ERR` handler that prints the timestamp, line number, and exact command that failed before the script exits — making failures easier to diagnose than a silent exit. |

## Usage

Most of the install/validate scripts (`conditions.sh`, `functions.sh`, `loops.sh`, `logs.sh`, `set_trap.sh`) are designed for RHEL/CentOS/Amazon Linux systems (they use `dnf` and `systemctl`) and must be run as **root**, since they install packages and manage services.

```bash
chmod +x loops.sh
sudo ./loops.sh httpd mysql-server
```

Scripts that read command-line arguments (`variables.sh`) or take input interactively (`datatypes.sh`, `read_variables.sh`, `conditions.sh`, `functions.sh`) will behave differently depending on how they're invoked — check each script's `read`/positional-parameter usage before running.

## Notes

- Logs from `logs.sh` and `set_trap.sh` are written to `/var/log/shell-script.log` (install logs) and `/var/log/shell-script-status.log` (status/service logs) — ensure the running user has write access to `/var/log`.
- The progression across files (`conditions.sh` → `functions.sh` → `loops.sh` → `logs.sh` → `set_trap.sh`) reflects an intentional learning path: starting from a single hard-coded `if` check, then refactoring into a function, then looping over multiple inputs, then adding logging, then adding proper error handling with `set -e` and `trap`.
