"""Tests for the A-62 requested-rectangle candidate and accept reducers."""

from __future__ import annotations

import ctypes as c
import subprocess
import unittest
from pathlib import Path


PROJECT = Path(__file__).resolve().parents[1]
LIBRARY = PROJECT / "build/libactionfamily62interaction.dylib"

OK = 0
ERR_ARGUMENT = 1
ERR_COUNT = 2
UNSUPPORTED = 3


class Target(c.Structure):
    _fields_ = [
        ("request_pending", c.c_uint32),
        ("response_words", c.c_int16 * 4),
    ]


class ScanInput(c.Structure):
    _fields_ = [
        ("targets", c.POINTER(Target)),
        ("target_count", c.c_size_t),
        ("coordinate_a", c.c_int32),
        ("coordinate_b", c.c_int32),
        ("reserved_index_a", c.c_int32),
        ("reserved_index_b", c.c_int32),
        ("cursor_command", c.c_int32),
    ]


class ScanResult(c.Structure):
    _fields_ = [
        ("candidate_action_index", c.c_int32),
        ("candidate_found", c.c_uint8),
        ("candidate_route", c.c_uint8),
    ]


class AcceptInput(c.Structure):
    _fields_ = [
        ("candidate_action_index", c.c_int32),
        ("suppression_value", c.c_int32),
        ("action_control_word_at_plus_0x30", c.c_int32),
        ("dependency_ready", c.c_int32),
        ("dependency_child_index", c.c_int32),
    ]


class AcceptResult(c.Structure):
    _fields_ = [
        ("candidate_considered", c.c_uint8),
        ("dependency_check_required", c.c_uint8),
        ("phase2_requested", c.c_uint8),
        ("child_request_required", c.c_uint8),
        ("dependency_feedback_required", c.c_uint8),
        ("child_index", c.c_int32),
    ]


class NavigateInput(c.Structure):
    _fields_ = [
        ("navigation_allowed", c.c_uint32),
        ("selector_command", c.c_int32),
        ("selector", c.c_int16),
        ("step", c.c_int16),
        ("selector_min", c.c_int16),
        ("selector_max", c.c_int16),
        ("wrap_mode", c.c_int16),
        ("reserved", c.c_int16),
        ("scene_mode", c.c_int32),
    ]


class NavigateResult(c.Structure):
    _fields_ = [
        ("selector_after", c.c_int16),
        ("selector_written", c.c_uint8),
    ]


def make_target(request: int, response_words=(10, 20, 30, 40)) -> Target:
    target = Target()
    target.request_pending = request
    target.response_words[:] = response_words
    return target


