# FUN_0047ba79
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0047ba79
# extent:       0x0047ba79-0x0047badf (102 code bytes)
# span:         0x0047ba79-0x0047badf (code 102, tables 0, padding 0)
# sha256:       e277cc203bbbc5b9f1a3415eb30322da07a658f7a49acb508c2b6b7e5a904f84
# evidence:     ev_827db53a64242b59e9f92d38aeb544549dfa70f780a54958ee5eb67fb48784ea
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m47ba79_expire_links
# naming:       native port src/original_methods_fl31a.c:m47ba79_expire_links (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-20); the note is the acceptance note, a statement about the native port
# name-note:    When the gate is set and the (unsigned) tick count is above [self+0x38], clears [[self+0x1c]+4], [[self+0x20]+4] and four fields of self; every instruction and jump direction executed.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_4, field_1c, field_34, field_38; [ecx + n] field_20, field_38; [edx + n] field_4, field_1c, field_34
# callees:      calls KERNEL32.dll!GetTickCount
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl31a.c:m47ba79_expire_links (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 29 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_4, 0x4  # offset +0x4
.equ field_1c, 0x1c  # offset +0x1c
.equ field_20, 0x20  # offset +0x20
.equ field_34, 0x34  # offset +0x34
.equ field_38, 0x38  # offset +0x38

# --- external targets -----------------------------------------------

.org 0x0047ba79 - 0x401000
.globl FUN_0047ba79
FUN_0047ba79:
    # block 0x0047ba79: entry, 7 instruction(s), ends with jne to 0x0047ba8b (forward)
    push ebp                                     # 0047ba79
    {load} mov ebp, esp                          # 0047ba7a
    push ecx                                     # 0047ba7c
    mov dword ptr [ebp - local_4], ecx           # 0047ba7d
    mov eax, dword ptr [ebp - local_4]           # 0047ba80
    cmp dword ptr [eax + field_34], 0x0          # 0047ba83
    jne.d8 L_0047ba8b                            # 0047ba87
    # block 0x0047ba89: entered by fall-through of jne at 0x0047ba87, 1 instruction(s), ends with forward jump to 0x0047badb
    jmp.d8 L_0047badb                            # 0047ba89
L_0047ba8b:
    # block 0x0047ba8b: entered by jne at 0x0047ba87, 4 instruction(s), calls KERNEL32.dll!GetTickCount, ends with jbe to 0x0047badb (forward)
    call dword ptr [0x52a23c]                    # 0047ba8b
    mov ecx, dword ptr [ebp - local_4]           # 0047ba91
    cmp eax, dword ptr [ecx + field_38]          # 0047ba94
    jbe.d8 L_0047badb                            # 0047ba97
    # block 0x0047ba99: entered by fall-through of jbe at 0x0047ba97, 14 instruction(s), falls into the block at 0x0047badb
    mov edx, dword ptr [ebp - local_4]           # 0047ba99
    mov eax, dword ptr [edx + field_1c]          # 0047ba9c
    mov dword ptr [eax + field_4], 0x0           # 0047ba9f
    mov ecx, dword ptr [ebp - local_4]           # 0047baa6
    mov edx, dword ptr [ecx + field_20]          # 0047baa9
    mov dword ptr [edx + field_4], 0x0           # 0047baac
    mov eax, dword ptr [ebp - local_4]           # 0047bab3
    mov dword ptr [eax + field_1c], 0x0          # 0047bab6
    mov ecx, dword ptr [ebp - local_4]           # 0047babd
    mov dword ptr [ecx + field_20], 0x0          # 0047bac0
    mov edx, dword ptr [ebp - local_4]           # 0047bac7
    mov dword ptr [edx + field_34], 0x0          # 0047baca
    mov eax, dword ptr [ebp - local_4]           # 0047bad1
    mov dword ptr [eax + field_38], 0x0          # 0047bad4
L_0047badb:
    # block 0x0047badb: entered by jmp at 0x0047ba89; jbe at 0x0047ba97, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 0047badb
    pop ebp                                      # 0047badd
    ret                                          # 0047bade

