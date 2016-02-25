#ifndef ARG_X86_64_VMA_H
#define ARG_X86_64_VMA_H

/** Returns 1, if the vma should be ignored by checkpointing componenet */
#define vma_ignore(ckpt, vma) ({ \
	int res = 0; \
 \
	/* 32 bit applications emulated on 64 kernel have manually mapped vsyscall pages.. these should NOT be migrated */ \
	if ( ckpt->hdr.is_32bit_application && vma->vm_start == 0xffffe000 ) \
		res = 1; \
    /* skip vvar page */ \
	else if (vma->vm_private_data && ((struct vm_special_mapping *)(vma->vm_private_data))->name && !strcmp(((struct vm_special_mapping *)(vma->vm_private_data))->name, "[vvar]")) \
		res = 2;  \
	res; \
})

#endif
