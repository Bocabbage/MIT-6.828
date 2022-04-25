// implement fork from user space

#include <inc/string.h>
#include <inc/lib.h>

// PTE_COW marks copy-on-write page table entries.
// It is one of the bits explicitly allocated to user processes (PTE_AVAIL).
#define PTE_COW		0x800

extern void _pgfault_upcall(void);

//
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
	void *addr = (void *) utf->utf_fault_va;
	uint32_t err = utf->utf_err;
	int r;

	// Check that the faulting access was (1) a write, and (2) to a
	// copy-on-write page.  If not, panic.
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	if(!(
			(uvpt[PGNUM(addr)] & PTE_COW) &&
			(err & FEC_WR)
		)
	)
	{ panic("pgfault panic!"); }
	

	// Allocate a new page, map it at a temporary location (PFTEMP),
	// copy the data from the old page to the new page, then move the new
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.

	// LAB 4: Your code here.
	envid_t envId = sys_getenvid();	// Don't use curenv->env_id!
	if(sys_page_alloc(envId, (void *)(PFTEMP), PTE_P | PTE_U | PTE_W) < 0)
		panic("sys_page_alloc failed in pgfault().");

	// memory-move
	memmove((void *)PFTEMP, (void *)(ROUNDDOWN(addr, PGSIZE)), PGSIZE);

	if(sys_page_map(
		envId, (void *)(PFTEMP), 
		envId, (void *)(ROUNDDOWN(addr, PGSIZE)),
		PTE_P | PTE_W | PTE_U) < 0
	)
	{ panic("sys_page_map failed in pgfault().");; }

	if(sys_page_unmap(envId, (void *)(PFTEMP)) < 0)
		panic("sys_page_unmap failed in pgfault().");
	
	

}

//
// Map our virtual page pn (address pn*PGSIZE) into the target envid
// at the same virtual address.  If the page is writable or copy-on-write,
// the new mapping must be created copy-on-write, and then our mapping must be
// marked copy-on-write as well.  (Exercise: Why do we need to mark ours
// copy-on-write again if it was already copy-on-write at the beginning of
// this function?)
//
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
	// LAB 4: Your code here.
	// map for child
	if((uvpt[pn] & PTE_W) || (uvpt[pn] & PTE_COW))
	{
		int r = sys_page_map(
			0, (void *)(pn*PGSIZE),
			envid, (void *)(pn*PGSIZE),
			PTE_COW | PTE_U | PTE_P
		);
		if(r < 0)
			return -1;
		
		// remap for thisenv
		r = sys_page_map(
			0, (void *)(pn*PGSIZE),
			0, (void *)(pn*PGSIZE),
			PTE_COW | PTE_U | PTE_P
		);
		if(r < 0)
			return -1;
	}
	else
	{
		int r = sys_page_map(
			0, (void *)(pn*PGSIZE),
			envid, (void *)(pn*PGSIZE),
			PTE_U | PTE_P
		);
		if(r < 0)
			return -1;
	}
	
	return 0;
}

//
// User-level fork with copy-on-write.
// Set up our page fault handler appropriately.
// Create a child.
// Copy our address space and page fault handler setup to the child.
// Then mark the child as runnable and return.
//
// Returns: child's envid to the parent, 0 to the child, < 0 on error.
// It is also OK to panic on error.
//
// Hint:
//   Use uvpd, uvpt, and duppage.
//   Remember to fix "thisenv" in the child process.
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
	// LAB 4: Your code here.
	set_pgfault_handler(pgfault);
	envid_t newChildId = sys_exofork();
	if(newChildId < 0)
		return -1;
	
	// for child-process
	if(newChildId == 0)
	{
		thisenv = envs + ENVX(sys_getenvid());
		return 0;
	}

	// allocate a page for child-exception-stack
	if(sys_page_alloc(newChildId, (void *)(UXSTACKTOP-PGSIZE), PTE_W | PTE_U | PTE_P) < 0)
		return -1;
	
	// set child-pgfault-upcall
	sys_env_set_pgfault_upcall(newChildId, (void *)_pgfault_upcall);

	// copy the map into child
	uintptr_t addr;
	for(addr = 0; addr < USTACKTOP; addr += PGSIZE)
		if((uvpd[PDX(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_P))
			duppage(newChildId, PGNUM(addr));

	// set child to be runnable
	if(sys_env_set_status(newChildId, ENV_RUNNABLE) < 0)
		return -1;

	return newChildId;
}

// Challenge!
int
sfork(void)
{
	panic("sfork not implemented");
	return -E_INVAL;
}
