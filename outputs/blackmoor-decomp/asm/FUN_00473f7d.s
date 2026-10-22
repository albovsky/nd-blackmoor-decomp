# FUN_00473f7d
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00473f7d
# extent:       0x00473f7d-0x00473ffc (127 code bytes)
# span:         0x00473f7d-0x00473ffc (code 127, tables 0, padding 0)
# sha256:       9bc1288f56495485c2306a65a20fe4caf155f243f24465f1ab302da222ee0c36
# evidence:     ev_4142f99cf250975ea00b2347f810409c5bbf0cca5348258d5fd0578a4530c136
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m473f7d_lifted
# naming:       native port src/original_methods_fl40.c:m473f7d_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-22); the note is the acceptance note, a statement about the native port
# name-note:    Machine translation of the original instructions (scripts/lift_function.py) over the 32-bit address space, 2 seeds; oracle: 33/33 instructions executed, 6/6 conditional-jump directions taken, callees as recording stubs.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       [eax + n] field_371; [edx + n] field_4
# callees:      calls FUN_004752cd
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl40.c:m473f7d_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 33 instruction(s), 3 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ field_4, 0x4  # offset +0x4
.equ field_371, 0x371  # offset +0x371

# --- external targets -----------------------------------------------
.set FUN_004752cd, .text + (0x004752cd - 0x401000)

.org 0x00473f7d - 0x401000
.globl FUN_00473f7d
FUN_00473f7d:
    # block 0x00473f7d: entry, 6 instruction(s), ends with forward jump to 0x00473f98
    push ebp                                     # 00473f7d
    {load} mov ebp, esp                          # 00473f7e
    sub esp, 0x8                                 # 00473f80
    mov dword ptr [ebp - local_8], ecx           # 00473f83
    mov dword ptr [ebp - local_4], 0x0           # 00473f86
    jmp.d8 L_00473f98                            # 00473f8d
L_00473f8f:
    # block 0x00473f8f: entered by jmp at 0x00473ff6, 3 instruction(s), falls into the block at 0x00473f98
    mov eax, dword ptr [ebp - local_4]           # 00473f8f
    add eax, 0x1                                 # 00473f92
    mov dword ptr [ebp - local_4], eax           # 00473f95
L_00473f98:
    # block 0x00473f98: entered by jmp at 0x00473f8d, 2 instruction(s), ends with jge to 0x00473ff8 (forward)
    cmp dword ptr [ebp - local_4], 0x4           # 00473f98
    jge.d8 L_00473ff8                            # 00473f9c
    # block 0x00473f9e: entered by fall-through of jge at 0x00473f9c, 3 instruction(s), ends with jne to 0x00473ff6 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 00473f9e
    cmp dword ptr [4*ecx + 0x5a4b4e], 0x0        # 00473fa1
    jne.d8 L_00473ff6                            # 00473fa9
    # block 0x00473fab: entered by fall-through of jne at 0x00473fa9, 3 instruction(s), ends with je to 0x00473ff6 (forward)
    mov edx, dword ptr [ebp - local_4]           # 00473fab
    cmp dword ptr [4*edx + 0x5a4bbe], 0x0        # 00473fae
    je.d8 L_00473ff6                             # 00473fb6
    # block 0x00473fb8: entered by fall-through of je at 0x00473fb6, 12 instruction(s), calls FUN_004752cd, falls into the block at 0x00473ff6
    {load} xor eax, eax                          # 00473fb8
    mov ecx, dword ptr [ebp - local_4]           # 00473fba
    lea edx, [8*ecx + 0x5a4b9e]                  # 00473fbd
    mov dword ptr [edx], eax                     # 00473fc4
    mov dword ptr [edx + field_4], eax           # 00473fc6
    mov eax, dword ptr [ebp - local_8]           # 00473fc9
    mov dword ptr [eax + field_371], 0x1         # 00473fcc
    mov dword ptr [0x5a4bce], 0xffffffff         # 00473fd6
    mov ecx, dword ptr [ebp - local_4]           # 00473fe0
    mov dword ptr [4*ecx + 0x5a4bbe], 0x0        # 00473fe3
    mov ecx, dword ptr [ebp - local_8]           # 00473fee
    call FUN_004752cd                            # 00473ff1
L_00473ff6:
    # block 0x00473ff6: entered by jne at 0x00473fa9; je at 0x00473fb6, 1 instruction(s), ends with backward jump to 0x00473f8f
    jmp.d8 L_00473f8f                            # 00473ff6
L_00473ff8:
    # block 0x00473ff8: entered by jge at 0x00473f9c, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 00473ff8
    pop ebp                                      # 00473ffa
    ret                                          # 00473ffb

