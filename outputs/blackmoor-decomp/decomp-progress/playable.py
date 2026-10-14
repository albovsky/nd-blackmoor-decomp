"""Public playable evidence contract and source-derived action coverage.

No game assets, native objects or private evidence are read here. Source
recognition is deliberately narrow: changed registration syntax must be
reviewed instead of silently producing an incomplete handled list.
"""

from __future__ import annotations

import hashlib
import json
import re
from pathlib import Path

SCHEMA = "blackmoor-playable-status/2"
LIVE_ARGS = ["--inspect-live-session", "--live-click-row", "34", "--live-ticks", "3000"]
PROVIDERS = {
    "none", "world-clock", "timer-effects", "post-clock-controller", "scene-media",
    "pointer-input-transform", "action-ui", "action-sound", "caption", "action-family-28",
    "action-family-62", "action-kernel", "dependency-provider", "scene-resource",
    "host-adapter", "unknown-provider",
}


class PlayableError(ValueError):
    pass


def read_json(path: Path):
    try:
        return json.loads(path.read_text(encoding="utf-8"))
    except (OSError, ValueError) as exc:
        raise PlayableError(f"cannot read {path.name}: {exc}") from exc


def test_totals(status: dict) -> dict:
    """Prefer the latest committed integration run over the legacy top-level run."""
    if not isinstance(status, dict):
        raise PlayableError("status.json must be an object")
    integration = status.get("current_integration", {})
    if not isinstance(integration, dict):
        raise PlayableError("invalid integration status")
    field = "current_integration.full_suite" if "full_suite" in integration else "tests"
    totals = integration.get("full_suite") if field != "tests" else status.get("tests")
    if not isinstance(totals, dict):
        raise PlayableError("status.json has no committed test totals")
    result = {key: totals.get(key) for key in ("discovered", "passed", "skipped")}
    validate_totals(result)
    return {**result, "source_field": field}


def validate_totals(totals):
    if any(type(totals.get(k)) is not int or totals[k] < 0
           for k in ("discovered", "passed", "skipped")):
        raise PlayableError("test totals must be nonnegative integers")
    if totals["passed"] + totals["skipped"] > totals["discovered"]:
        raise PlayableError("test totals exceed discovered tests")


