#include "pyobjc.h"
#include "objc_support.h"

static PyObject*
call_NSObject_alloc(PyObject* method, PyObject* self, PyObject* arguments)
{
	id result = nil;

	if (PyArg_ParseTuple(arguments, "") < 0) {
		return NULL;
	}

	if (!ObjCClass_Check(self)) {
		PyErr_SetString(PyExc_TypeError, "Expecting class");
		return NULL;
	}

	NS_DURING
		result = [ObjCClass_GetClass(self) alloc];
	NS_HANDLER
		ObjCErr_FromObjC(localException);
		result = nil;
	NS_ENDHANDLER;

	if (result == nil && PyErr_Occurred()) {
		return NULL;
	}

	return pythonify_c_value("@", &result);
}

static PyObject*
supercall_NSObject_alloc(PyObject* method, PyObject* self, PyObject* arguments)
{
	id result = nil;
	struct objc_super super;

	if (PyArg_ParseTuple(arguments, "") < 0) {
		return NULL;
	}

	if (!ObjCClass_Check(self)) {
		PyErr_SetString(PyExc_TypeError, "Expecting class");
		return NULL;
	}

	super.receiver = (id)ObjCClass_GetClass(self);
	super.class = (Class)(super.receiver)->isa;

	NS_DURING
		result = objc_msgSendSuper(&super, @selector(alloc));
	NS_HANDLER
		ObjCErr_FromObjC(localException);
		result = nil;
	NS_ENDHANDLER;

	if (result == nil && PyErr_Occurred()) {
		return NULL;
	}

	return pythonify_c_value("@", &result);
}

static id 
imp_NSObject_alloc(id self, SEL sel)
{
	id objc_result;
	const char* err;
	PyObject* arglist;
	PyObject* result;

	arglist = PyTuple_New(0);
	if (arglist == NULL) {
		ObjCErr_ToObjC();
		return nil;
	}

	result = ObjC_call_to_python(self, sel, arglist);
	if (result == NULL) {
		ObjCErr_ToObjC();
		return nil;
	}

	err = depythonify_c_value("@", result, &objc_result);
	Py_DECREF(result);
	if (err) {
		PyErr_SetString(PyExc_ValueError, "Conversion failed");
		return NULL;
	}

	return objc_result;
}

int
ObjC_InstallAllocHack(void)
{
	return ObjC_RegisterMethodMapping(
		objc_lookUpClass("NSObject"),
		@selector(alloc),
		call_NSObject_alloc,
		supercall_NSObject_alloc,
		(IMP)imp_NSObject_alloc);
}	