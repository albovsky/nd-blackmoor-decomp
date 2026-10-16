# FUN_0050b030
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0050b030
# extent:       0x0050b030-0x0050b077 (71 code bytes)
# span:         0x0050b030-0x0050b080 (code 71, tables 0, padding 9)
# sha256:       3a99b6b5eaa7698e4de993d3aed6b27b5269828d2f8eb5d51cb23d60080e0fcc
# evidence:     ev_14398f730fa9c49e7db80307b54fbb5d04baa803ce1c29895906ff2fa90b272c
# region:       vorbis
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0050b030
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       2 ebp-relative slot(s): local_8, local_10
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/his_audio.c:his_audio_decode_memory (function ledger class host_adapter_tested; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 21 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_8, 0x8  # offset -0x8
.equ local_10, 0x10  # offset -0x10
.equ arg_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------

.org 0x0050b030 - 0x401000
.globl FUN_0050b030
FUN_0050b030:
    # block 0x0050b030: entry, 21 instruction(s), ends with ret
    push ebp                                     # 0050b030
    {load} mov ebp, esp                          # 0050b031
    sub esp, 0x10                                # 0050b033
    fld dword ptr [ebp + arg_8]                  # 0050b036
    fmul qword ptr [0x52e650]                    # 0050b039
    fst qword ptr [ebp - local_8]                # 0050b03f
    fsub qword ptr [0x52cac0]                    # 0050b042
    fstp qword ptr [ebp - local_10]              # 0050b048
    fld qword ptr [ebp - local_10]               # 0050b04b
    fistp dword ptr [ebp + arg_8]                # 0050b04e
    mov ecx, dword ptr [ebp + arg_8]             # 0050b051
    fld dword ptr [4*ecx + 0x566ee0]             # 0050b054
    fsub dword ptr [4*ecx + 0x566edc]            # 0050b05b
    fild dword ptr [ebp + arg_8]                 # 0050b062
    lea eax, [4*ecx + 0x566edc]                  # 0050b065
    fsubr qword ptr [ebp - local_8]              # 0050b06c
    fmulp st(1), st                              # 0050b06f
    fadd dword ptr [eax]                         # 0050b071
    {load} mov esp, ebp                          # 0050b073
    pop ebp                                      # 0050b075
    ret                                          # 0050b076

# --- data items (not part of the function) -------------------------
.org 0x0050b077 - 0x401000
PAD_0050b077:  # 9 byte(s) of nop padding
    .fill 9, 1, 0x90

