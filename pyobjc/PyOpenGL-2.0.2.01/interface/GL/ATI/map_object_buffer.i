/*
# AUTOGENERATED DO NOT EDIT

# If you edit this file, delete the AUTOGENERATED line to prevent re-generation
# BUILD api_versions [0x001]
*/

%module map_object_buffer

#define __version__ "$Revision: 1.1.2.1 $"
#define __date__ "$Date: 2004/11/15 07:38:07 $"
#define __api_version__ API_VERSION
#define __author__ "PyOpenGL Developers <pyopengl-devel@lists.sourceforge.net>"
#define __doc__ ""

%{
/**
 *
 * GL.ATI.map_object_buffer Module for PyOpenGL
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

#if !EXT_DEFINES_PROTO || !defined(GL_ATI_map_object_buffer)
DECLARE_EXT(glMapObjectBufferATI, GLvoid*, 0, (GLuint buffer), (buffer))
DECLARE_VOID_EXT(glUnmapObjectBufferATI, (GLuint buffer), (buffer))
#endif
%}

/* FUNCTION DECLARATIONS */
GLvoid* glMapObjectBufferATI(GLuint buffer);
DOC(glMapObjectBufferATI, "glMapObjectBufferATI(buffer)")
void glUnmapObjectBufferATI(GLuint buffer);
DOC(glUnmapObjectBufferATI, "glUnmapObjectBufferATI(buffer)")

/* CONSTANT DECLARATIONS */



%{
static char *proc_names[] =
{
#if !EXT_DEFINES_PROTO || !defined(GL_ATI_map_object_buffer)
"glMapObjectBufferATI",
"glUnmapObjectBufferATI",
#endif
	NULL
};

#define glInitMapObjectBufferATI() InitExtension("GL_ATI_map_object_buffer", proc_names)
%}

int glInitMapObjectBufferATI();
DOC(glInitMapObjectBufferATI, "glInitMapObjectBufferATI() -> bool")

%{
PyObject *__info()
{
	if (glInitMapObjectBufferATI())
	{
		PyObject *info = PyList_New(0);
		return info;
	}
	
	Py_INCREF(Py_None);
	return Py_None;
}
%}

PyObject *__info();