def validate_status(value: dict) -> dict:
    """Strict keys keep raw log text and resource fields out of the public file."""
    def keys(obj, expected, name):
        if not isinstance(obj, dict) or set(obj) != set(expected.split()):
            raise PlayableError(f"{name}: unexpected or missing fields")

    def scene(s):
        return isinstance(s, str) and re.fullmatch(r"S(?:0|[1-9][0-9]{0,4})", s)

    keys(value, "schema evidence reached_scenes stop ticks tests next_blocker", "playable status")
    if value["schema"] != SCHEMA:
        raise PlayableError(f"playable schema must be {SCHEMA}")
    ev = value["evidence"]
    keys(ev, "kind source_ref native_sha256 command registration_sources", "evidence")
    if not isinstance(ev["kind"], str) or ev["kind"] not in {"scripted_live_session", "seeded_committed_integration"}:
        raise PlayableError("unknown playable evidence kind")
    if not isinstance(ev["source_ref"], str) or not re.fullmatch(r"[0-9a-f]{40}", ev["source_ref"]):
        raise PlayableError("invalid source commit")
    if ev["native_sha256"] is not None and (
            not isinstance(ev["native_sha256"], str) or
            not re.fullmatch(r"[0-9a-f]{64}", ev["native_sha256"])):
        raise PlayableError("invalid native executable hash")
    if ev["kind"] == "scripted_live_session" and ev["native_sha256"] is None:
        raise PlayableError("live evidence needs its native executable hash")
    if ev["command"] != LIVE_ARGS:
        raise PlayableError("playable evidence must use the pinned live command")
    sources = ev["registration_sources"]
    if not isinstance(sources, list) or not sources:
        raise PlayableError("evidence needs registration source hashes")
    paths = []
    for source in sources:
        keys(source, "path sha256", "registration source")
        if (not isinstance(source["path"], str) or not re.fullmatch(
                r"src/[a-z][a-z0-9_]{0,63}\.(?:c|h|mm)|action-census-current\.json", source["path"])):
            raise PlayableError("invalid registration source path")
        if not isinstance(source["sha256"], str) or not re.fullmatch(r"[0-9a-f]{64}", source["sha256"]):
            raise PlayableError("invalid registration source hash")
        paths.append(source["path"])
    if len(set(paths)) != len(paths):
        raise PlayableError("duplicate registration source")
    reached = value["reached_scenes"]
    if not isinstance(reached, list) or not reached or any(not scene(s) for s in reached):
        raise PlayableError("invalid reached scenes")
    if len(set(reached)) != len(reached):
        raise PlayableError("reached scenes must list first visits only")
    if type(value["ticks"]) is not int or value["ticks"] < 0:
        raise PlayableError("invalid tick count")
    stop = value["stop"]
    keys(stop, "kind scene target_scene row action_type provider reason", "stop")
    if not isinstance(stop["kind"], str) or stop["kind"] not in {"scene_transition_error", "scene_session_blocked", "tick_limit"}:
        raise PlayableError("invalid stop kind")
    if not scene(stop["scene"]) or stop["scene"] not in reached:
        raise PlayableError("stop scene must have been reached")
    if stop["target_scene"] is not None and not scene(stop["target_scene"]):
        raise PlayableError("invalid target scene")
    if stop["row"] is not None and (type(stop["row"]) is not int or not 0 <= stop["row"] < 2**32):
        raise PlayableError("invalid action row")
    if stop["action_type"] is not None and (
            not isinstance(stop["action_type"], str) or
            not re.fullmatch(r"0x[0-9a-f]{2}", stop["action_type"])):
        raise PlayableError("invalid action type")
    if stop["provider"] is not None and (not isinstance(stop["provider"], str) or stop["provider"] not in PROVIDERS):
        raise PlayableError("invalid provider")
    if not isinstance(stop["reason"], str) or not re.fullmatch(r"[a-z][a-z0-9-]{0,63}", stop["reason"]):
        raise PlayableError("invalid stop reason")
    keys(value["tests"], "discovered passed skipped source_field", "tests")
    validate_totals(value["tests"])
    if (not isinstance(value["tests"]["source_field"], str) or
            value["tests"]["source_field"] not in {"tests", "current_integration.full_suite"}):
        raise PlayableError("invalid test source field")
    if not isinstance(value["next_blocker"], str) or not 0 < len(value["next_blocker"]) <= 240:
        raise PlayableError("invalid next blocker")
    if any(ord(c) < 32 for c in value["next_blocker"]):
        raise PlayableError("invalid next blocker characters")
    return value


def strip_comments(text):
    return re.sub(r"/\*.*?\*/|//[^\n]*", "", text, flags=re.S)


def braced(text, start):
    depth = 0
    for i in range(start, len(text)):
        if text[i] == "{":
            depth += 1
        elif text[i] == "}":
            depth -= 1
            if depth == 0:
                return text[start + 1:i]
    raise PlayableError("source registration block is unterminated")


def function(text, name):
    match = re.search(r"\b" + re.escape(name) + r"\s*\([^;{}]*\)\s*\{", text)
    if not match:
        raise PlayableError(f"source function not found: {name}")
    body = braced(text, match.end() - 1)
    if re.search(r"^\s*#\s*(?:if|ifdef|ifndef|elif|else)\b", body, re.M):
        raise PlayableError(f"preprocessor conditional in scanned function: {name}")
    return body


def registration_matches(text, pattern, depth=0):
    """Accept only the reviewed lexical scope of a registration site.

    Literal text cannot introduce braces or control words. A deeper block or
    an unbraced if/else requires review; it must not become live coverage.
    Parser cases have depth one (the switch); installed bindings have zero.
    """
    text = re.sub(r'"(?:\\.|[^"\\])*"|\'(?:\\.|[^\'\\])*\'',
                  lambda m: " " * len(m[0]), text)
    matches = list(re.finditer(pattern, text))
    for match in matches:
        before = text[:match.start()]
        prefix = re.split(r"[;{}]", before)[-1]
        if before.count("{") - before.count("}") != depth or re.search(r"\b(?:if|else)\b", prefix):
            raise PlayableError("conditional registration; review source syntax")
    return matches


