#!/bin/bash

declare -r TARGET_USER="root"
#declare -r WORKSPACE="/${TARGET_USER}/Desktop"
declare -r REPO_URL="https://github.com/odell0111/turnstile_solver.git"

clean_pids() {
    find /var/run -name '*xrdp*.pid' -delete
}

service_init() {
    clean_pids
    xrdp-sesman & xrdp -n &
    local timeout=20

    while ((timeout-- > 0)); do
        pgrep -x Xorg && return 0
        sleep 1
    done
    return 1
}

user_setup() {
    if ! id "${TARGET_USER}" &>/dev/null; then
        getent group "${TARGET_USER}" || groupadd "${TARGET_USER}"
        useradd -mUs "/bin/bash" -G "${TARGET_USER},sudo" "${TARGET_USER}" || return 1
    fi
    echo "${TARGET_USER}:${TARGET_USER}" | chpasswd || return 1
}

env_config() {
    [[ -n "${TZ}" ]] && {
        ln -sf "/usr/share/zoneinfo/${TZ}" /etc/localtime
        echo "${TZ}" >/etc/timezone
    }
#    mkdir -p "${WORKSPACE}"
}

repo_setup() {
#    ( cd "${WORKSPACE}" && git clone -q "${REPO_URL}" && cd turnstile_solver || exit 2
#    pip3 install -r requirements.txt --break-system-packages )
    pip3 install "git+${REPO_URL}@main" --break-system-packages || exit 2
}

# Execution flow
user_setup || { echo "User config failed"; exit 1; }
env_config || exit 1
repo_setup || { echo "Repo setup failed"; exit 2; }
if service_init; then
  echo "Xorg running"
else
  echo "X server failed"
  exit 3
fi

if [ "$START_SERVER" = "true" ]; then
  echo "Starting server in headful mode..."
  xvfb-run -a python3 solver
#  xvfb-run -a python3 "${WORKSPACE}/turnstile_solver/main.py"
fi
