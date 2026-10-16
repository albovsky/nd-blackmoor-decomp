# FUN_004bf61f
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004bf61f
# extent:       0x004bf61f-0x004bf63b (28 code bytes)
# span:         0x004bf61f-0x004bf63b (code 28, tables 0, padding 0)
# sha256:       db7743c04ec9048c5f9219337d5dae4393ccf50ab31e6644da643015d53b4db3
# evidence:     ev_9b97a3dfc13c18288f6cf40dd7f15c3bf5b969f690eaa08654df89043c2c39c3
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004bf61f
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_004bf8a7
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 11 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------
.set FUN_004bf8a7, .text + (0x004bf8a7 - 0x401000)

.org 0x004bf61f - 0x401000
.globl FUN_004bf61f
FUN_004bf61f:
    # block 0x004bf61f: entry, 11 instruction(s), calls FUN_004bf8a7, ends with ret
    push ebp                                     # 004bf61f
    {load} mov ebp, esp                          # 004bf620
    push ecx                                     # 004bf622
    mov dword ptr [ebp - local_4], ecx           # 004bf623
    mov eax, dword ptr [ebp - local_4]           # 004bf626
    mov dword ptr [eax], 0x52e214                # 004bf629
    mov ecx, dword ptr [ebp - local_4]           # 004bf62f
    call FUN_004bf8a7                            # 004bf632
    {load} mov esp, ebp                          # 004bf637
    pop ebp                                      # 004bf639
    ret                                          # 004bf63a

