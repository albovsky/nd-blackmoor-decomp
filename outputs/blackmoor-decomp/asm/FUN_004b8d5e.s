# FUN_004b8d5e
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004b8d5e
# extent:       0x004b8d5e-0x004b8e42 (228 code bytes)
# span:         0x004b8d5e-0x004b8e42 (code 228, tables 0, padding 0)
# sha256:       9b27963dfe72a98a83d8405743c0e2f278587652f1fdeb579af1df1d2165953d
# evidence:     ev_0a6ac0edbe5602a7eee9dc902ec1f93eea8bd2aa232e8044e889effe410b6a1d
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4b8d5e_expire_slots
# naming:       native port src/original_methods_fl18.c:m4b8d5e_expire_slots (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-18); the summary is the acceptance note
# summary:      1:1 with m4b8d5e_expire_slots. Direct test: whole objects and ordered host calls. Differential test: original bytes (Unicorn) vs native on the same random fixtures, every instruction reached. Oracle window runs all 228 bytes.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       4 ebp-relative slot(s): local_4, local_8, local_c, local_10
# fields:       [eax + n] field_77, field_173; [ecx + n] field_8, field_48, field_7b, field_7d; [edx + n] field_8, field_48, field_4e9
# callees:      calls KERNEL32.dll!GetTickCount, FUN_004fb2e3, FUN_004b8a27
# track-n:      outputs/blackmoor-decomp/src/action_family_f5_runtime.c:expire_balloons (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 66 instruction(s), 4 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and summary are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10
.equ field_8, 0x8  # offset +0x8
.equ field_48, 0x48  # offset +0x48
.equ field_77, 0x77  # offset +0x77
.equ field_7b, 0x7b  # offset +0x7b
.equ field_7d, 0x7d  # offset +0x7d
.equ field_173, 0x173  # offset +0x173
.equ field_4e9, 0x4e9  # offset +0x4e9

# --- external targets -----------------------------------------------
.set FUN_004b8a27, .text + (0x004b8a27 - 0x401000)
.set FUN_004fb2e3, .text + (0x004fb2e3 - 0x401000)

.org 0x004b8d5e - 0x401000
.globl FUN_004b8d5e
FUN_004b8d5e:
    # block 0x004b8d5e: entry, 9 instruction(s), calls KERNEL32.dll!GetTickCount, ends with forward jump to 0x004b8d8a
    push ebp                                     # 004b8d5e
    {load} mov ebp, esp                          # 004b8d5f
    sub esp, 0x10                                # 004b8d61
    mov dword ptr [ebp - local_10], ecx          # 004b8d64
    mov word ptr [ebp - local_c], 0x0            # 004b8d67
    call dword ptr [0x52a23c]                    # 004b8d6d
    mov dword ptr [ebp - local_8], eax           # 004b8d73
    mov word ptr [ebp - local_4], 0x0            # 004b8d76
    jmp.d8 L_004b8d8a                            # 004b8d7c
L_004b8d7e:
    # block 0x004b8d7e: entered by jmp at 0x004b8e0f, 3 instruction(s), falls into the block at 0x004b8d8a
    mov ax, word ptr [ebp - local_4]             # 004b8d7e
    .insn 0x66, 0x05, 0x0001{:u16}               # 004b8d82
    mov word ptr [ebp - local_4], ax             # 004b8d86