class ActionFamily62InteractionTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        subprocess.run(
            ["sh", str(PROJECT / "scripts/build_action_family_62_interaction.sh")],
            check=True,
        )
        cls.lib = c.CDLL(str(LIBRARY))
        cls.lib.action_family_62_interaction_scan.argtypes = [
            c.POINTER(ScanInput), c.POINTER(ScanResult)
        ]
        cls.lib.action_family_62_interaction_scan.restype = c.c_int
        cls.lib.action_family_62_interaction_accept.argtypes = [
            c.POINTER(AcceptInput), c.POINTER(AcceptResult)
        ]
        cls.lib.action_family_62_interaction_accept.restype = c.c_int
        cls.lib.action_family_62_interaction_navigate.argtypes = [
            c.POINTER(NavigateInput), c.POINTER(NavigateResult)
        ]
        cls.lib.action_family_62_interaction_navigate.restype = c.c_int

    def scan(self, targets, *, coordinate_a=20, coordinate_b=20,
             reserved=(-1, -1), cursor_command=0):
        storage = (Target * len(targets))(*targets)
        input_value = ScanInput(
            storage, len(targets), coordinate_a, coordinate_b,
            reserved[0], reserved[1], cursor_command
        )
        result = ScanResult()
        status = self.lib.action_family_62_interaction_scan(
            c.byref(input_value), c.byref(result)
        )
        return status, result, storage

    def accept(self, candidate, *, suppression=0, control=0,
               dependency_ready=0, child=-1):
        input_value = AcceptInput(
            candidate, suppression, control, dependency_ready, child
        )
        result = AcceptResult()
        status = self.lib.action_family_62_interaction_accept(
            c.byref(input_value), c.byref(result)
        )
        return status, result

    def navigate(self, command, *, selector=8, step=1, minimum=0, maximum=9,
                 wrap_mode=0, scene_mode=0, allowed=True):
        input_value = NavigateInput(
            int(allowed), command, selector, step, minimum, maximum,
            wrap_mode, 0, scene_mode
        )
        result = NavigateResult()
        status = self.lib.action_family_62_interaction_navigate(
            c.byref(input_value), c.byref(result)
        )
        return status, result

    def test_scan_uses_inclusive_original_word_order_and_first_action(self):
        targets = [
            make_target(1, (10, 21, 30, 40)),
            make_target(1),
            make_target(1),
        ]
        status, result, _storage = self.scan(
            targets, coordinate_a=20, coordinate_b=30
        )
        self.assertEqual(status, OK)
        self.assertEqual((result.candidate_found, result.candidate_action_index), (1, 1))

    def test_scan_keeps_reserved_rectangle_candidates_and_tags_the_route(self):
        targets = [make_target(1), make_target(0), make_target(1)]
        status, result, _storage = self.scan(targets, reserved=(0, 2))
        self.assertEqual(status, OK)
        self.assertEqual((result.candidate_found, result.candidate_action_index), (1, 0))
        self.assertEqual(result.candidate_route, 2)

        targets[0] = make_target(0)
        targets[2] = make_target(1)
        status, result, _storage = self.scan(targets, reserved=(0, 2))
        self.assertEqual(status, OK)
        self.assertEqual((result.candidate_found, result.candidate_action_index), (1, 2))
        self.assertEqual(result.candidate_route, 3)

    def test_scan_rejects_nonzero_cursor_command_and_outside_coordinates(self):
        targets = [make_target(1)]
        for kwargs in (
            {"cursor_command": 2},
            {"coordinate_a": 41},
            {"coordinate_b": 9},
        ):
            with self.subTest(kwargs=kwargs):
                status, result, _storage = self.scan(targets, **kwargs)
                self.assertEqual(status, OK)
                self.assertEqual((result.candidate_found, result.candidate_action_index), (0, -1))

    def test_scan_invalid_input_leaves_result_unchanged(self):
        result = ScanResult(123, 0x5A, 0x33)
        before = c.string_at(c.byref(result), c.sizeof(result))
        invalid = ScanInput(None, 1, 0, 0, -1, -1, 0)
        status = self.lib.action_family_62_interaction_scan(
            c.byref(invalid), c.byref(result)
        )
        self.assertEqual(status, ERR_ARGUMENT)
        self.assertEqual(c.string_at(c.byref(result), c.sizeof(result)), before)

        invalid.targets = c.cast(c.c_void_p(1), c.POINTER(Target))
        invalid.target_count = c.c_size_t(2**31 + 1).value + 1
        status = self.lib.action_family_62_interaction_scan(
            c.byref(invalid), c.byref(result)
        )
        self.assertEqual(status, ERR_COUNT)
        self.assertEqual(c.string_at(c.byref(result), c.sizeof(result)), before)

    def test_accept_control_zero_requests_phase2_without_dependency_query(self):
        status, result = self.accept(
            0, control=0, dependency_ready=0, child=-1
        )
        self.assertEqual(status, OK)
        self.assertEqual(result.candidate_considered, 1)
        self.assertEqual(result.dependency_check_required, 0)
        self.assertEqual(result.phase2_requested, 1)
        self.assertEqual(result.child_request_required, 0)
        self.assertEqual(result.dependency_feedback_required, 0)

    def test_accept_dependency_ready_returns_phase_and_nonnegative_child(self):
        status, result = self.accept(
            239, control=1, dependency_ready=1, child=4
        )
        self.assertEqual(status, OK)
        self.assertEqual(result.candidate_considered, 1)
        self.assertEqual(result.dependency_check_required, 1)
        self.assertEqual(result.phase2_requested, 1)
        self.assertEqual((result.child_request_required, result.child_index), (1, 4))
        self.assertEqual(result.dependency_feedback_required, 0)

    def test_accept_preserves_original_negative_child_edge_and_rejection_effect(self):
        status, result = self.accept(
            0, control=1, dependency_ready=1, child=-2
        )
        self.assertEqual(status, OK)
        self.assertEqual(result.phase2_requested, 1)
        self.assertEqual(result.child_request_required, 0)

        status, result = self.accept(
            0, control=1, dependency_ready=0, child=4
        )
        self.assertEqual(status, OK)
        self.assertEqual(result.phase2_requested, 0)
        self.assertEqual(result.dependency_feedback_required, 1)

        status, result = self.accept(
            0, control=1, dependency_ready=1, child=-1
        )
        self.assertEqual(status, OK)
        self.assertEqual(result.phase2_requested, 0)
        self.assertEqual(result.dependency_feedback_required, 1)

    def test_accept_rejects_candidate_bound_and_suppression_gate(self):
        for candidate, suppression in ((-1, 0), (240, 0), (0, 1)):
            with self.subTest(candidate=candidate, suppression=suppression):
                status, result = self.accept(
                    candidate, suppression=suppression, control=0
                )
                self.assertEqual(status, OK)
                self.assertEqual(result.candidate_considered, 0)
                self.assertEqual(result.phase2_requested, 0)

    def test_navigation_add_wrap_modes_and_unknown_mode(self):
        cases = ((0, 9), (1, 0), (2, 9), (3, 10))
        for wrap_mode, expected in cases:
            with self.subTest(wrap_mode=wrap_mode):
                status, result = self.navigate(
                    1, selector=8, step=2, wrap_mode=wrap_mode
                )
                self.assertEqual(status, OK)
                self.assertEqual((result.selector_written, result.selector_after),
                                 (1, expected))

    def test_navigation_subtract_wrap_modes_and_unknown_mode(self):
        cases = ((0, 0), (1, 9), (2, 0), (3, -2))
        for wrap_mode, expected in cases:
            with self.subTest(wrap_mode=wrap_mode):
                status, result = self.navigate(
                    2, selector=0, step=2, wrap_mode=wrap_mode
                )
                self.assertEqual(status, OK)
                self.assertEqual((result.selector_written, result.selector_after),
                                 (1, expected))

    def test_navigation_uses_16_bit_wrapped_result_before_signed_compare(self):
        status, result = self.navigate(
            1, selector=32767, step=1, minimum=-100, maximum=100, wrap_mode=3
        )
        self.assertEqual(status, OK)
        self.assertEqual((result.selector_written, result.selector_after), (1, -32768))

    def test_navigation_gates_noop_commands_and_reports_unrecovered_paths(self):
        for command, allowed, scene_mode, expected_status, expected_written in (
            (1, False, 0, OK, 0),
            (0, True, 0, OK, 0),
            (9, True, 0, OK, 0),
            (3, True, 0, UNSUPPORTED, 0),
            (1, True, 2, UNSUPPORTED, 0),
            (2, True, 5, UNSUPPORTED, 0),
        ):
            with self.subTest(command=command, allowed=allowed, scene_mode=scene_mode):
                status, result = self.navigate(
                    command, selector=7, allowed=allowed, scene_mode=scene_mode
                )
                self.assertEqual(status, expected_status)
                self.assertEqual(result.selector_written, expected_written)
                self.assertEqual(result.selector_after, 7)


if __name__ == "__main__":
    unittest.main()
