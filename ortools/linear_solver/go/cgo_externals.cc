#ifdef __cplusplus
extern "C" {
#endif

__declspec(dllexport) void (*crosscall2_ptr)(void (*fn)(void *, int), void *, int);
void crosscall2(void (*fn)(void *, int), void * void_ptr, int someInt) {
	crosscall2_ptr(fn, void_ptr, someInt); 
}

__declspec(dllexport) char* (*_cgo_topofstack_ptr)(void);
char* _cgo_topofstack(void) {
    return _cgo_topofstack_ptr();
}

__declspec(dllexport) void (*_cgo_allocate_ptr)(void *, int);
void _cgo_allocate(void * void_ptr, int someInt) {
	_cgo_allocate_ptr(void_ptr, someInt);
}

__declspec(dllexport) void (*_cgo_panic_ptr)(void *, int);
void _cgo_panic(void * void_ptr, int someInt) {
    	_cgo_panic_ptr(void_ptr, someInt);
}
#ifdef __cplusplus
}
#endif
