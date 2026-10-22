# FUN_004921a1
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004921a1
# extent:       0x004921a1-0x004922f4 (339 code bytes)
# span:         0x004921a1-0x004922f4 (code 339, tables 0, padding 0)
# sha256:       b52e71c260d83642fe9887e53943c96f6361bc8ce8918c55c9b20ba7243ca5b1
# evidence:     ev_da254f3c66057fe0ecb1916012a485119a4ff6d747553eb5fd7a4bf04258f342
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4921a1_lifted
# naming:       native port src/original_methods_fl39d.c:m4921a1_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Machine-translated from the instruction stream by the FL-39 lifter (11 recipes, original bytes run under Unicorn; golden vectors in the direct test); Not original source structure. All instructions run; both jump directions taken.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_20, field_2c, field_4771, field_4775, field_4779, field_477d, field_4781, field_4785, field_4791, field_479d, field_47a5; [ecx + n] field_28, field_4779, field_4781, field_4785, field_478d, field_4791, field_4799, field_479d; [edx + n] field_24, field_4771, field_4775, field_4779, field_477d, field_4781, field_4785, field_4789, field_4791, field_4799, field_47a1
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl39d.c:m4921a1_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 85 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_20, 0x20  # offset +0x20
.equ field_24, 0x24  # offset +0x24
.equ field_28, 0x28  # offset +0x28
.equ field_2c, 0x2c  # offset +0x2c
.equ field_4771, 0x4771  # offset +0x4771
.equ field_4775, 0x4775  # offset +0x4775
.equ field_4779, 0x4779  # offset +0x4779
.equ field_477d, 0x477d  # offset +0x477d
.equ field_4781, 0x4781  # offset +0x4781
.equ field_4785, 0x4785  # offset +0x4785
.equ field_4789, 0x4789  # offset +0x4789
.equ field_478d, 0x478d  # offset +0x478d
.equ field_4791, 0x4791  # offset +0x4791
.equ field_4799, 0x4799  # offset +0x4799
.equ field_479d, 0x479d  # offset +0x479d
.equ field_47a1, 0x47a1  # offset +0x47a1
.equ field_47a5, 0x47a5  # offset +0x47a5

# --- external targets -----------------------------------------------

