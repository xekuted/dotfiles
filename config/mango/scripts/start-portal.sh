#!/bin/bash
if ! systemctl --user is-active --quiet xdg-portal-main.service; then
  systemd-run --user --collect --unit=xdg-portal-main /usr/libexec/xdg-desktop-portal >/dev/null 2>&1
fi