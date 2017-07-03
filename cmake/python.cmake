INCLUDE(FindPythonInterp)

FILE(GLOB_RECURSE py_proto_files RELATIVE ${CMAKE_CURRENT_SOURCE_DIR} ortools/constraint_solver/*.proto ortools/linear_solver/*.proto)
LIST(REMOVE_ITEM py_proto_files "ortools/constraint_solver/demon_profiler.proto")
PROTOBUF_GENERATE_PYTHON(PROTO_PY_SRCS ${py_proto_files})
ADD_CUSTOM_TARGET(Py${PROJECT_NAME}proto ALL DEPENDS ${PROTO_PY_SRCS})

IF(BUILD_CXX)
    ADD_DEPENDENCIES(Py${PROJECT_NAME}proto ${PROJECT_NAME})
ENDIF()

IF(${PYTHON_VERSION_STRING} VERSION_GREATER 3)
    SET(CMAKE_SWIG_FLAGS "-py3;-DPY3")
ENDIF()

INCLUDE_DIRECTORIES(${PYTHON_INCLUDE_PATH})

FILE(COPY
    ${CMAKE_CURRENT_SOURCE_DIR}/ortools/__init__.py
    DESTINATION
    ${CMAKE_CURRENT_BINARY_DIR}/ortools/)

FILE(COPY
    ${CMAKE_CURRENT_SOURCE_DIR}/ortools/__init__.py
    DESTINATION
    ${CMAKE_CURRENT_BINARY_DIR}/ortools/constraint_solver/)

FILE(COPY
    ${CMAKE_CURRENT_SOURCE_DIR}/ortools/__init__.py
    DESTINATION
    ${CMAKE_CURRENT_BINARY_DIR}/ortools/linear_solver/)

FILE(COPY
    ${CMAKE_CURRENT_SOURCE_DIR}/ortools/__init__.py
    DESTINATION
    ${CMAKE_CURRENT_BINARY_DIR}/ortools/graph/)

FILE(COPY
    ${CMAKE_CURRENT_SOURCE_DIR}/ortools/__init__.py
    DESTINATION
    ${CMAKE_CURRENT_BINARY_DIR}/ortools/algorithms/)

FILE(COPY
    ${CMAKE_CURRENT_SOURCE_DIR}/ortools
    DESTINATION
    ${CMAKE_CURRENT_BINARY_DIR}
    FILES_MATCHING
    PATTERN
    "*.i")

FILE(COPY
    ${CMAKE_CURRENT_SOURCE_DIR}/README
    DESTINATION
    ${CMAKE_CURRENT_BINARY_DIR})

FILE(COPY
    ${CMAKE_CURRENT_SOURCE_DIR}/ortools/linear_solver/linear_solver_natural_api.py
    DESTINATION
    ${CMAKE_CURRENT_BINARY_DIR}/ortools/linear_solver/)

FILE(COPY
    ${CMAKE_CURRENT_SOURCE_DIR}/python/MANIFEST.in
    DESTINATION
    ${CMAKE_CURRENT_BINARY_DIR}/)
SET(README_FILE README)

GET_PROPERTY(CMAKE_INCLUDE_DIRS DIRECTORY PROPERTY INCLUDE_DIRECTORIES)
CONFIGURE_FILE(${CMAKE_CURRENT_SOURCE_DIR}/python/setup.py.in ${CMAKE_CURRENT_BINARY_DIR}/setup.py)

SET(PY_OUTPUT ${CMAKE_CURRENT_BINARY_DIR}/timestamp)
ADD_CUSTOM_COMMAND(
    OUTPUT ${PY_OUTPUT}
    COMMAND ${PYTHON_EXECUTABLE} ${CMAKE_CURRENT_BINARY_DIR}/setup.py sdist
    COMMAND ${CMAKE_COMMAND} -E touch ${PY_OUTPUT}
    DEPENDS ${CMAKE_CURRENT_SOURCE_DIR}/ortools/__init__.py)
ADD_CUSTOM_TARGET(py${PROJECT_NAME} ALL DEPENDS ${PY_OUTPUT})

IF(BUILD_CXX)
    ADD_DEPENDENCIES(py${PROJECT_NAME} ${PROJECT_NAME})
ENDIF()
