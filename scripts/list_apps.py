#!/usr/bin/env python3
# ~/.config/quickshell/scripts/list_apps.py
#
# Lists desktop applications (system/user/flatpak exports) as TSV.
# Intended for Quickshell launcher ingestion.
#
# Output columns (TSV):
# id, name, generic_name, comment, exec, try_exec, path, icon, terminal,
# startup_wm_class, dbus_activatable, categories, keywords, mime_types
#
# Notes:
# - Only [Desktop Entry] Type=Application entries are included
# - Hidden=true and NoDisplay=true are excluded
# - Dedupe is by desktop-id (filename without .desktop); first match wins
# - Exec is not sanitized here; sanitize in QML when launching (strip %U etc.)

from __future__ import annotations

import os
import sys
import glob
import configparser
from dataclasses import dataclass
from typing import Optional, List, Dict, Tuple


DESKTOP_DIRS = [
    "/usr/share/applications",
    os.path.expanduser("~/.local/share/applications"),
    "/var/lib/flatpak/exports/share/applications",
    os.path.expanduser("~/.local/share/flatpak/exports/share/applications"),
]


@dataclass
class App:
    app_id: str
    name: str
    generic_name: str
    comment: str
    exec: str
    try_exec: str
    path: str
    icon: str
    terminal: bool
    startup_wm_class: str
    dbus_activatable: bool
    categories: List[str]
    keywords: List[str]
    mime_types: List[str]


def _split_semicolon_list(value: str) -> List[str]:
    # Desktop spec lists are semicolon-separated, may end with trailing ';'
    parts = [p.strip() for p in value.split(";")]
    return [p for p in parts if p]


def _read_desktop_entry(desktop_path: str) -> Optional[Dict[str, str]]:
    cp = configparser.ConfigParser(interpolation=None, strict=False)

    try:
        with open(desktop_path, "r", encoding="utf-8", errors="ignore") as f:
            cp.read_file(f)
    except Exception:
        return None

    if "Desktop Entry" not in cp:
        return None

    entry = cp["Desktop Entry"]

    # Only applications
    if entry.get("Type", "Application").strip() != "Application":
        return None

    # Skip hidden entries
    if entry.get("Hidden", "false").strip().lower() == "true":
        return None
    if entry.get("NoDisplay", "false").strip().lower() == "true":
        return None

    # Must have Name and Exec
    name = entry.get("Name", "").strip()
    exec_ = entry.get("Exec", "").strip()
    if not name or not exec_:
        return None

    # Optional fields
    generic = entry.get("GenericName", "").strip()
    comment = entry.get("Comment", "").strip()
    icon = entry.get("Icon", "").strip()
    try_exec = entry.get("TryExec", "").strip()
    path = entry.get("Path", "").strip()
    terminal = entry.get("Terminal", "false").strip().lower() == "true"
    startup_wm_class = entry.get("StartupWMClass", "").strip()
    dbus_activatable = entry.get("DBusActivatable", "false").strip().lower() == "true"

    categories = _split_semicolon_list(entry.get("Categories", ""))
    keywords = _split_semicolon_list(entry.get("Keywords", ""))
    mime_types = _split_semicolon_list(entry.get("MimeType", ""))

    return {
        "Name": name,
        "GenericName": generic,
        "Comment": comment,
        "Exec": exec_,
        "TryExec": try_exec,
        "Path": path,
        "Icon": icon,
        "Terminal": "true" if terminal else "false",
        "StartupWMClass": startup_wm_class,
        "DBusActivatable": "true" if dbus_activatable else "false",
        "Categories": "|".join(categories),
        "Keywords": "|".join(keywords),
        "MimeType": "|".join(mime_types),
    }


def _desktop_id_from_path(p: str) -> str:
    base = os.path.basename(p)
    if base.endswith(".desktop"):
        return base[:-8]
    return base


def collect_apps() -> List[App]:
    seen: set[str] = set()
    apps: List[App] = []

    for d in DESKTOP_DIRS:
        if not os.path.isdir(d):
            continue

        for desktop_path in glob.glob(os.path.join(d, "*.desktop")):
            app_id = _desktop_id_from_path(desktop_path)
            if app_id in seen:
                continue

            entry = _read_desktop_entry(desktop_path)
            if not entry:
                continue

            seen.add(app_id)

            def g(k: str) -> str:
                return entry.get(k, "") or ""

            apps.append(
                App(
                    app_id=app_id,
                    name=g("Name"),
                    generic_name=g("GenericName"),
                    comment=g("Comment"),
                    exec=g("Exec"),
                    try_exec=g("TryExec"),
                    path=g("Path"),
                    icon=g("Icon"),
                    terminal=(g("Terminal").lower() == "true"),
                    startup_wm_class=g("StartupWMClass"),
                    dbus_activatable=(g("DBusActivatable").lower() == "true"),
                    categories=(g("Categories").split("|") if g("Categories") else []),
                    keywords=(g("Keywords").split("|") if g("Keywords") else []),
                    mime_types=(g("MimeType").split("|") if g("MimeType") else []),
                )
            )

    # Sort by visible name
    apps.sort(key=lambda a: a.name.casefold())
    return apps


def print_tsv(apps: List[App]) -> None:
    # Header is optional; keep it disabled for easiest parsing in QML.
    # Uncomment if you want it:
    # print("id\tname\tgeneric_name\tcomment\texec\ttry_exec\tpath\ticon\tterminal\tstartup_wm_class\tdbus_activatable\tcategories\tkeywords\tmime_types")

    for a in apps:
        row = [
            a.app_id,
            a.name,
            a.generic_name,
            a.comment,
            a.exec,
            a.try_exec,
            a.path,
            a.icon,
            "true" if a.terminal else "false",
            a.startup_wm_class,
            "true" if a.dbus_activatable else "false",
            "|".join(a.categories),
            "|".join(a.keywords),
            "|".join(a.mime_types),
        ]
        # Make sure no tabs/newlines leak into TSV
        row = [x.replace("\t", " ").replace("\n", " ").replace("\r", " ") for x in row]
        print("\t".join(row))


def main() -> int:
    apps = collect_apps()
    print_tsv(apps)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
