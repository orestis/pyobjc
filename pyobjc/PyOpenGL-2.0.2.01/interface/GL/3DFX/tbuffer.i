/*
# AUTOGENERATED DO NOT EDIT

# If you edit this file, delete the AUTOGENERATED line to prevent re-generation
# BUILD api_versions [0x001]
*/

%module tbuffer

#define __version__ "$Revision: 1.1.2.1 $"
#define __date__ "$Date: 2004/11/15 07:38:07 $"
#define __api_version__ API_VERSION
#define __author__ "PyOpenGL Developers <pyopengl-devel@lists.sourceforge.net>"
#define __doc__ ""

%{
/**
 *
 * GL.3DFX.tbuffer Module for PyOpenGL
 * 
 * Authors: PyOpenGL Developers <pyopengl-devel@lists.sourceforge.net>
 * 
***/
%}

%include util.inc
%include gl_exception_handler.inc

%{
#ifdef CGL_PLATFORM
# include <OpenGL/glext.h>
#else
# include <GL/glext.h>
#endif

#if !EXT_DEFINES_PROTO || !defined(GL_3DFX_tbuffer)
DECLARE_VOID_EXT(glTbufferMask3DFX, (GLuint mask), (mask))
#endif
%}

/* FUNCTION DECLARATIONS */
void glTbufferMask3DFX(GLuint mask);
DOC(glTbufferMask3DFX, "glTbufferMask3DFX(mask)")

/* CONSTANT DECLARATIONS */



%{
static char *proc_names[] =
{
#if !EXT_DEFINES_PROTO || !defined(GL_3DFX_tbuffer)
"glTbufferMask3DFX",
#endif
	NULL
};

#define glInitTbuffer3DFX() InitExtension("GL_3DFX_tbuffer", proc_names)
%}

int glInitTbuffer3DFX();
DOC(glInitTbuffer3DFX, "glInitTbuffer3DFX() -> bool")

%{
PyObject *__info()
{
	if (glInitTbuffer3DFX())
	{
		PyObject *info = PyList_New(0);
		return info;
	}
	
	Py_INCREF(Py_None);
	return Py_None;
}
%}

PyObject *__info();

