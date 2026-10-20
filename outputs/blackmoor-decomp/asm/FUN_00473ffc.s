# FUN_00473ffc
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00473ffc
# extent:       0x00473ffc-0x0047409e (162 code bytes)
# span:         0x00473ffc-0x0047409e (code 162, tables 0, padding 0)
# sha256:       7b9efe3cd9a0f47be555142f86e3ef25c49e1b99ee7df21719949299f6b36300
# evidence:     ev_4142f99cf250975ea00b2347f810409c5bbf0cca5348258d5fd0578a4530c136
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m473ffc_click_27a1
# naming:       native port src/original_methods_fl23b.c:m473ffc_click_27a1 (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-19); the summary is the acceptance note
# summary:      1:1 with m473ffc_click_27a1 (guards, record-state compare, selector arms, callees via host). Direct: matrix and arms. Unicorn differential and oracle: 224 fixtures, every instruction reached. See tasks/fl23b-handoff.md.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_c, field_7e; [ecx + n] field_7a, field_7e; [edx + n] field_c, field_10, field_76, field_82
# callees:      calls FUN_004e26fc
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl23b.c:m473ffc_click_27a1 (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 44 instruction(s), 7 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and summary are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_c, 0xc  # offset +0xc
.equ field_10, 0x10  # offset +0x10
.equ field_76, 0x76  # offset +0x76
.equ field_7a, 0x7a  # offset +0x7a
.equ field_7e, 0x7e  # offset +0x7e
.equ field_82, 0x82  # offset +0x82

# --- external targets -----------------------------------------------
.set FUN_004e26fc, .text + (0x004e26fc - 0x401000)

.org 0x00473ffc - 0x401000
.globl FUN_00473ffc
FUN_00473ffc:
    # block 0x00473ffc: entry, 13 instruction(s), ends with je to 0x0047409a (forward)
    push ebp                                     # 00473ffc
    {load} mov ebp, esp                          # 00473ffd
    push ecx                                     # 00473fff
    mov dword ptr [ebp - local_4], ecx           # 00474000
    mov eax, dword ptr [ebp - local_4]           # 00474003
    movsx ecx, word ptr [eax + field_c]          # 00474006
    imul ecx, ecx, 0x8d                          # 0047400a
    mov edx, dword ptr [ebp - local_4]           # 00474010
    mov eax, dword ptr [ecx + 0x5bb5e5]          # 00474013
    mov dword ptr [edx + field_76], eax          # 00474019
    mov ecx, dword ptr [ebp - local_4]           # 0047401c
    cmp dword ptr [ecx + field_7a], 0x0          # 0047401f
    je.d8 L_0047409a                             # 00474023
    # block 0x00474025: entered by fall-through of je at 0x00474023, 3 instruction(s), ends with jne to 0x0047409a (forward)
    mov edx, dword ptr [ebp - local_4]           # 00474025
    cmp dword ptr [edx + field_10], 0x0          # 00474028
    jne.d8 L_0047409a                            # 0047402c
    # block 0x0047402e: entered by fall-through of jne at 0x0047402c, 5 instruction(s), ends with jne to 0x0047409a (forward)
    mov eax, dword ptr [ebp - local_4]           # 0047402e
    movsx ecx, word ptr [eax + field_c]          # 00474031
    imul ecx, ecx, 0x8d                          # 00474035
    cmp dword ptr [ecx + 0x5bb632], 0x1          # 0047403b
    jne.d8 L_0047409a                            # 00474042
    # block 0x00474044: entered by fall-through of jne at 0x00474042, 3 instruction(s), ends with jne to 0x0047409a (forward)
    mov edx, dword ptr [ebp - local_4]           # 00474044
    cmp dword ptr [edx + field_82], 0x0          # 00474047
    jne.d8 L_0047409a                            # 0047404e
    # block 0x00474050: entered by fall-through of jne at 0x0047404e, 3 instruction(s), ends with jne to 0x0047409a (forward)
    mov eax, dword ptr [ebp - local_4]           # 00474050
    cmp dword ptr [eax + field_7e], 0x0          # 00474053
    jne.d8 L_0047409a                            # 00474057
    # block 0x00474059: entered by fall-through of jne at 0x00474057, 5 instruction(s), calls FUN_004e26fc, ends with je to 0x0047406d (forward)
    mov ecx, dword ptr [ebp - local_4]           # 00474059
    add ecx, 0x1a6                               # 0047405c
    call FUN_004e26fc                            # 00474062
    test eax, eax                                # 00474067
    je.d8 L_0047406d                             # 00474069
    # block 0x0047406b: entered by fall-through of je at 0x00474069, 1 instruction(s), ends with forward jump to 0x0047409a
    jmp.d8 L_0047409a                            # 0047406b
L_0047406d:
    # block 0x0047406d: entered by je at 0x00474069, 2 instruction(s), ends with jne to 0x0047409a (forward)
    cmp dword ptr [0x5c39e5], 0x27a1             # 0047406d
    jne.d8 L_0047409a                            # 00474077
    # block 0x00474079: entered by fall-through of jne at 0x00474077, 6 instruction(s), falls into the block at 0x0047409a
    mov ecx, dword ptr [ebp - local_4]           # 00474079
    mov dword ptr [ecx + field_7e], 0x1          # 0047407c
    mov edx, dword ptr [ebp - local_4]           # 00474083
    movsx eax, word ptr [edx + field_c]          # 00474086
    imul eax, eax, 0x8d                          # 0047408a
    mov dword ptr [eax + 0x5bb632], 0x2          # 00474090
L_0047409a:
    # block 0x0047409a: entered by je at 0x00474023; jne at 0x0047402c; jne at 0x00474042; jne at 0x0047404e; more, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 0047409a
    pop ebp                                      # 0047409c
    ret                                          # 0047409d