L_004b8d8a:
    # block 0x004b8d8a: entered by jmp at 0x004b8d7c, 6 instruction(s), ends with jge to 0x004b8e14 (forward)
    movsx ecx, word ptr [ebp - local_4]          # 004b8d8a
    mov edx, dword ptr [ebp - local_10]          # 004b8d8e
    mov eax, dword ptr [edx + field_8]           # 004b8d91
    movsx edx, word ptr [eax + field_173]        # 004b8d94
    {load} cmp ecx, edx                          # 004b8d9b
    jge.d8 L_004b8e14                            # 004b8d9d
    # block 0x004b8d9f: entered by fall-through of jge at 0x004b8d9d, 5 instruction(s), ends with jne to 0x004b8e0f (forward)
    movsx eax, word ptr [ebp - local_4]          # 004b8d9f
    imul eax, eax, 0x37                          # 004b8da3
    mov ecx, dword ptr [ebp - local_10]          # 004b8da6
    cmp dword ptr [ecx + eax + field_7d], 0x1    # 004b8da9
    jne.d8 L_004b8e0f                            # 004b8dae
    # block 0x004b8db0: entered by fall-through of jne at 0x004b8dae, 15 instruction(s), ends with jbe to 0x004b8e0f (forward)
    movsx edx, word ptr [ebp - local_4]          # 004b8db0
    imul edx, edx, 0x37                          # 004b8db4
    mov eax, dword ptr [ebp - local_10]          # 004b8db7
    mov ecx, dword ptr [ebp - local_8]           # 004b8dba
    sub ecx, dword ptr [eax + edx + field_77]    # 004b8dbd
    {load} mov eax, ecx                          # 004b8dc1
    {load} xor edx, edx                          # 004b8dc3
    mov ecx, 0x3e8                               # 004b8dc5
    div ecx                                      # 004b8dca
    movsx edx, word ptr [ebp - local_4]          # 004b8dcc
    imul edx, edx, 0x37                          # 004b8dd0
    mov ecx, dword ptr [ebp - local_10]          # 004b8dd3
    movsx edx, word ptr [ecx + edx + field_7b]   # 004b8dd6
    {load} cmp eax, edx                          # 004b8ddb
    jbe.d8 L_004b8e0f                            # 004b8ddd
    # block 0x004b8ddf: entered by fall-through of jbe at 0x004b8ddd, 12 instruction(s), falls into the block at 0x004b8e0f
    movsx eax, word ptr [ebp - local_4]          # 004b8ddf
    imul eax, eax, 0x37                          # 004b8de3
    mov ecx, dword ptr [ebp - local_10]          # 004b8de6
    mov dword ptr [ecx + eax + field_7d], 0x3    # 004b8de9
    mov edx, dword ptr [ebp - local_10]          # 004b8df1
    mov ax, word ptr [edx + field_48]            # 004b8df4
    .insn 0x66, 0x2d, 0x0001{:u16}               # 004b8df8
    mov ecx, dword ptr [ebp - local_10]          # 004b8dfc
    mov word ptr [ecx + field_48], ax            # 004b8dff
    mov dx, word ptr [ebp - local_c]             # 004b8e03
    add dx, 0x1                                  # 004b8e07
    mov word ptr [ebp - local_c], dx             # 004b8e0b
L_004b8e0f:
    # block 0x004b8e0f: entered by jne at 0x004b8dae; jbe at 0x004b8ddd, 1 instruction(s), ends with backward jump to 0x004b8d7e
    jmp.d32 L_004b8d7e                           # 004b8e0f
L_004b8e14:
    # block 0x004b8e14: entered by jge at 0x004b8d9d, 3 instruction(s), ends with jle to 0x004b8e3e (forward)
    movsx eax, word ptr [ebp - local_c]          # 004b8e14
    test eax, eax                                # 004b8e18
    jle.d8 L_004b8e3e                            # 004b8e1a
    # block 0x004b8e1c: entered by fall-through of jle at 0x004b8e1a, 9 instruction(s), calls FUN_004fb2e3, FUN_004b8a27, falls into the block at 0x004b8e3e
    mov ecx, dword ptr [ebp - local_10]          # 004b8e1c
    mov edx, dword ptr [ecx + field_8]           # 004b8e1f
    mov ax, word ptr [edx + field_4e9]           # 004b8e22
    push eax                                     # 004b8e29
    mov ecx, 0x5c3a67                            # 004b8e2a
    call FUN_004fb2e3                            # 004b8e2f
    push 0x2                                     # 004b8e34
    mov ecx, dword ptr [ebp - local_10]          # 004b8e36
    call FUN_004b8a27                            # 004b8e39
L_004b8e3e:
    # block 0x004b8e3e: entered by jle at 0x004b8e1a, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 004b8e3e
    pop ebp                                      # 004b8e40
    ret                                          # 004b8e41