.org 0x004921a1 - 0x401000
.globl FUN_004921a1
FUN_004921a1:
    # block 0x004921a1: entry, 85 instruction(s), ends with ret
    push ebp                                     # 004921a1
    {load} mov ebp, esp                          # 004921a2
    push ecx                                     # 004921a4
    mov dword ptr [ebp - local_4], ecx           # 004921a5
    mov eax, dword ptr [ebp - local_4]           # 004921a8
    mov ecx, dword ptr [eax + field_4791]        # 004921ab
    shl ecx, 0x4                                 # 004921b1
    mov edx, dword ptr [ebp - local_4]           # 004921b4
    mov eax, dword ptr [ebp - local_4]           # 004921b7
    mov ecx, dword ptr [eax + ecx + field_20]    # 004921ba
    mov dword ptr [edx + field_4771], ecx        # 004921be
    mov edx, dword ptr [ebp - local_4]           # 004921c4
    mov eax, dword ptr [edx + field_4791]        # 004921c7
    shl eax, 0x4                                 # 004921cd
    mov ecx, dword ptr [ebp - local_4]           # 004921d0
    mov edx, dword ptr [ebp - local_4]           # 004921d3
    mov eax, dword ptr [edx + eax + field_24]    # 004921d6
    mov dword ptr [ecx + field_4779], eax        # 004921da
    mov ecx, dword ptr [ebp - local_4]           # 004921e0
    mov edx, dword ptr [ecx + field_4791]        # 004921e3
    shl edx, 0x4                                 # 004921e9
    mov eax, dword ptr [ebp - local_4]           # 004921ec
    mov ecx, dword ptr [ebp - local_4]           # 004921ef
    mov edx, dword ptr [ecx + edx + field_28]    # 004921f2
    mov dword ptr [eax + field_4775], edx        # 004921f6
    mov eax, dword ptr [ebp - local_4]           # 004921fc
    mov ecx, dword ptr [eax + field_4791]        # 004921ff
    shl ecx, 0x4                                 # 00492205
    mov edx, dword ptr [ebp - local_4]           # 00492208
    mov eax, dword ptr [ebp - local_4]           # 0049220b
    mov ecx, dword ptr [eax + ecx + field_2c]    # 0049220e
    mov dword ptr [edx + field_477d], ecx        # 00492212
    mov edx, dword ptr [ebp - local_4]           # 00492218
    mov eax, dword ptr [ebp - local_4]           # 0049221b
    mov ecx, dword ptr [edx + field_4775]        # 0049221e
    sub ecx, dword ptr [eax + field_4771]        # 00492224
    mov edx, dword ptr [ebp - local_4]           # 0049222a
    mov dword ptr [edx + field_4781], ecx        # 0049222d
    mov eax, dword ptr [ebp - local_4]           # 00492233
    mov ecx, dword ptr [ebp - local_4]           # 00492236
    mov edx, dword ptr [eax + field_477d]        # 00492239
    sub edx, dword ptr [ecx + field_4779]        # 0049223f
    mov eax, dword ptr [ebp - local_4]           # 00492245
    mov dword ptr [eax + field_4785], edx        # 00492248
    mov ecx, dword ptr [ebp - local_4]           # 0049224e
    mov edx, dword ptr [ecx + field_4785]        # 00492251
    sar edx                                      # 00492257
    mov eax, dword ptr [ebp - local_4]           # 00492259
    mov ecx, dword ptr [eax + field_4779]        # 0049225c
    {load} add ecx, edx                          # 00492262
    mov edx, dword ptr [ebp - local_4]           # 00492264
    mov dword ptr [edx + field_4789], ecx        # 00492267
    mov eax, dword ptr [ebp - local_4]           # 0049226d
    mov ecx, dword ptr [eax + field_4781]        # 00492270
    sar ecx                                      # 00492276
    mov edx, dword ptr [ebp - local_4]           # 00492278
    mov eax, dword ptr [edx + field_4771]        # 0049227b
    {load} add eax, ecx                          # 00492281
    mov ecx, dword ptr [ebp - local_4]           # 00492283
    mov dword ptr [ecx + field_478d], eax        # 00492286
    mov edx, dword ptr [ebp - local_4]           # 0049228c
    mov eax, dword ptr [0x58318a]                # 0049228f
    add eax, dword ptr [edx + field_4779]        # 00492294
    mov ecx, dword ptr [ebp - local_4]           # 0049229a
    mov dword ptr [ecx + field_479d], eax        # 0049229d
    mov edx, dword ptr [ebp - local_4]           # 004922a3
    mov eax, dword ptr [0x583186]                # 004922a6
    add eax, dword ptr [edx + field_4771]        # 004922ab
    mov ecx, dword ptr [ebp - local_4]           # 004922b1
    mov dword ptr [ecx + field_4799], eax        # 004922b4
    mov edx, dword ptr [ebp - local_4]           # 004922ba
    mov eax, dword ptr [edx + field_4799]        # 004922bd
    mov ecx, dword ptr [ebp - local_4]           # 004922c3
    add eax, dword ptr [ecx + field_4781]        # 004922c6
    mov edx, dword ptr [ebp - local_4]           # 004922cc
    mov dword ptr [edx + field_47a1], eax        # 004922cf
    mov eax, dword ptr [ebp - local_4]           # 004922d5
    mov ecx, dword ptr [eax + field_479d]        # 004922d8
    mov edx, dword ptr [ebp - local_4]           # 004922de
    add ecx, dword ptr [edx + field_4785]        # 004922e1
    mov eax, dword ptr [ebp - local_4]           # 004922e7
    mov dword ptr [eax + field_47a5], ecx        # 004922ea
    {load} mov esp, ebp                          # 004922f0
    pop ebp                                      # 004922f2
    ret                                          # 004922f3

