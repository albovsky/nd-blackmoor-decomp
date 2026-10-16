# FUN_0050b0e0
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0050b0e0
# extent:       0x0050b0e0-0x0050b13a (90 code bytes)
# span:         0x0050b0e0-0x0050b140 (code 90, tables 0, padding 6)
# sha256:       e9a7561c0cc14a0d55263df336466c6baebff16d9dd66180c69b28c35a1bb28c
# evidence:     ev_14398f730fa9c49e7db80307b54fbb5d04baa803ce1c29895906ff2fa90b272c
# region:       vorbis
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0050b0e0
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       1 ebp-relative slot(s): local_8
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 30 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_8, 0x8  # offset -0x8
.equ arg_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------

.org 0x0050b0e0 - 0x401000
.globl FUN_0050b0e0
FUN_0050b0e0:
    # block 0x0050b0e0: entry, 12 instruction(s), ends with jge to 0x0050b10f (forward)
    push ebp                                     # 0050b0e0
    {load} mov ebp, esp                          # 0050b0e1
    sub esp, 0x8                                 # 0050b0e3
    fld dword ptr [ebp + arg_8]                  # 0050b0e6
    fmul dword ptr [0x52e660]                    # 0050b0e9
    fsub dword ptr [0x52cd14]                    # 0050b0ef
    fstp qword ptr [ebp - local_8]               # 0050b0f5
    fld qword ptr [ebp - local_8]                # 0050b0f8
    fistp dword ptr [ebp + arg_8]                # 0050b0fb
    mov eax, dword ptr [ebp + arg_8]             # 0050b0fe
    test eax, eax                                # 0050b101
    jge.d8 L_0050b10f                            # 0050b103
    # block 0x0050b105: entered by fall-through of jge at 0x0050b103, 4 instruction(s), ends with ret
    fld dword ptr [0x52cbf4]                     # 0050b105
    {load} mov esp, ebp                          # 0050b10b
    pop ebp                                      # 0050b10d
    ret                                          # 0050b10e
L_0050b10f:
    # block 0x0050b10f: entered by jge at 0x0050b103, 2 instruction(s), ends with jl to 0x0050b120 (forward)
    cmp eax, 0x460                               # 0050b10f
    jl.d8 L_0050b120                             # 0050b114
    # block 0x0050b116: entered by fall-through of jl at 0x0050b114, 4 instruction(s), ends with ret
    fld dword ptr [0x52db78]                     # 0050b116
    {load} mov esp, ebp                          # 0050b11c
    pop ebp                                      # 0050b11e
    ret                                          # 0050b11f
L_0050b120:
    # block 0x0050b120: entered by jl at 0x0050b114, 8 instruction(s), ends with ret
    {load} mov ecx, eax                          # 0050b120
    and ecx, 0x1f                                # 0050b122
    sar eax, 0x5                                 # 0050b125
    fld dword ptr [4*ecx + 0x5672f4]             # 0050b128
    fmul dword ptr [4*eax + 0x567268]            # 0050b12f
    {load} mov esp, ebp                          # 0050b136
    pop ebp                                      # 0050b138
    ret                                          # 0050b139

# --- data items (not part of the function) -------------------------
.org 0x0050b13a - 0x401000
PAD_0050b13a:  # 6 byte(s) of nop padding
    .fill 6, 1, 0x90

