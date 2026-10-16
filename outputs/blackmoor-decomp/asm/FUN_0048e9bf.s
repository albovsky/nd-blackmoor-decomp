# FUN_0048e9bf
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0048e9bf
# extent:       0x0048e9bf-0x0048ea24 (101 code bytes)
# span:         0x0048e9bf-0x0048ea24 (code 101, tables 0, padding 0)
# sha256:       037410bd37f0966fe2d3c70841ce59fe67d3715154ac45321425a545d5a3cd7f
# evidence:     ev_7981f36fcfb340c87ff1ac4ba66e833832bd1313751938cee07fade4f0082dcf
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0048e9bf
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       3 ebp-relative slot(s): local_4, local_8, local_c
# fields:       [eax + n] field_1e; [edx + n] field_b0, field_46a
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 30 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ field_1e, 0x1e  # offset +0x1e
.equ field_b0, 0xb0  # offset +0xb0
.equ field_46a, 0x46a  # offset +0x46a

# --- external targets -----------------------------------------------

.org 0x0048e9bf - 0x401000
.globl FUN_0048e9bf
FUN_0048e9bf:
    # block 0x0048e9bf: entry, 11 instruction(s), ends with forward jump to 0x0048e9f2
    push ebp                                     # 0048e9bf
    {load} mov ebp, esp                          # 0048e9c0
    sub esp, 0xc                                 # 0048e9c2
    mov dword ptr [ebp - local_c], ecx           # 0048e9c5
    mov eax, dword ptr [ebp - local_c]           # 0048e9c8
    movsx ecx, word ptr [eax + field_1e]         # 0048e9cb
    imul ecx, ecx, 0x8d                          # 0048e9cf
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 0048e9d5
    mov dword ptr [ebp - local_8], edx           # 0048e9db
    mov word ptr [ebp - local_4], 0x0            # 0048e9de
    jmp.d8 L_0048e9f2                            # 0048e9e4
L_0048e9e6:
    # block 0x0048e9e6: entered by jmp at 0x0048ea19, 3 instruction(s), falls into the block at 0x0048e9f2
    mov ax, word ptr [ebp - local_4]             # 0048e9e6
    .insn 0x66, 0x05, 0x0001{:u16}               # 0048e9ea
    mov word ptr [ebp - local_4], ax             # 0048e9ee
L_0048e9f2:
    # block 0x0048e9f2: entered by jmp at 0x0048e9e4, 5 instruction(s), ends with jge to 0x0048ea1b (forward)
    movsx ecx, word ptr [ebp - local_4]          # 0048e9f2
    mov edx, dword ptr [ebp - local_8]           # 0048e9f6
    movsx eax, word ptr [edx + field_b0]         # 0048e9f9
    {load} cmp ecx, eax                          # 0048ea00
    jge.d8 L_0048ea1b                            # 0048ea02
    # block 0x0048ea04: entered by fall-through of jge at 0x0048ea02, 4 instruction(s), ends with je to 0x0048ea19 (forward)
    movsx ecx, word ptr [ebp - local_4]          # 0048ea04
    mov edx, dword ptr [ebp - local_c]           # 0048ea08
    cmp dword ptr [edx + 4*ecx + field_46a], 0x1 # 0048ea0b
    je.d8 L_0048ea19                             # 0048ea13
    # block 0x0048ea15: entered by fall-through of je at 0x0048ea13, 2 instruction(s), ends with forward jump to 0x0048ea20
    {load} xor eax, eax                          # 0048ea15
    jmp.d8 L_0048ea20                            # 0048ea17
L_0048ea19:
    # block 0x0048ea19: entered by je at 0x0048ea13, 1 instruction(s), ends with backward jump to 0x0048e9e6
    jmp.d8 L_0048e9e6                            # 0048ea19
L_0048ea1b:
    # block 0x0048ea1b: entered by jge at 0x0048ea02, 1 instruction(s), falls into the block at 0x0048ea20
    mov eax, 0x1                                 # 0048ea1b
L_0048ea20:
    # block 0x0048ea20: entered by jmp at 0x0048ea17, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 0048ea20
    pop ebp                                      # 0048ea22
    ret                                          # 0048ea23

