// implement fork from user space

#include <inc/string.h>
#include <inc/lib.h>

// PTE_COW marks copy-on-write page table entries.
// It is one of the bits explicitly allocated to user processes (PTE_AVAIL).
#define PTE_COW		0x800

//
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
extern void _pgfault_upcall(void);

static pte_t get_pte(void* addr)
{
	if((uvpd[PDX((uintptr_t)addr)] & PTE_P) == 0)
		return 0;
	return uvpt[PGNUM((uintptr_t)addr)];
}

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
	// if(!(err & FEC_WR) || !(uvpt[PGNUM(addr)] & PTE_COW))
	// 	panic("pgfault error: the page has no copy-on-write or write flag.");
	if(!(err & FEC_WR) || !(get_pte(addr) & PTE_COW))
		panic("pgfault error: the page has no copy-on-write or write flag.");



	// Allocate a new page, map it at a temporary location (PFTEMP),
	// copy the data from the old page to the new page, then move the new
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.
	// LAB 4: Your code here.
	envid_t envId = sys_getenvid();
	addr = ROUNDDOWN(addr, PGSIZE);
	if(sys_page_alloc(envId, PFTEMP, PTE_U | PTE_P | PTE_W) < 0)
		panic("pgfault error: sys_page_alloc failed.");
	memmove(PFTEMP, addr, PGSIZE);
	if(sys_page_map(envId, PFTEMP, envId, addr, PTE_U | PTE_P | PTE_W) < 0)
		panic("pgfault error: sys_page_map failed.");
	if(sys_page_unmap(envId, PFTEMP) < 0)
		panic("pgfault error: sys_page_unmap failed.");

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
	// pn: page number
	void* addr = (void *)(pn * PGSIZE);
	pte_t pte = get_pte(addr);
	if(!(pte & PTE_P))
		return -1;
	if((pte & PTE_W) || (pte & PTE_COW))
	{	
		if(sys_page_map(0, addr, envid, addr, PTE_P | PTE_COW | PTE_U) < 0)
			panic("duppage failed: sys_page_map error.");
		if(sys_page_map(0, addr, 0, addr, PTE_U | PTE_P | PTE_COW) < 0)
			panic("duppage failed: sys_page_map error.");
	}
	else
	{
		// The page is read-only
		if(sys_page_map(0, addr, envid, addr, PTE_P | PTE_U) < 0)
			panic("duppage failed: sys_page_map error.");
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
	// Step1: install the pgfault() as the C-level page fault handler.
	set_pgfault_handler(pgfault);
	// Step2: create a child environment.
	envid_t envId = sys_exofork();
	if(envId == 0)
	{
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	// Step3: copy the address map of the parent to the child.
	uint32_t addr;
	for(addr = 0; addr < USTACKTOP; addr += PGSIZE)
		if((uvpd[PDX(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_P))
			duppage(envId, PGNUM(addr));
	// Step4: allocate user-exception stack
	if(sys_page_alloc(envId, (void *)(UXSTACKTOP - PGSIZE), PTE_U | PTE_P | PTE_W) < 0)
		panic("fork failed: error happened in sys_page_alloc.");
	// Step5: set up the pgfault handler upcall
	sys_env_set_pgfault_upcall(envId, _pgfault_upcall);
	// Step6: set the status of the child to be 'RUNNABLE'
	if(sys_env_set_status(envId, ENV_RUNNABLE) < 0)
		panic("fork failed: error happened in sys_env_set_status.");

	return envId;

}

// Challenge!
int
sfork(void)
{
	panic("sfork not implemented");
	return -E_INVAL;
}
