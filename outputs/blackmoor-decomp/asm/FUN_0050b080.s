# FUN_0050b080
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0050b080
# extent:       0x0050b080-0x0050b0cd (77 code bytes)
# span:         0x0050b080-0x0050b0d0 (code 77, tables 0, padding 3)
# sha256:       93053001002c6307efbdb982b213649d8ef20434dc38bf75e9ffa3f67135e4f5
# evidence:     ev_14398f730fa9c49e7db80307b54fbb5d04baa803ce1c29895906ff2fa90b272c
# region:       vorbis
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0050b080
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       2 ebp-relative slot(s): local_8, local_10
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/his_audio.c:his_audio_decode_memory (function ledger class host_adapter_tested; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 22 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_8, 0x8  # offset -0x8
.equ local_10, 0x10  # offset -0x10
.equ arg_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------

.org 0x0050b080 - 0x401000
.globl FUN_0050b080
FUN_0050b080:
    # block 0x0050b080: entry, 22 instruction(s), ends with ret
    push ebp                                     # 0050b080
    {load} mov ebp, esp                          # 0050b081
    sub esp, 0x10                                # 0050b083
    fld dword ptr [ebp + arg_8]                  # 0050b086
    fmul dword ptr [0x52e65c]                    # 0050b089
    fsub dword ptr [0x52e658]                    # 0050b08f
    fst qword ptr [ebp - local_8]                # 0050b095
    fsub qword ptr [0x52cac0]                    # 0050b098
    fstp qword ptr [ebp - local_10]              # 0050b09e
    fld qword ptr [ebp - local_10]               # 0050b0a1
    fistp dword ptr [ebp + arg_8]                # 0050b0a4
    mov ecx, dword ptr [ebp + arg_8]             # 0050b0a7
    fld dword ptr [4*ecx + 0x5670e4]             # 0050b0aa
    fsub dword ptr [4*ecx + 0x5670e0]            # 0050b0b1
    fild dword ptr [ebp + arg_8]                 # 0050b0b8
    lea eax, [4*ecx + 0x5670e0]                  # 0050b0bb
    fsubr qword ptr [ebp - local_8]              # 0050b0c2
    fmulp st(1), st                              # 0050b0c5
    fadd dword ptr [eax]                         # 0050b0c7
    {load} mov esp, ebp                          # 0050b0c9
    pop ebp                                      # 0050b0cb
    ret                                          # 0050b0cc

# --- data items (not part of the function) -------------------------
.org 0x0050b0cd - 0x401000
PAD_0050b0cd:  # 3 byte(s) of nop padding
    .fill 3, 1, 0x90

