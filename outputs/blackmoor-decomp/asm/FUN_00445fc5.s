# FUN_00445fc5
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00445fc5
# extent:       0x00445fc5-0x00446075 (176 code bytes)
# span:         0x00445fc5-0x00446075 (code 176, tables 0, padding 0)
# sha256:       86dfcb44ff104d6a79cc97f10f6bb6655120a348bc56f96d783f9605f6d95dc1
# evidence:     ev_d8af1f64874eb3e8469c17e0baf09bf0097f1882284f135b85877e988363a520
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         std_reset_clock
# naming:       native port src/score_time_display.c:std_reset_clock (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-18); the summary is the acceptance note
# summary:      1:1 with std_reset_clock (zeroes +8, +0x10, +0xb4/+0xb8, +0x240/+0x244, string first bytes, tables +0x64/+0x8c, block +0x174). Field-per-offset model.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_8, field_b8, field_248, field_270; [ecx + n] field_10, field_240, field_252; [edx + n] field_b4, field_244, field_266
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/score_time_display.c:std_reset_clock (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 44 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and summary are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_8, 0x8  # offset +0x8
.equ field_10, 0x10  # offset +0x10
.equ field_b4, 0xb4  # offset +0xb4
.equ field_b8, 0xb8  # offset +0xb8
.equ field_240, 0x240  # offset +0x240
.equ field_244, 0x244  # offset +0x244
.equ field_248, 0x248  # offset +0x248
.equ field_252, 0x252  # offset +0x252
.equ field_266, 0x266  # offset +0x266
.equ field_270, 0x270  # offset +0x270

# --- external targets -----------------------------------------------

.org 0x00445fc5 - 0x401000
.globl FUN_00445fc5
FUN_00445fc5:
    # block 0x00445fc5: entry, 44 instruction(s), ends with ret
    push ebp                                     # 00445fc5
    {load} mov ebp, esp                          # 00445fc6
    push ecx                                     # 00445fc8
    push edi                                     # 00445fc9
    mov dword ptr [ebp - local_4], ecx           # 00445fca
    mov eax, dword ptr [ebp - local_4]           # 00445fcd
    mov dword ptr [eax + field_8], 0x0           # 00445fd0
    mov ecx, dword ptr [ebp - local_4]           # 00445fd7
    mov dword ptr [ecx + field_10], 0x0          # 00445fda
    mov edx, dword ptr [ebp - local_4]           # 00445fe1
    mov dword ptr [edx + field_b4], 0x0          # 00445fe4
    mov eax, dword ptr [ebp - local_4]           # 00445fee
    mov dword ptr [eax + field_b8], 0x0          # 00445ff1
    mov ecx, dword ptr [ebp - local_4]           # 00445ffb
    mov dword ptr [ecx + field_240], 0x0         # 00445ffe
    mov edx, dword ptr [ebp - local_4]           # 00446008
    mov dword ptr [edx + field_244], 0x0         # 0044600b
    mov eax, dword ptr [ebp - local_4]           # 00446015
    mov byte ptr [eax + field_248], 0x0          # 00446018
    mov ecx, dword ptr [ebp - local_4]           # 0044601f
    mov byte ptr [ecx + field_252], 0x0          # 00446022
    mov edx, dword ptr [ebp - local_4]           # 00446029
    mov byte ptr [edx + field_266], 0x0          # 0044602c
    mov eax, dword ptr [ebp - local_4]           # 00446033
    mov byte ptr [eax + field_270], 0x0          # 00446036
    mov ecx, 0xa                                 # 0044603d
    {load} xor eax, eax                          # 00446042
    mov edi, dword ptr [ebp - local_4]           # 00446044
    add edi, 0x64                                # 00446047
    rep stosd dword ptr es:[edi], eax            # 0044604a
    mov ecx, 0xa                                 # 0044604c
    {load} xor eax, eax                          # 00446051
    mov edi, dword ptr [ebp - local_4]           # 00446053
    add edi, 0x8c                                # 00446056
    rep stosd dword ptr es:[edi], eax            # 0044605c
    mov ecx, 0x32                                # 0044605e
    {load} xor eax, eax                          # 00446063
    mov edi, dword ptr [ebp - local_4]           # 00446065
    add edi, 0x174                               # 00446068
    rep stosd dword ptr es:[edi], eax            # 0044606e
    pop edi                                      # 00446070
    {load} mov esp, ebp                          # 00446071
    pop ebp                                      # 00446073
    ret                                          # 00446074

