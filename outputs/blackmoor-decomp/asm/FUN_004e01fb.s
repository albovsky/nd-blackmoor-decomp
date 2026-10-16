# FUN_004e01fb
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004e01fb
# extent:       0x004e01fb-0x004e023b (64 code bytes)
# span:         0x004e01fb-0x004e023b (code 64, tables 0, padding 0)
# sha256:       baf22ce0e8476d789170dceef78b8fe7cf3e9b82af1b4b90308efb86f364202a
# evidence:     ev_9518a8d38812b37051c445b712839a110fe36a23c18959a042dc948141dd9772
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004e01fb
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none: no [ebp-n] slot referenced
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_004c5377
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 17 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------

# --- external targets -----------------------------------------------
.set FUN_004c5377, .text + (0x004c5377 - 0x401000)

.org 0x004e01fb - 0x401000
.globl FUN_004e01fb
FUN_004e01fb:
    # block 0x004e01fb: entry, 17 instruction(s), calls FUN_004c5377, ends with ret
    push ebp                                     # 004e01fb
    {load} mov ebp, esp                          # 004e01fc
    push 0x55ba9c                                # 004e01fe
    mov eax, dword ptr [0x5d2821]                # 004e0203
    push eax                                     # 004e0208
    mov ecx, dword ptr [0x5d281d]                # 004e0209
    push ecx                                     # 004e020f
    mov edx, dword ptr [0x5cf665]                # 004e0210
    push edx                                     # 004e0216
    mov eax, dword ptr [0x5d2819]                # 004e0217
    push eax                                     # 004e021c
    mov ecx, 0x5cf659                            # 004e021d
    call FUN_004c5377                            # 004e0222
    mov word ptr [0x5bb1c4], 0x2                 # 004e0227
    mov word ptr [0x63a9d0], 0x0                 # 004e0230
    pop ebp                                      # 004e0239
    ret                                          # 004e023a