class Sources:
    def __init__(self, out: Path):
        self.out = out
        self.used = {}

    def read(self, path):
        p = self.out / path
        try:
            raw = p.read_bytes()
        except OSError as exc:
            raise PlayableError(f"missing source: {path}") from exc
        self.used[path] = hashlib.sha256(raw).hexdigest()
        return strip_comments(raw.decode("utf-8"))

    def constant(self, token, unit):
        if re.fullmatch(r"0x[0-9a-fA-F]+[uU]?|[0-9]+[uU]?", token):
            return int(token.rstrip("uU"), 0)
        candidates = [self.out / unit, *sorted((self.out / "src").glob("*.h"))]
        pattern = (r"(?:\b" + re.escape(token) + r"\s*=\s*|^\s*#define\s+" +
                   re.escape(token) + r"\s+)(?:UINT8_C\()?([A-Za-z_][A-Za-z_0-9]*|0x[0-9a-fA-F]+|[0-9]+)\)?\b")
        for p in candidates:
            path = p.relative_to(self.out).as_posix()
            text = self.read(path)
            m = re.search(pattern, text, re.M)
            if m:
                if m[1] == token:
                    break
                return self.constant(m[1], path)
        raise PlayableError(f"cannot resolve registered action type {token}")


def derive_actions(out: Path) -> dict:
    src = Sources(out)
    parser = function(src.read("src/scene_resource.c"), "known_body_length")
    typed = {int(m[1], 16) for m in registration_matches(parser, r"\bcase\s+(0x[0-9a-fA-F]+)\s*:", 1)}
    if not typed:
        raise PlayableError("no parser registrations found")
    executor = src.read("src/scene_executor.c")
    core_tokens = [m[1] for m in registration_matches(function(executor, "is_action_core_type"), r"\btype\s*==\s*(\w+)")]
    core = {src.constant(t, "src/scene_executor.c") for t in core_tokens}
    kernel = function(src.read("src/action_core.c"), "is_supported_type")
    if core != {src.constant(m[1], "src/action_core.c") for m in registration_matches(kernel, r"\btype\s*==\s*(\w+)")}:
        raise PlayableError("executor and action_core registrations drifted")
    runtime_map = function(executor, "action_runtime_type")
    raw = re.findall(r"action->type\s*==\s*(\w+)", runtime_map)
    runtime = re.findall(r"return\s+(SCENE_ACTION_\w+)\s*;", runtime_map)
    if len(raw) != 1 or len(runtime) != 1:
        raise PlayableError("review the executor raw/runtime type mapping")
    aliases = {src.constant(runtime[0], "src/scene_executor.c"):
               src.constant(raw[0], "src/scene_executor.c")}
    hotspot = {src.constant(m[1], "src/scene_executor.c") for m in registration_matches(
        function(executor, "is_builtin_hotspot"), r"runtime_type\s*==\s*(\w+)")}
    builtins = core | {aliases.get(t, t) for t in hotspot}
    dispatch = function(executor, "scene_executor_step_frame")
    # Count actual dispatch branches; the sound dependency reset is not a handler.
    for m in registration_matches(dispatch, r"if\s*\(action\.type\s*==\s*(\w+)\)\s*\{", 1):
        if "++local_info.actions_applied" in braced(dispatch, m.end() - 1):
            builtins.add(src.constant(m[1], "src/scene_executor.c"))
    session = function(src.read("src/scene_session.c"), "scene_session_create")
    registration_matches(session, r"session->bindings\[\w+\]\.(?:present|provider|callback|context)\s*=")
    ui_tokens = re.findall(r"session->bindings\[(\w+)\]\.callback\s*=\s*ui_action_handler\s*;", session)
    ui = {src.constant(t, "src/scene_session.c") for t in ui_tokens}
    present = {src.constant(t, "src/scene_session.c") for t in re.findall(
        r"session->bindings\[(\w+)\]\.present\s*=\s*1u\s*;", session)}
    if ui != present:
        raise PlayableError("session UI callbacks and present slots drifted")
    reserved = {src.constant(t, "src/scene_session.c") for t in re.findall(r"binding->type\s*==\s*(\w+)", session)}
    if reserved != builtins | ui:
        raise PlayableError("executor and session reserved registrations drifted")
    app = src.read("src/blackmoor_app.mm")
    live = function(app, "create_native_scene_session")
    registration_matches(live, r"(?:\w+(?:\[\d+\])?\.(?:type|provider|callback|context)|"
                               r"bindings\[\d+\]|config\.action_bindings|config\.action_binding_count)\s*=")
    registrations = re.findall(r"(\w+(?:\[\d+\])?)\.type\s*=\s*(\w+)\s*;", live)
    declared = re.search(r"SceneSessionActionBinding\s+bindings\[(\d+)\]", live)
    count = re.search(r"config\.action_binding_count\s*=\s*(\d+)u?\s*;", live)
    if (not declared or not count or int(declared[1]) != int(count[1]) or
            len(registrations) != int(count[1]) or
            not re.search(r"config\.action_bindings\s*=\s*bindings\s*;", live)):
        raise PlayableError("live binding count drifted; review registration syntax")
    slots = set(re.findall(r"bindings\[(\d+)\]\s*=|bindings\[(\d+)\]\.type\s*=", live))
    if {int(a or b) for a, b in slots} != set(range(int(count[1]))):
        raise PlayableError("live binding slots are incomplete")
    external = {}
    for binding, token in registrations:
        code = src.constant(token, "src/blackmoor_app.mm")
        callback = re.search(re.escape(binding) + r"\.callback\s*=\s*(\w+)\s*;", live)
        if not callback or code in external or code in builtins | ui:
            raise PlayableError("invalid live action binding")
        if "[" not in binding and not re.search(r"bindings\[\d+\]\s*=\s*" + re.escape(binding) + r"\s*;", live):
            raise PlayableError("declared live action binding is not installed")
        cb = callback[1]
        if cb.startswith("session_"):
            matches = [p for p in sorted((out / "src").glob("session_bindings_*.c"))
                       if re.search(r"\b" + re.escape(cb) + r"\s*\([^;{}]*\)\s*\{",
                                    src.read(p.relative_to(out).as_posix()))]
            if len(matches) != 1:
                raise PlayableError(f"missing or ambiguous session handler: {cb}")
            function(src.read(matches[0].relative_to(out).as_posix()), cb)
        else:
            function(app, cb)
        external[code] = cb
    if not (builtins | ui | set(external)) <= typed:
        raise PlayableError("a live handler has no typed parser registration")
    census = read_json(out / "action-census-current.json")
    rows = census["by_raw_type"]
    counts = {int(r["type"], 16): r["count"] for r in rows}
    if (len(counts) != len(rows) or sum(counts.values()) != census["actions"] or
            any(type(n) is not int or n <= 0 for n in counts.values()) or
            any(not 0 <= t <= 255 for t in counts)):
        raise PlayableError("invalid census record counts")
    if sum(r["typed"] for r in rows) != census["typed_actions"] or sum(r["opaque"] for r in rows) != census["opaque_actions"]:
        raise PlayableError("invalid census snapshot totals")
    if any(r["typed"] + r["opaque"] != r["count"] for r in rows):
        raise PlayableError("invalid census type totals")
    handled = builtins | ui | set(external)
    code = lambda t: f"0x{t:02x}"
    summary = lambda types: {"types": [code(t) for t in sorted(types)],
                             "type_count": len(types), "records": sum(counts[t] for t in types)}
    observed = set(counts)
    return {
        "scene_total": census["scenes"], "record_total": census["actions"],
        "type_total": len(observed),
        "typed": summary(observed & typed), "opaque": summary(observed - typed),
        "handled": summary(observed & handled),
        "unsupported": summary((observed & typed) - handled),
        "registrations": {"executor": [code(t) for t in sorted(builtins)],
                          "session_ui": [code(t) for t in sorted(ui)],
                          "external": {code(t): cb for t, cb in sorted(external.items())}},
        "census_snapshot": {"typed_records": census["typed_actions"],
                            "opaque_records": census["opaque_actions"]},
        "sources": [{"path": p, "sha256": h} for p, h in sorted(src.used.items())] +
                   [{"path": "action-census-current.json", "sha256": hashlib.sha256(
                       (out / "action-census-current.json").read_bytes()).hexdigest()}],
    }


def build_panel(out: Path, status: dict) -> dict:
    path = out / "playable-status.json"
    evidence = validate_status(read_json(path))
    if evidence["tests"] != test_totals(status):
        raise PlayableError("playable test totals drifted from status.json; rerun the recorder")
    actions = derive_actions(out)
    if evidence["evidence"]["registration_sources"] != actions["sources"]:
        raise PlayableError("evidence stale; rerun record_playable_status.py")
    if evidence["stop"]["action_type"] in actions["handled"]["types"]:
        raise PlayableError("stop action is handled by current source; rerun record_playable_status.py")
    if len(evidence["reached_scenes"]) > actions["scene_total"]:
        raise PlayableError("reached scenes exceed the corpus")
    return {**evidence, "scene_total": actions.pop("scene_total"), "action_types": actions,
            "test_source_ref": status.get("current_integration", {}).get("source_ref")
                if evidence["tests"]["source_field"] == "current_integration.full_suite" else None,
            "status_sha256": hashlib.sha256(path.read_bytes()).hexdigest()}
