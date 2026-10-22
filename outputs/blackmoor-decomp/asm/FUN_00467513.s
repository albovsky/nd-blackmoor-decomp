# FUN_00467513
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00467513
# extent:       0x00467513-0x00467608 (245 code bytes)
# span:         0x00467513-0x00467608 (code 245, tables 0, padding 0)
# sha256:       683153bfbf75a2365e4c2013d654bf0b427bd6dc4c9f4cc382d9f8e46866c4da
# evidence:     ev_b2266c122d0c3ebc240ee0b3dabe442ef76e91098e7869f9f9749891192d3067
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m467513_lifted
# naming:       native port src/original_methods_fl40.c:m467513_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-22); the note is the acceptance note, a statement about the native port
# name-note:    Machine-translated from the original instructions (scripts/lift_function.py); 1 seeds; oracle 51/51 instructions, 0/0 jump directions; mutation survivors: tasks/fl40-survivors.json.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_8, field_1ae, field_1ba, field_248, field_254, field_260; [ecx + n] field_10, field_1b2, field_1be, field_24c, field_258; [edx + n] field_4, field_1b6, field_240, field_250, field_25c
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl40.c:m467513_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 51 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_4, 0x4  # offset +0x4
.equ field_8, 0x8  # offset +0x8
.equ field_10, 0x10  # offset +0x10
.equ field_1ae, 0x1ae  # offset +0x1ae
.equ field_1b2, 0x1b2  # offset +0x1b2
.equ field_1b6, 0x1b6  # offset +0x1b6
.equ field_1ba, 0x1ba  # offset +0x1ba
.equ field_1be, 0x1be  # offset +0x1be
.equ field_240, 0x240  # offset +0x240
.equ field_248, 0x248  # offset +0x248
.equ field_24c, 0x24c  # offset +0x24c
.equ field_250, 0x250  # offset +0x250
.equ field_254, 0x254  # offset +0x254
.equ field_258, 0x258  # offset +0x258
.equ field_25c, 0x25c  # offset +0x25c
.equ field_260, 0x260  # offset +0x260

# --- external targets -----------------------------------------------

.org 0x00467513 - 0x401000
.globl FUN_00467513
FUN_00467513:
    # block 0x00467513: entry, 51 instruction(s), ends with ret
    push ebp                                     # 00467513
    {load} mov ebp, esp                          # 00467514
    push ecx                                     # 00467516
    push edi                                     # 00467517
    mov dword ptr [ebp - local_4], ecx           # 00467518
    mov eax, dword ptr [ebp - local_4]           # 0046751b
    mov word ptr [eax + field_8], 0xffff         # 0046751e
    mov ecx, dword ptr [ebp - local_4]           # 00467524
    mov word ptr [ecx + field_10], 0xffff        # 00467527
    mov edx, dword ptr [ebp - local_4]           # 0046752d
    mov dword ptr [edx + field_4], 0x0           # 00467530
    mov eax, dword ptr [ebp - local_4]           # 00467537
    mov dword ptr [eax + field_1ae], 0x0         # 0046753a
    mov ecx, dword ptr [ebp - local_4]           # 00467544
    mov dword ptr [ecx + field_1b2], 0x0         # 00467547
    mov edx, dword ptr [ebp - local_4]           # 00467551
    mov dword ptr [edx + field_1b6], 0x0         # 00467554
    mov eax, dword ptr [ebp - local_4]           # 0046755e
    mov dword ptr [eax + field_1ba], 0xffffffff  # 00467561
    mov ecx, dword ptr [ebp - local_4]           # 0046756b
    mov word ptr [ecx + field_1be], 0x0          # 0046756e
    mov edx, dword ptr [ebp - local_4]           # 00467577
    mov dword ptr [edx + field_240], 0x0         # 0046757a
    mov eax, dword ptr [ebp - local_4]           # 00467584
    mov dword ptr [eax + field_248], 0x0         # 00467587
    mov ecx, dword ptr [ebp - local_4]           # 00467591
    mov dword ptr [ecx + field_24c], 0x0         # 00467594
    mov edx, dword ptr [ebp - local_4]           # 0046759e
    mov dword ptr [edx + field_250], 0x0         # 004675a1
    mov eax, dword ptr [ebp - local_4]           # 004675ab
    mov dword ptr [eax + field_254], 0x0         # 004675ae
    mov ecx, dword ptr [ebp - local_4]           # 004675b8
    mov dword ptr [ecx + field_258], 0x0         # 004675bb
    mov edx, dword ptr [ebp - local_4]           # 004675c5
    mov dword ptr [edx + field_25c], 0x0         # 004675c8
    mov eax, dword ptr [ebp - local_4]           # 004675d2
    mov dword ptr [eax + field_260], 0x0         # 004675d5
    mov ecx, 0x11                                # 004675df
    {load} xor eax, eax                          # 004675e4
    mov edi, dword ptr [ebp - local_4]           # 004675e6
    add edi, 0x278                               # 004675e9
    rep stosd dword ptr es:[edi], eax            # 004675ef
    mov ecx, 0x11                                # 004675f1
    {load} xor eax, eax                          # 004675f6
    mov edi, dword ptr [ebp - local_4]           # 004675f8
    add edi, 0x2bc                               # 004675fb
    rep stosd dword ptr es:[edi], eax            # 00467601
    pop edi                                      # 00467603
    {load} mov esp, ebp                          # 00467604
    pop ebp                                      # 00467606
    ret                                          # 00467607

