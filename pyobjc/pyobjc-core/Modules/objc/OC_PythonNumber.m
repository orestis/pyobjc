#include "pyobjc.h"

@implementation OC_PythonNumber

+ newWithPythonObject:(PyObject*)v;
{
	OC_PythonNumber* res;

	res = [[OC_PythonNumber alloc] initWithPythonObject:v];
	[res autorelease];
	return res;
}

- initWithPythonObject:(PyObject*)v;
{
	self = [super init];
	if (unlikely(self == nil)) return nil;

	Py_INCREF(v);
	Py_XDECREF(value);
	value = v;
	return self;
}

-(PyObject*)__pyobjc_PythonObject__
{
	Py_INCREF(value);
	return value;
}

-(PyObject*)__pyobjc_PythonTransient__:(int*)cookie
{
	*cookie = 0;
	Py_INCREF(value);
	return value;
}

-(void)release
{
	/* See comment in OC_PythonUnicode */
	PyObjC_BEGIN_WITH_GIL
		[super release];
	PyObjC_END_WITH_GIL
}

-(void)dealloc
{
	PyObjC_BEGIN_WITH_GIL
		PyObjC_UnregisterObjCProxy(value, self);
		Py_XDECREF(value);

	PyObjC_END_WITH_GIL

	[super dealloc];
}

-(const char*)objCType
{
	PyObjC_BEGIN_WITH_GIL
		if (PyBool_Check(value)) {
			PyObjC_GIL_RETURN(@encode(BOOL));
		} else if (PyFloat_Check(value)) {
			PyObjC_GIL_RETURN(@encode(double));
		} else if (PyInt_Check(value)) {
			PyObjC_GIL_RETURN(@encode(long));
		} else if (PyLong_Check(value)) {
			PyObjC_GIL_RETURN(@encode(long long));
		} 
	PyObjC_END_WITH_GIL
	[NSException raise:NSInvalidArgumentException 
		    format:@"Cannot determine objective-C type of this number"];
	return @encode(char);
}

-(void)getValue:(void*)buffer
{
	const char* encoded = [self objCType];
	int r;
	PyObjC_BEGIN_WITH_GIL
		r = depythonify_c_value(encoded, value, buffer);
		if (r == -1) {
			PyObjC_GIL_FORWARD_EXC();
		}
	PyObjC_END_WITH_GIL
}

/* TODO:
-(BOOL)isEqualToValue:(NSValue*)other
  // convert other to Python, then use python's comparison operators to
  // check for equality.
}
*/


-(BOOL)boolValue
{
	return (BOOL)PyObject_IsTrue(value);
}

-(char)charValue
{
	return (char)[self longLongValue];
}

-(NSDecimal)decimalValue
{
	/* FIXME */
	[NSException raise:NSInvalidArgumentException
	              format:@"Cannot convert python number to NSDecimal"];
}

-(double)doubleValue
{
	PyObjC_BEGIN_WITH_GIL
		if (PyFloat_Check(value)) {
			PyObjC_GIL_RETURN(PyFloat_AsDouble(value));
		} 
	PyObjC_END_WITH_GIL
	return (double)[self longLongValue];
}

-(float)floatValue
{
	return (float)[self doubleValue];
}

-(NSInteger)integerValue
{
	return (NSInteger)[self longLongValue];
}

-(int)intValue
{
	return (int)[self longLongValue];
}


-(long)longValue
{
	return (long)[self longLongValue];
}

-(short)shortValue
{
	return (short)[self longLongValue];
}


-(unsigned char)unsignedCharValue
{
	return (unsigned char)[self unsignedLongLongValue];
}
-(NSUInteger)unsignedIntegerValue
{
	return (NSUInteger)[self unsignedLongLongValue];
}
-(unsigned int)unsignedIntValue
{
	return (unsigned int)[self unsignedLongLongValue];
}
-(unsigned long)unsignedLongValue
{
	return (unsigned long)[self unsignedLongLongValue];
}
-(unsigned short)unsignedShortValue
{
	return (unsigned short)[self unsignedLongLongValue];
}

-(long long)longLongValue
{
	long long result;

	PyObjC_BEGIN_WITH_GIL
		if (PyInt_Check(value)) {
			result =  PyInt_AsLong(value);
			PyObjC_GIL_RETURN(result);
		} else if (PyFloat_Check(value)) {
			result =  (long long)PyFloat_AsDouble(value);
			PyObjC_GIL_RETURN(result);
		} else if (PyLong_Check(value)) {
			result =  PyLong_AsLongLong(value);
			PyObjC_GIL_RETURN(result);
		}
	PyObjC_END_WITH_GIL

	[NSException raise:NSInvalidArgumentException 
		    format:@"Cannot determine objective-C type of this number"];
	return -1;
}

