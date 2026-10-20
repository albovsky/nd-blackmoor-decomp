# FUN_004e1a7e
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004e1a7e
# extent:       0x004e1a7e-0x004e1b79 (251 code bytes)
# span:         0x004e1a7e-0x004e1b79 (code 251, tables 0, padding 0)
# sha256:       191e3ff8bcbcb56e5759ae7be12412d67a7ff52958d1d4297ee88733f6a8f04b
# evidence:     ev_8385f85130572c281c3b234a54cbdfd62040e051350169a9d81ca47906b8da6a
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         action_ui_initialize_controls
# naming:       native port src/action_ui.c:action_ui_initialize_controls (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-16); the summary is the acceptance note
# summary:      Native is action_ui_initialize_controls (writes every field the original does; checked by hand on a 0xAA-filled world). Oracle compares it only indirectly, through handler output over 13 cases.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       3 ebp-relative slot(s): local_4, local_8, local_c
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/action_ui.c:action_ui_initialize_controls (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 56 instruction(s), 3 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and summary are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc

# --- external targets -----------------------------------------------

.org 0x004e1a7e - 0x401000
.globl FUN_004e1a7e
FUN_004e1a7e:
    # block 0x004e1a7e: entry, 6 instruction(s), ends with forward jump to 0x004e1a9b
    push ebp                                     # 004e1a7e
    {load} mov ebp, esp                          # 004e1a7f
    sub esp, 0xc                                 # 004e1a81
    mov dword ptr [ebp - local_c], ecx           # 004e1a84
    mov word ptr [ebp - local_4], 0x0            # 004e1a87
    jmp.d8 L_004e1a9b                            # 004e1a8d
L_004e1a8f:
    # block 0x004e1a8f: entered by jmp at 0x004e1b70, 3 instruction(s), falls into the block at 0x004e1a9b
    mov ax, word ptr [ebp - local_4]             # 004e1a8f
    .insn 0x66, 0x05, 0x0001{:u16}               # 004e1a93
    mov word ptr [ebp - local_4], ax             # 004e1a97
L_004e1a9b:
    # block 0x004e1a9b: entered by jmp at 0x004e1a8d, 3 instruction(s), ends with jge to 0x004e1b75 (forward)
    movsx ecx, word ptr [ebp - local_4]          # 004e1a9b
    cmp ecx, 0x5                                 # 004e1a9f
    jge.d32 L_004e1b75                           # 004e1aa2
    # block 0x004e1aa8: entered by fall-through of jge at 0x004e1aa2, 8 instruction(s), ends with forward jump to 0x004e1ae4
    movsx edx, word ptr [ebp - local_4]          # 004e1aa8
    imul edx, edx, 0x1a4                         # 004e1aac
    mov dword ptr [edx + 0x5a1620], 0x0          # 004e1ab2
    movsx eax, word ptr [ebp - local_4]          # 004e1abc
    imul eax, eax, 0x1a4                         # 004e1ac0
    mov dword ptr [eax + 0x5a17b4], 0x0          # 004e1ac6
    mov word ptr [ebp - local_8], 0x0            # 004e1ad0
    jmp.d8 L_004e1ae4                            # 004e1ad6
L_004e1ad8:
    # block 0x004e1ad8: entered by jmp at 0x004e1b06, 3 instruction(s), falls into the block at 0x004e1ae4
    mov cx, word ptr [ebp - local_8]             # 004e1ad8
    add cx, 0x1                                  # 004e1adc
    mov word ptr [ebp - local_8], cx             # 004e1ae0
L_004e1ae4:
    # block 0x004e1ae4: entered by jmp at 0x004e1ad6, 3 instruction(s), ends with jge to 0x004e1b08 (forward)
    movsx edx, word ptr [ebp - local_8]          # 004e1ae4
    cmp edx, 0x3                                 # 004e1ae8
    jge.d8 L_004e1b08                            # 004e1aeb
    # block 0x004e1aed: entered by fall-through of jge at 0x004e1aeb, 5 instruction(s), ends with backward jump to 0x004e1ad8
    movsx eax, word ptr [ebp - local_4]          # 004e1aed
    imul eax, eax, 0x1a4                         # 004e1af1
    movsx ecx, word ptr [ebp - local_8]          # 004e1af7
    mov dword ptr [eax + 4*ecx + 0x5a17b8], 0x0  # 004e1afb
    jmp.d8 L_004e1ad8                            # 004e1b06
L_004e1b08:
    # block 0x004e1b08: entered by jge at 0x004e1aeb, 2 instruction(s), ends with forward jump to 0x004e1b1c
    mov word ptr [ebp - local_8], 0x0            # 004e1b08
    jmp.d8 L_004e1b1c                            # 004e1b0e
L_004e1b10:
    # block 0x004e1b10: entered by jmp at 0x004e1b6e, 3 instruction(s), falls into the block at 0x004e1b1c
    mov dx, word ptr [ebp - local_8]             # 004e1b10
    add dx, 0x1                                  # 004e1b14
    mov word ptr [ebp - local_8], dx             # 004e1b18
L_004e1b1c:
    # block 0x004e1b1c: entered by jmp at 0x004e1b0e, 3 instruction(s), ends with jge to 0x004e1b70 (forward)
    movsx eax, word ptr [ebp - local_8]          # 004e1b1c
    cmp eax, 0x32                                # 004e1b20
    jge.d8 L_004e1b70                            # 004e1b23
    # block 0x004e1b25: entered by fall-through of jge at 0x004e1b23, 13 instruction(s), ends with backward jump to 0x004e1b10
    movsx ecx, word ptr [ebp - local_4]          # 004e1b25
    imul ecx, ecx, 0x1a4                         # 004e1b29
    movsx edx, word ptr [ebp - local_8]          # 004e1b2f
    mov word ptr [ecx + 2*edx + 0x5a1624], 0x270f # 004e1b33
    movsx eax, word ptr [ebp - local_4]          # 004e1b3d
    imul eax, eax, 0x1a4                         # 004e1b41
    movsx ecx, word ptr [ebp - local_8]          # 004e1b47
    mov word ptr [eax + 2*ecx + 0x5a1688], 0x270f # 004e1b4b
    movsx edx, word ptr [ebp - local_4]          # 004e1b55
    imul edx, edx, 0x1a4                         # 004e1b59
    movsx eax, word ptr [ebp - local_8]          # 004e1b5f
    mov dword ptr [edx + 4*eax + 0x5a16ec], 0xd  # 004e1b63
    jmp.d8 L_004e1b10                            # 004e1b6e
L_004e1b70:
    # block 0x004e1b70: entered by jge at 0x004e1b23, 1 instruction(s), ends with backward jump to 0x004e1a8f
    jmp.d32 L_004e1a8f                           # 004e1b70
L_004e1b75:
    # block 0x004e1b75: entered by jge at 0x004e1aa2, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 004e1b75
    pop ebp                                      # 004e1b77
    ret                                          # 004e1b78

