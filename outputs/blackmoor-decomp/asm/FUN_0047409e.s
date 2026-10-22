# FUN_0047409e
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0047409e
# extent:       0x0047409e-0x004740e5 (71 code bytes)
# span:         0x0047409e-0x004740e5 (code 71, tables 0, padding 0)
# sha256:       3b1b5de134cd3bcf9d46c1130abb861488e367717e8a5ab04d30fe0f0decc6ca
# evidence:     ev_4142f99cf250975ea00b2347f810409c5bbf0cca5348258d5fd0578a4530c136
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0047409e
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl25a.c:m473206_click (function ledger class candidate_port; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 16 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------

.org 0x0047409e - 0x401000
.globl FUN_0047409e
FUN_0047409e:
    # block 0x0047409e: entry, 16 instruction(s), ends with ret
    push ebp                                     # 0047409e
    {load} mov ebp, esp                          # 0047409f
    push ecx                                     # 004740a1
    mov dword ptr [ebp - local_4], ecx           # 004740a2
    mov dword ptr [0x5b44f4], 0x1                # 004740a5
    mov eax, dword ptr [0x5b44f0]                # 004740af
    shl eax, 0x5                                 # 004740b4
    mov ecx, dword ptr [0x5b44f4]                # 004740b7
    shl ecx, 0x4                                 # 004740bd
    lea edx, [eax + ecx + 0x5b160c]              # 004740c0
    mov dword ptr [0x5d1631], edx                # 004740c7
    mov dword ptr [0x5d1639], 0x1                # 004740cd
    mov dword ptr [0x5c39e5], 0x27a2             # 004740d7
    {load} mov esp, ebp                          # 004740e1
    pop ebp                                      # 004740e3
    ret                                          # 004740e4