-(unsigned long long)unsignedLongLongValue
{
	unsigned long long result;

	PyObjC_BEGIN_WITH_GIL
		if (PyInt_Check(value)) {
			result =  (unsigned long long)PyInt_AsLong(value);
			PyObjC_GIL_RETURN(result);
		} else if (PyFloat_Check(value)) {
			result =  (unsigned long long)PyFloat_AsDouble(value);
			PyObjC_GIL_RETURN(result);
		} else if (PyLong_Check(value)) {
			result =  PyLong_AsUnsignedLongLong(value);
			PyObjC_GIL_RETURN(result);
		}
	PyObjC_END_WITH_GIL

	[NSException raise:NSInvalidArgumentException 
		    format:@"Cannot determine objective-C type of this number"];
	return -1;
}

-(NSString*)description
{
	return [self stringValue];
}

-(NSString*)descriptionWithLocale:(NSObject*)locale
{
	/* FIXME: use locale information to format */
	 /* TODO: compare with regular NSNumber */
	(void)locale;
	return [self stringValue];
}

-(NSString*)stringValue
{
	PyObject* repr;
	NSObject* result = nil;

	PyObjC_BEGIN_WITH_GIL
		repr = PyObject_Repr(value);
		if (repr == NULL) {
			PyObjC_GIL_FORWARD_EXC();
		}
	
		result = PyObjC_PythonToId(repr);
		if (PyErr_Occurred()) {
			PyObjC_GIL_FORWARD_EXC();
		}

		Py_DECREF(repr);

	PyObjC_END_WITH_GIL
	return (NSString*)result;
}

/* NSCoding support */

- (void)encodeWithCoder:(NSCoder*)coder
{
	PyObjC_encodeWithCoder(value, coder);
}


/* 
 * Helper method for initWithCoder, needed to deal with
 * recursive objects (e.g. o.value = o)
 */
-(void)pyobjcSetValue:(NSObject*)other
{
	PyObject* v = PyObjC_IdToPython(other);
	Py_XDECREF(value);
	value = v;
}

- initWithCoder:(NSCoder*)coder
{
	if (PyObjC_Decoder != NULL) {
		PyObjC_BEGIN_WITH_GIL
			PyObject* cdr = PyObjC_IdToPython(coder);
			if (cdr == NULL) {
				PyObjC_GIL_FORWARD_EXC();
			}

			PyObject* setValue;
			PyObject* selfAsPython = PyObjCObject_New(self, 0, YES);
			setValue = PyObject_GetAttrString(selfAsPython, "pyobjcSetValue_");

			PyObject* v = PyObject_CallFunction(PyObjC_Decoder, "OO", cdr, setValue);
			Py_DECREF(cdr);
			Py_DECREF(setValue);
			Py_DECREF(selfAsPython);

			if (v == NULL) {
				PyObjC_GIL_FORWARD_EXC();
			}

			Py_XDECREF(value);
			value = v;

			NSObject* proxy = PyObjC_FindObjCProxy(value);
			if (proxy == NULL) {
				PyObjC_RegisterObjCProxy(value, self);
			} else {
				[self release];
				[proxy retain];
				self = (OC_PythonObject*)proxy;
			}


		PyObjC_END_WITH_GIL

		return self;

	} else {
		[NSException raise:NSInvalidArgumentException
				format:@"decoding Python objects is not supported"];
		return nil;

	}
}

#if 1

-(NSObject*)replacementObjectForArchiver:(NSObject*)archiver
{
	(void)archiver;
	return (NSObject*)self;
}

-(NSObject*)replacementObjectForKeyedArchiver:(NSObject*)archiver
{
	(void)archiver;
	return (NSObject*)self;
}

-(NSObject*)replacementObjectForCoder:(NSObject*)archiver
{
	(void)archiver;
	return (NSObject*)self;
}

-(NSObject*)replacementObjectForPortCoder:(NSObject*)archiver
{
	(void)archiver;
	return (NSObject*)self;
}

-(Class)classForArchiver
{
	return [OC_PythonNumber class];
}

-(Class)classForKeyedArchiver
{
	return [OC_PythonNumber class];
}

+(Class)classForUnarchiver
{
	return [OC_PythonNumber class];
}

+(Class)classForKeyedUnarchiver
{
	return [OC_PythonNumber class];
}

-(Class)classForCoder
{
	return [OC_PythonNumber class];
}

-(Class)classForPortCoder
{
	return [OC_PythonNumber class];
}

#endif
@end
