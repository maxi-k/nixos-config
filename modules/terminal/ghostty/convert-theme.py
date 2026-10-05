"""Translate the shared Alacritty TOML palette into a Ghostty config fragment."""

import sys
import tomllib


def convert(theme):
    colors = theme["colors"]
    primary = colors["primary"]
    foreground = primary["foreground"]
    background = primary["background"]
    cursor = colors.get("cursor", {})
    selection = colors.get("selection", {})
    search = colors.get("search", {})
    matches = search.get("matches", {})
    focused = search.get("focused_match", {})

    def color(value):
        value = {"CellForeground": foreground, "CellBackground": background}.get(value, value)
        return "#" + value.removeprefix("0x").removeprefix("#")

    settings = {
        "background": background,
        "foreground": foreground,
        "cursor-color": cursor.get("cursor", foreground),
        "cursor-text": cursor.get("text", background),
        "selection-background": selection.get("background", foreground),
        "selection-foreground": selection.get("text", background),
        "search-background": matches.get("background", foreground),
        "search-foreground": matches.get("foreground", background),
        "search-selected-background": focused.get("background", foreground),
        "search-selected-foreground": focused.get("foreground", background),
    }
    lines = [f"{key} = {color(value)}" for key, value in settings.items()]
    names = ("black", "red", "green", "yellow", "blue", "magenta", "cyan", "white")
    for group, offset in (("normal", 0), ("bright", 8)):
        for index, name in enumerate(names, offset):
            if name in colors.get(group, {}):
                lines.append(f"palette = {index}={color(colors[group][name])}")
    for entry in colors.get("indexed_colors", []):
        lines.append(f"palette = {entry['index']}={color(entry['color'])}")
    return "\n".join(lines) + "\n"


if __name__ == "__main__":
    with open(sys.argv[1], "rb") as source:
        print(convert(tomllib.load(source)), end="")
